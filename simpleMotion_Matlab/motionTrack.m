function varargout = motionTrack(varargin)
% MOTIONTRACK MATLAB code for motionTrack.fig
%      MOTIONTRACK, by itself, creates a new MOTIONTRACK or raises the existing
%      singleton*.
%
%      H = MOTIONTRACK returns the handle to a new MOTIONTRACK or the handle to
%      the existing singleton*.
%
%      MOTIONTRACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTIONTRACK.M with the given input arguments.
%
%      MOTIONTRACK('Property','Value',...) creates a new MOTIONTRACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before motionTrack_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to motionTrack_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help motionTrack

% Last Modified by GUIDE v2.5 09-May-2017 20:47:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @motionTrack_OpeningFcn, ...
                   'gui_OutputFcn',  @motionTrack_OutputFcn, ...
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


% --- Executes just before motionTrack is made visible.
function motionTrack_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to motionTrack (see VARARGIN)

% Choose default command line output for motionTrack
handles.output = hObject;
evalin('base','lastRun=0;');
tStBt=evalin('base','exist(''motionTracker'')');
if tStBt==1
    set(handles.closeCom,'Enable','on') 
    set(handles.createCom,'Enable','off')
else
    set(handles.closeCom,'Enable','off') 
    set(handles.createCom,'Enable','on')
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes motionTrack wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = motionTrack_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function comPath_Callback(hObject, eventdata, handles)
% hObject    handle to comPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comPath as text
%        str2double(get(hObject,'String')) returns contents of comPath as a double


% --- Executes during object creation, after setting all properties.
function comPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in createCom.
function createCom_Callback(hObject, eventdata, handles)
% hObject    handle to createCom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tmpComPath=get(handles.comPath,'string')
motionTracker=serial(tmpComPath,'BaudRate',19200);
assignin('base','motionTracker',motionTracker);
evalin('base','fopen(motionTracker);');
set(handles.closeCom,'Enable','on') 
set(handles.createCom,'Enable','off') 


% --- Executes on button press in closeCom.
function closeCom_Callback(hObject, eventdata, handles)
% hObject    handle to closeCom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalin('base','fclose(motionTracker);');
evalin('base','clear motionTracker');
set(handles.createCom,'Enable','on') 


% --- Executes on button press in startRun.
function startRun_Callback(hObject, eventdata, handles)
% hObject    handle to startRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in stopCollecting.
function stopCollecting_Callback(hObject, eventdata, handles)
% hObject    handle to stopCollecting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in getDataToggle.
function getDataToggle_Callback(hObject, eventdata, handles)
% hObject    handle to getDataToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of getDataToggle
evalin('base','flushinput(motionTracker);')
evalin('base','curIt=1;')
set(handles.saveButton,'Enable','off') 
axes(handles.axes1)
ylim([-150 150])
while get(hObject,'Value')
    evalin('base','tempBuf=fscanf(motionTracker);')
    evalin('base','splitBuf=strsplit(tempBuf,'','');')
    if evalin('base','numel(splitBuf);')==6
        evalin('base','tStamp(:,curIt)=str2num(splitBuf{2});');
        evalin('base','posDelta(:,curIt)=str2num(splitBuf{3});')
        evalin('base','curPos(:,curIt)=str2num(splitBuf{4});');
        evalin('base','curIt=curIt+1;')
        tIt=evalin('base','curIt');
        if tIt<=100 && mod(tIt,5)==0
            plot(evalin('base','tStamp'),evalin('base','posDelta'),'k-');
            ylim([-150 150])
        elseif tIt>100 && mod(tIt,5)==0
                plot(evalin('base','posDelta(end-99:end)'),'k-');
                ylim([-150 150])
        else
        end
    else
        evalin('base','flushinput(motionTracker);')
        disp('bad read; flushed')
    end
    get(hObject,'Value');
    pause(0.0001)   
end
set(handles.saveButton,'Enable','on') 
% set(handles.getDataToggle,'Enable','off')

hold off


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base','clear tempBuf')
evalin('base','clear splitBuf')
evalin('base','lastRun=lastRun+1;')
evalin('base','archData.curPos{lastRun}=curPos;, clear curPos')
evalin('base','archData.timeStamps{lastRun}=tStamp;, clear tStamp')
evalin('base','archData.posDelta{lastRun}=posDelta;, clear posDelta')
% set(handles.getDataToggle,'Enable','on')
