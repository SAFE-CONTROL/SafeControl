function [] = postSimulationTimerFcn(obj)

if(strcmp(get_param(gcs,'SimulationStatus'),'stopped'))
    process_matfile;
    try
        disp(['Stopping ' get(obj,'Name')]);
        stop(obj);
    catch
        disp('Bad timer reference');
    end
end