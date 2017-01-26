% Check for dependancies
assertFileExists('scenario_builder');
assertFileExists('genStepSignal');

% Setting simulation parameters variables
start_time=0;
end_time=80;
sampling_step=0.01;

% Load scenario_builder simulink model
load_system('scenario_builder');

% Set simulink model 'scenario_builder' simulation parameters
set_param('scenario_builder',...
                'Solver','FixedStep',...
                'StartTime',num2str(0),...
                'StopTime',num2str(end_time),...
                'FixedStep',num2str(sampling_step));

load('failsafe_tests/perms_common.mat');
load('failsafe_tests/perms_trusts.mat');

% Get the intersection of test cases to process the only ones
% we are able to run on the 2 architectures for comparison

test_cases=intersect(perms_common,perms_trusts);

% Sort the test cases by ascending number of failures
[dummy index] = sort(cellfun('size', test_cases, 2), 'ascend');
test_cases=test_cases(index);

% Find all signal builders blocks
sb_blocks=find_system('scenario_builder','Tag','STV Subsys');

% Reset to 0 signal in all signalbuilders blocks
for j=1:size(sb_blocks,1)
    eval(['signalbuilder(''' strjoin(sb_blocks(j)) ''', ''set'', 1, 1, [start_time end_time], [0 0]);']);
end

for i=1:size(test_cases,1)
    % Convert cell to char array, interleave with blanks, and finally
    % convert the char array to a vector of values
    test_case=char(test_cases(i));
    n=size(test_case,2);
    spaces=blanks(n);
    test_case=[test_case;spaces];
    index_seq=str2num(test_case(:));
    time_seq=sort(rand(n,1)*(end_time-start_time)+start_time);
    
    % Reset all failures signals
    for j=1:6
        eval(['signalbuilder(''scenario_builder/CALCULATORS (POWER)/sb' num2str(j) ''', ''set'', 1, 1, [start_time end_time], [0 0]);']);
    end
    
    % Set signal blocks according to test case failures
    for j=1:n
        calculator_index=index_seq(j);
        step_time = time_seq(j);
        [time amplitude] = genStepSignal(start_time,step_time,end_time,0,1);
        eval(['signalbuilder(''scenario_builder/CALCULATORS (POWER)/sb' num2str(calculator_index) ''', ''set'', 1, 1, time, amplitude);']);
    end
    
    % Set name for output file
    output_filename=[char(test_cases(i)) '.mat'];
    set_param('scenario_builder/output_filename','FileName',['failsafe_tests/scenarios/' output_filename]);
    set_param('scenario_builder','SimulationCommand','start');

    if(strcmp(get_param('scenario_builder','SimulationStatus'),'running')==1)
        while(strcmp(get_param('scenario_builder','SimulationStatus'),'stopped')==0)
            pause(0.1);
        end
    end
end

close_system('scenario_builder',0);