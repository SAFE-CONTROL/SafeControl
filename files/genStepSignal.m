function [time amplitude] = genStepSignal(start_time, step_time, end_time, start_value, end_value)

time=[start_time step_time step_time end_time];
amplitude=[start_value start_value end_value end_value];

end