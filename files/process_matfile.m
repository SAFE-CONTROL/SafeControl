%Source : https://fr.mathworks.com/matlabcentral/answers/103213-how-can-i-store-a-bus-signal-to-the-matlab-workspace-while-retaining-its-hierarchy-in-simulink-7-6

mdl = 'manual_scenario_builder';
blk = 'manual_scenario_builder/Main Bus Creator';

%busInfo = get(gcb);
busInfo = Simulink.Bus.createObject(mdl, blk);

%Find the bus structure from the Bus Creator block
num_el = [];
elemList = [];

try
    num_el = evalin('base', [busInfo.busName '.getNumLeafBusElements']);
catch
end

try
    elemList = evalin('base', [busInfo.busName '.getLeafBusElements']);
catch
end

%num_el
%elemList

%num_el = eval([busInfo.busName '.getNumLeafBusElements'],0);
%elemList = eval([busInfo.busName '.getLeafBusElements'],0);

load scenario;

%Assign the signal data to separate timeseries
for i = 1:num_el
    size = elemList(i).Dimensions;
    ts{i} = timeseries(data(i+1:i+size,:)',data(1,:)');
end

bus_scenario=Simulink.SimulationData.createStructOfTimeseries(busInfo.busName,ts)
%Convert the timeseries into a structure
save('scenario.mat','bus_scenario');
assignin('base','bus_scenario',bus_scenario);