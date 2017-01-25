function f_plot_results(export_matfile, export_png, plot_results, scenario_name)

close all;

% Prepare calculators related variables
for i=1:6
    i_str = num2str(i);
    
    % execute >> cX = commands.Data(X,:,:);
    evalin('base', ['c' i_str ' = commands.Data(' i_str ',:,:);']);
    % execute >> cX = c(:);
    evalin('base', ['c' i_str ' = c' i_str '(:);']);
    % execute >> rX = referee_trusts.Data(1,X,:);
    evalin('base', ['r' i_str ' = referee_trusts.Data(1,' i_str ',:);']);
    % execute >> rX = rX(:);
    evalin('base', ['r' i_str ' = r' i_str '(:);']);
end

figure;
figtitle('Calculators commands vs reference command ; and referee trust in calculators');
set(gcf, 'Position', get(0, 'Screensize'));

% Plotting calculators related data
for i=1:6
    i_str = num2str(i);
    
    evalin('base', ['subplot(2,3,' i_str ');']);
    evalin('base', ['[ax h1 h2] = plotyy(commands.Time, [c' i_str ' reference_command.Data], referee_trusts.Time, r' i_str ');']);
    evalin('base', 'set(h1(1), ''LineWidth'', 3);');
    evalin('base', 'set(h1(2), ''LineWidth'', 2);');
    evalin('base', 'set(h2, ''LineWidth'', 2);');
    evalin('base', ['title(''Calculator ' i_str ''');']);
    
    legend('Calculator command', 'Reference command', 'Referee trust', 'Location', 'SouthWest');
    grid on;
    evalin('base', 'ylabel(ax(1),''Command [V]'');');
    evalin('base', 'ylabel(ax(2),''Trust'');');
    xlabel('Time [s]');
end

% Export to png if needed
if(export_png)
    disp('Exporting png...');
    scenario_name=scenario_name(1:end-4)
    eval(['mkdir ' scenario_name]);
    
    set(gcf, 'PaperPositionMode','auto')   
    eval(['print(''-dpng'',''' scenario_name '\calculators_plot.png'');']);
end

figure;
figtitle('Most trusted calculator, referee command');
set(gcf, 'Position', get(0, 'Screensize'));

[ax h1 h2] = evalin('base','plotyy(commands.Time, [referee_command.Data(:) reference_command.Data], commands.Time, referee_valid_calculator.Data);');
set(h1(1), 'LineWidth', 3); set(h1(2), 'LineWidth', 2); set(h2, 'LineWidth', 2);
legend('Referee output command', 'Reference command', 'Index of calculator elected by the referee', 'Location', 'Best');
grid on;

% Export to png
if(export_png)
    set(gcf, 'PaperPositionMode','auto')   
    eval(['print(''-dpng'',''' scenario_name '\referee_plot.png'');']);
end