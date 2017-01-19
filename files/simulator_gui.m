function varargout = simulator_gui(varargin)
% SIMULATOR_GUI MATLAB code for simulator_gui.fig
%      SIMULATOR_GUI, by itself, creates a new SIMULATOR_GUI or raises the existing
%      singleton*.
%
%      H = SIMULATOR_GUI returns the handle to a new SIMULATOR_GUI or the handle to
%      the existing singleton*.
%
%      SIMULATOR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULATOR_GUI.M with the given input arguments.
%
%      SIMULATOR_GUI('Property','Value',...) creates a new SIMULATOR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simulator_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simulator_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simulator_gui

% Last Modified by GUIDE v2.5 19-Jan-2017 15:29:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simulator_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @simulator_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before simulator_gui is made visible.
function simulator_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simulator_gui (see VARARGIN)

% Choose default command line output for simulator_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes simulator_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simulator_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

filename = 'simulator.slx';
if(exist(filename, 'file')~=4)
    h = errordlg(strcat('File ''',filename,''' not found'),'File Error','modal');
    uiwait(h);
    %close(handles.gui);
end

%close_system('simulator',0);
%open_system('simulator');
load_system('simulator');
display('simulator opened');
% add a handle to wksp values
handles.simulator_wksp = get_param('simulator','ModelWorkspace');
guidata(hObject,handles);

function initialize_gui(fig_handle, handles, isreset)
% If the simdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
display('initialization');

if isfield(handles, 'simdata') && ~isreset
    return;
end

if(exist('state.mat','file')==2) % TO BE CHANGED
    handles=load_state(handles);
else
    % We set default values and execute callbacks to update simulink
    % model
    display('loading default values');
end

% set(handles.unitgroup, 'SelectedObject', handles.english);
% 
% set(handles.gui_status, 'String', 'lb/cu.in');
% set(handles.text5, 'String', 'cu.in');
% set(handles.text6, 'String', 'lb');

% Update handles structure
guidata(handles.figure1, handles);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display('Starting simulation');
set(handles.gui_status,'String','running');
h = msgbox('Running simulation...','Information','help');
child = get(h,'Children');
delete(child(3));
drawnow;
set_param('simulator','SimulationCommand','start');
set(handles.gui_status,'String','idle');
drawnow;
delete(h);

% progress bar
%h=waitbar(x);
%set(h,'windowstyle','modal');

function simparam_te_Callback(hObject, eventdata, handles)
% hObject    handle to simparam_te (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of simparam_te as text
%        str2double(get(hObject,'String')) returns contents of simparam_te as a double
display('Te changed');
str=get(hObject,'String');
te=str2double(str);
valid_input=true;

if isnan(te)
    valid_input=false;
    str='1';
    set(hObject,'string',str);
elseif te<=0
    valid_input=false;
    str='1';
    set(hObject,'string',str);
end

if valid_input==false
    warndlg('Sampling period must be a strictly positive real scalar'); 
end

te=str2double(get(hObject,'String'));
assert(~(isnan(te)) && ~(te<=0));

% Update simulink model
get_param('simulator','FixedStep')

% Save GUI state
save_state(handles);



% --- Executes during object creation, after setting all properties.
function simparam_te_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simparam_te (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function simparam_duration_Callback(hObject, eventdata, handles)
% hObject    handle to simparam_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of simparam_duration as text
%        str2double(get(hObject,'String')) returns contents of simparam_duration as a double
display('Duration changed');
str=get(hObject,'String');
duration=str2double(str);
valid_input=true;

if isnan(duration)
    valid_input=false;
    str='1';
    set(hObject,'string',str);
elseif duration<=0
    valid_input=false;
    str='1';
    set(hObject,'string',str);
end

if valid_input==false
    warndlg('Duration must be a strictly positive real scalar'); 
end

duration=str2double(get(hObject,'String'));
assert(~(isnan(duration)) && ~(duration<=0));

% Update simulink model
set_param('simulator','StopTime',get(hObject,'String'));

% Save GUI state
save_state(handles);


%display('Eventdata:');
%eventdata



% --- Executes during object creation, after setting all properties.
function simparam_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simparam_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trustparam_rebuild_duration_Callback(hObject, eventdata, handles)
% hObject    handle to trustparam_rebuild_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trustparam_rebuild_duration as text
%        str2double(get(hObject,'String')) returns contents of trustparam_rebuild_duration as a double
display('Rebuild duration changed');
str=get(hObject,'String');
rebuild_duration=str2double(str);
te=str2double(get(handles.simparam_te,'String'));
valid_input=true;

if isnan(rebuild_duration)
    valid_input=false;
    str=num2str(max(te,10));
    set(hObject,'string',str);
elseif rebuild_duration<te
    valid_input=false;
    str=num2str(te);
    set(hObject,'string',str);
end

if valid_input==false
    warndlg('Rebuild duration must be a real scalar and greator or equal then simulation sampling period'); 
end

rebuild_duration=str2double(str);
assignin(handles.simulator_wksp,'incStep',te/rebuild_duration);
%getVariable(handles.simulator_wksp,'incStep') % FOR DEBUG PURPOSES

% Save GUI state
save_state(handles);



% --- Executes during object creation, after setting all properties.
function trustparam_rebuild_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trustparam_rebuild_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trustparam_lose_duration_Callback(hObject, eventdata, handles)
% hObject    handle to trustparam_lose_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trustparam_lose_duration as text
%        str2double(get(hObject,'String')) returns contents of trustparam_lose_duration as a double
display('Lose duration changed');
str=get(hObject,'String');
lose_duration=str2double(str);
te=str2double(get(handles.simparam_te,'String'));
valid_input=true;

if isnan(lose_duration)    
    valid_input=false;
    str=num2str(max(te,0.1));
    set(hObject,'string',str);
elseif lose_duration<te
    valid_input=false;
    str=num2str(te);
    set(hObject,'string',str);
end

if valid_input==false
    warndlg('Lose duration must be a real scalar and greater or equal then simulation sampling period'); 
end

lose_duration = str2double(get(hObject,'String'));
assert(~(isnan(lose_duration)) && ~(lose_duration<te));
assignin(handles.simulator_wksp,'decStep',te/lose_duration);

% Save GUI state
save_state(handles);



function isValidLoseDuration()
% 

% --- Executes during object creation, after setting all properties.
function trustparam_lose_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trustparam_lose_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in resultsparam_export_png.
function resultsparam_export_png_Callback(hObject, eventdata, handles)
% hObject    handle to resultsparam_export_png (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of resultsparam_export_png
display('Export to .png');
display(get(handles.resultsparam_export_png,'Value'));
assignin(handles.simulator_wksp,'export_png',get(handles.resultsparam_export_png,'Value'));
save_state(handles);



% --- Executes on button press in resultsparam_plot.
function resultsparam_plot_Callback(hObject, eventdata, handles)
% hObject    handle to resultsparam_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of resultsparam_plot
display('Plot changed');
display(get(handles.resultsparam_plot,'Value'));
assignin(handles.simulator_wksp,'plot_results',get(handles.resultsparam_plot,'Value'));
save_state(handles);



% --- Executes on button press in resultsparam_export_matfile.
function resultsparam_export_matfile_Callback(hObject, eventdata, handles)
% hObject    handle to resultsparam_export_matfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of resultsparam_export_matfile
display('Export to MAT-File changed');
display(get(handles.resultsparam_export_matfile,'Value'));
assignin(handles.simulator_wksp,'export_matfile',get(handles.resultsparam_export_matfile,'Value'));
save_state(handles);



function trustparam_cap_decrease_ratio_Callback(hObject, eventdata, handles)
% hObject    handle to trustparam_cap_decrease_ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trustparam_cap_decrease_ratio as text
%        str2double(get(hObject,'String')) returns contents of trustparam_cap_decrease_ratio as a double
display('Cap decrease ratio changed');

str=get(hObject,'String');
cap_decrease_ratio=str2double(str);
valid_input=true;

if (isnan(cap_decrease_ratio))
    valid_input=false;
    str=num2str(10);
    set(hObject,'string',str);
elseif (cap_decrease_ratio<0)
    valid_input=false;
    str=num2str(0);
    set(hObject,'string',str);
elseif (cap_decrease_ratio>100)
    valid_input=false;
    str=num2str(100);
    set(hObject,'string',str);
end

if (valid_input==false)
    warndlg('Cap decrease ratio must be a real scalar in [0;100]');
end

cap_decrease_ratio = str2double(get(hObject,'String'));
assignin(handles.simulator_wksp,'decStepMax',cap_decrease_ratio/100.0);

% Save GUI state
save_state(handles);



% --- Executes during object creation, after setting all properties.
function trustparam_cap_decrease_ratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trustparam_cap_decrease_ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load_system('simulator')



% --- Executes on button press in pushbutton_reset_to_default.
function pushbutton_reset_to_default_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset_to_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display('Reset parameters to default values...');
display('... simparam_te loaded');
set(handles.simparam_te,'String','0.01');
simparam_te_Callback(handles.simparam_te, [], handles);
display('... simparam_duration loaded');
set(handles.simparam_duration,'String','100');
simparam_duration_Callback(handles.simparam_duration, [], handles);
display('... trustparam_rebuild_duration loaded');
set(handles.trustparam_rebuild_duration,'String','5');
trustparam_rebuild_duration_Callback(handles.trustparam_rebuild_duration, [], handles);
display('... trustparam_lose_duration loaded');
set(handles.trustparam_lose_duration,'String','0.1');
trustparam_lose_duration_Callback(handles.trustparam_lose_duration, [], handles);
display('... trustparam_cap_decrease_ratio');
set(handles.trustparam_cap_decrease_ratio,'String','10');
trustparam_cap_decrease_ratio_Callback(handles.trustparam_cap_decrease_ratio, [], handles);
display('... resultsparam_export_matfile');
set(handles.resultsparam_export_matfile,'Value',1);
resultsparam_export_matfile_Callback(handles.resultsparam_export_matfile, [], handles);
display('... resultsparam_export_png');
set(handles.resultsparam_export_png,'Value',1);
resultsparam_export_png_Callback(handles.resultsparam_export_png, [], handles);
display('... resultsparam_plot');
set(handles.resultsparam_plot,'Value',1);
resultsparam_plot_Callback(handles.resultsparam_plot, [], handles);

% Save GUI state
save_state(handles);



function handles=load_state(handles)
%retrieve the data
if (exist('state.mat','file')==2)
    display('Loading state...');
    load('state.mat');
    
    % Simulation parameters
    if (isfield(state,'simparam_te'))
        display('... simparam_te loaded');
        set(handles.simparam_te,'String',state.simparam_te);
        simparam_te_Callback(handles.simparam_te, [], handles);
    end
    if (isfield(state,'simparam_duration'))
        display('... simparam_duration loaded');
        set(handles.simparam_duration,'String',state.simparam_duration);
        simparam_duration_Callback(handles.simparam_duration, [], handles);
    end
    if (isfield(state,'simparam_timeflow'))
        display('... simparam_timeflow_loaded');
        radiobutton_handle=findall(get(handles.simparam_timeflow,'Child'),'Tag',state.simparam_timeflow)
        if(isempty(radiobutton_handle)==0)
            set(radiobutton_handle,'Value', 1);
            display('BOUUUUUUUUUUUUUUUUUUUUU')
            eventdata.NewValue = radiobutton_handle
            
            simparam_timeflow_SelectionChangeFcn(handles.simparam_timeflow, eventdata, handles);
        end
    end
    
    % Trust parameters
    if (isfield(state,'trustparam_rebuild_duration'))
        display('... trustparam_rebuild_duration loaded');
        set(handles.trustparam_rebuild_duration,'String',state.trustparam_rebuild_duration);
        trustparam_rebuild_duration_Callback(handles.trustparam_rebuild_duration, [], handles);
    end
    if (isfield(state,'trustparam_lose_duration'))
        display('... trustparam_lose_duration loaded');
        set(handles.trustparam_lose_duration,'String',state.trustparam_lose_duration);
        trustparam_lose_duration_Callback(handles.trustparam_lose_duration, [], handles);
    end
    if (isfield(state,'trustparam_cap_decrease_ratio'))
        display('... trustparam_cap_decrease_ratio');
        set(handles.trustparam_cap_decrease_ratio,'String',state.trustparam_cap_decrease_ratio);
        trustparam_cap_decrease_ratio_Callback(handles.trustparam_cap_decrease_ratio, [], handles);
    end
    
    % Results parameters
    if (isfield(state,'resultsparam_export_matfile'))
        display('... resultsparam_export_matfile');
        set(handles.resultsparam_export_matfile,'Value',state.resultsparam_export_matfile);
        resultsparam_export_matfile_Callback(handles.resultsparam_export_matfile, [], handles);
    end
    if (isfield(state,'resultsparam_export_png'))
        display('... resultsparam_export_png');
        set(handles.resultsparam_export_png,'Value',state.resultsparam_export_png);
        resultsparam_export_png_Callback(handles.resultsparam_export_png, [], handles);
    end
    if (isfield(state,'resultsparam_plot'))
        display('... resultsparam_plot');
        set(handles.resultsparam_plot,'Value',state.resultsparam_plot);
        resultsparam_plot_Callback(handles.resultsparam_plot, [], handles);
    end
else
    display('No state file found');
end
    
%load the data to the uicomponents
%set(handles.textbox1,'String',data.textbox1);
%set(handles.popup1,'Value',data.popup1);



function save_state(handles)
% Create a structure, containing all parameters to be saved,
% to be exported in a MAT-File
state.simparam_te=get(handles.simparam_te,'String');
state.simparam_duration=get(handles.simparam_duration,'String');
state.simparam_timeflow=get(get(handles.simparam_timeflow,'SelectedObject'),'Tag');

state.trustparam_rebuild_duration=get(handles.trustparam_rebuild_duration,'String');
state.trustparam_lose_duration=get(handles.trustparam_lose_duration,'String');
state.trustparam_cap_decrease_ratio=get(handles.trustparam_cap_decrease_ratio,'String');

state.resultsparam_export_matfile=get(handles.resultsparam_export_matfile,'Value');
state.resultsparam_export_png=get(handles.resultsparam_export_png,'Value');
state.resultsparam_plot=get(handles.resultsparam_plot,'Value');

save('state.mat','state');



% --- Executes when selected object is changed in simparam_timeflow.
function simparam_timeflow_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in simparam_timeflow 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
display('Time flow button radio selection changed');

switch(get(eventdata.NewValue,'Tag'))
    case 'simparam_timeflow_max'
        assignin ('base','RT_SYNC',0);
    case 'simparam_timeflow_realtime'
        assignin ('base','RT_SYNC',1);
end

save_state(handles);


% --------------------------------------------------------------------
function open_scenario_Callback(hObject, eventdata, handles)
% hObject    handle to open_scenario (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,FilterIndex] = uigetfile('.mat');

if(FileName ~= 0)
    set(handles.scenario_file,'String',[PathName FileName]);
    load([PathName FileName]); % charge le fichier scenario en memoire
    
    if(exist('scenario'))
        handles.scenario=scenario;
        guidata(hObject,handles);
        set(handles.pushbutton_visualize_scenario,'Enable','On');
    end
    
    te = scenario.reference_command.Time(2) - scenario.reference_command.Time(1);
    duration = scenario.reference_command.Time(end);
    set(handles.simparam_te,'String',num2str(te));
    set(handles.simparam_duration,'String',num2str(duration));
    simparam_te_Callback(handles.simparam_te, [], handles);
    simparam_duration_Callback(handles.simparam_duration, [], handles);
    save_state(handles);
end


% --- Executes on button press in pushbutton_visualize_scenario.
function pushbutton_visualize_scenario_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_visualize_scenario (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% charge la variable scenario dans le workspace MATLAB avant d'ouvrir la
% GUI de visualisation de scenario
assignin('base','scenario',handles.scenario);
scenario_visualizer_gui

% --------------------------------------------------------------------
function reset_settings_Callback(hObject, eventdata, handles)
% hObject    handle to reset_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
