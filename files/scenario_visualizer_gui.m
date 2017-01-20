function varargout = scenario_visualizer_gui(varargin)
% scenario_visualizer_gui MATLAB code for scenario_visualizer_gui.fig
%      scenario_visualizer_gui, by itself, creates a new scenario_visualizer_gui or raises the existing
%      singleton*.
%
%      H = scenario_visualizer_gui returns the handle to a new scenario_visualizer_gui or the handle to
%      the existing singleton*.
%
%      scenario_visualizer_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in scenario_visualizer_gui.M with the given input arguments.
%
%      scenario_visualizer_gui('Property','Value',...) creates a new scenario_visualizer_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scenario_visualizer_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scenario_visualizer_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scenario_visualizer_gui

% Last Modified by GUIDE v2.5 19-Jan-2017 17:07:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scenario_visualizer_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @scenario_visualizer_gui_OutputFcn, ...
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


% --- Executes just before scenario_visualizer_gui is made visible.
function scenario_visualizer_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scenario_visualizer_gui (see VARARGIN)

% Choose default command line output for scenario_visualizer_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes scenario_visualizer_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
scenario=evalin('base','scenario');
handles.scenario=scenario;
guidata(hObject,handles);

D=zeros(length(scenario.reference_command.Data),1);

D=D+diffTimeSeries(scenario.failure.power.calculators);
D=D+diffTimeSeries(scenario.failure.power.actuators);
D=D+diffTimeSeries(scenario.failure.power.power_supplies);
D=D+diffTimeSeries(scenario.failure.communication.packet_sending.calculators);
D=D+diffTimeSeries(scenario.failure.communication.packet_sending.actuators);
D=D+diffTimeSeries(scenario.failure.communication.packet_receiving.calculators_to_calculators);
D=D+diffTimeSeries(scenario.failure.communication.packet_receiving.actuators_to_calculators);
D=D+diffTimeSeries(scenario.failure.communication.packet_receiving.referee_to_calculators);
D=D+diffTimeSeries(scenario.failure.communication.packet_receiving.referee_to_actuators);

nb_errors=sum(D~=0);

% Indexing the errors
index_errors=zeros(nb_errors,1);
j=1;
for i=1:length(D)
    if(D(i)~=0)
        index_errors(j)=i;
        j=j+1;
    end
end
handles.index_errors=index_errors;
guidata(hObject,handles);

%index_errors

set(handles.slider_errors,'Value',0);
set(handles.slider_errors,'Max',nb_errors);
set(handles.slider_errors,'SliderStep',[1.0/nb_errors 0.1]);

eventdata.index_errors=index_errors;
eventdata.scenario=scenario;

slider_errors_Callback(handles.slider_errors, [], handles);
drawnow;

% --- Outputs from this function are returned to the command line.
function varargout = scenario_visualizer_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_errors_Callback(hObject, eventdata, handles)
% hObject    handle to slider_errors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
index_errors=handles.index_errors;
scenario=handles.scenario;

max=get(handles.slider_errors,'Max')
value=round(get(handles.slider_errors,'Value'));
set(handles.slider_errors,'Value',value);
set(handles.edit_errors,'String',[num2str(value) '/' num2str(max)]);

get(handles.uitable_packet_receiving_calculators_to_calculators,'BackgroundColor')

% BACKGROUND COLORS
green=[0.4667 0.6745 0.1882];
orange=[0.8510 0.3255 0.0980];

% CHECK POWER FAILURES
if(value>0)
    index=index_errors(value);
else
    index=1;
end

time_error=scenario.reference_command.Time(index);
set(handles.text_time_error,'String',[num2str(time_error) ' s.']);

% FAILURE POWER ACTUATORS
data=scenario.failure.power.calculators.Data(index,:)>=0.5;
obj=handles.uitable_power_calculators;
set(obj,'Data',data);
if(sum(data(:))>0)
    set(obj,'BackgroundColor',orange);
else
    set(obj,'BackgroundColor',green);
end

% FAILURE POWER ACTUATORS
data=scenario.failure.power.actuators.Data(index,:)>=0.5;
obj=handles.uitable_power_actuators;
set(obj,'Data',data);
if(sum(data(:))>0)
    set(obj,'BackgroundColor',orange);
else
    set(obj,'BackgroundColor',green);
end

% FAILURE POWER SUPPLIES
data=scenario.failure.power.power_supplies.Data(index,:)>=0.5;
obj=handles.uitable_power_supplies;
set(obj,'Data',data);
if(sum(data(:))>0)
    set(obj,'BackgroundColor',orange);
else
    set(obj,'BackgroundColor',green);
end

% FAILURE PACKET SENDING CALCULATORS
data=scenario.failure.communication.packet_sending.calculators.Data(index,:)>=0.5;
obj=handles.uitable_packet_sending_calculators;
set(obj,'Data',data);
if(sum(data(:))>0)
    set(obj,'BackgroundColor',orange);
else
    set(obj,'BackgroundColor',green);
end

% FAILURE PACKET SENDING ACTUATORS
data=scenario.failure.communication.packet_sending.actuators.Data(index,:)>=0.5;
obj=handles.uitable_packet_sending_actuators;
set(obj,'Data',data);
if(sum(data(:))>0)
    set(obj,'BackgroundColor',orange);
else
    set(obj,'BackgroundColor',green);
end

% FAILURE PACKET RECEIVING CALCULATORS TO CALCULATORS
data=scenario.failure.communication.packet_receiving.calculators_to_calculators.Data(:,:,index)>=0.5;
obj=handles.uitable_packet_receiving_calculators_to_calculators;
set(obj,'Data',data);
if(sum(data(:))>0)
    set(obj,'BackgroundColor',orange);
else
    set(obj,'BackgroundColor',green);
end

% FAILURE PACKET RECEIVING ACTUATORS TO CALCULATORS
data=scenario.failure.communication.packet_receiving.actuators_to_calculators.Data(:,:,index)>=0.5;
obj=handles.uitable_packet_receiving_actuators_to_calculators;
set(obj,'Data',data);
if(sum(data(:))>0)
    set(obj,'BackgroundColor',orange);
else
    set(obj,'BackgroundColor',green);
end

% FAILURE PACKET RECEIVING REFEREE TO CALCULATORS
data=scenario.failure.communication.packet_receiving.referee_to_calculators.Data(index,:)'>=0.5;
obj=handles.uitable_packet_receiving_referee_to_calculators;
set(obj,'Data',data);
if(sum(data(:))>0)
    set(obj,'BackgroundColor',orange);
else
    set(obj,'BackgroundColor',green);
end

% FAILURE PACKET RECEIVING REFEREE TO CALCULATORS
data=scenario.failure.communication.packet_receiving.referee_to_actuators.Data(index,:)'>=0.5;
obj=handles.uitable_packet_receiving_referee_to_actuators;
set(obj,'Data',data);
if(sum(data(:))>0)
    set(obj,'BackgroundColor',orange);
else
    set(obj,'BackgroundColor',green);
end

%get(handles.uitable_packet_sending_calculators,'BackgroundColor')
%set(handles.uitable_power_calculators,'BackgroundColor',[
% --- Executes during object creation, after setting all properties.
function slider_errors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_errors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_errors_Callback(hObject, eventdata, handles)
% hObject    handle to edit_errors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_errors as text
%        str2double(get(hObject,'String')) returns contents of edit_errors as a double


% --- Executes during object creation, after setting all properties.
function edit_errors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_errors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
