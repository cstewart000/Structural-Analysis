function varargout = memberLoadsUI(varargin)
% NODEUI MATLAB code for nodeUI.fig
%      NODEUI, by itself, creates a new NODEUI or raises the existing
%      singleton*.
%
%      H = NODEUI returns the handle to a new NODEUI or the handle to
%      the existing singleton*.
%
%      NODEUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NODEUI.M with the given input arguments.
%
%      NODEUI('Property','Value',...) creates a new NODEUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nodeUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nodeUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nodeUI

% Last Modified by GUIDE v2.5 02-Jul-2015 10:58:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @memberLoadsUI_OpeningFcn, ...
    'gui_OutputFcn',  @memberLoadsUI_OutputFcn, ...
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


% --- Executes just before nodeUI is made visible.
function memberLoadsUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nodeUI (see VARARGIN)

% Choose default command line output for nodeUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nodeUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% Creation code
if(exist('memberLoadData.mat'))
    load('memberLoadData.mat')
    if(exist('memberLoadData'))
        data = memberLoadData
        set(handles.uitable1, 'data', data);
    end
else
    data = zeros(1,4)
    
    %data = num2cell(data)
    %data(:,3:4) = 1
    set(handles.uitable1, 'data', data);
    memberLoadData = data;
    save('memberLoadData.mat', 'memberLoadData');
end

% --- Outputs from this function are returned to the command line.
function varargout = memberLoadsUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_add_member_load.
function pb_add_member_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_add_member_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isfield(handles, 'uitable1'));
    %if(isfield(handles.uitable1, 'Data'));
        data = get(handles.uitable1, 'Data');
        
        if(iscell(data))
            % Insert blank node
            data{end+1,1} = [];
        end
        if(isnumeric(data))
            data(end+1,:) = [0 0 0 0];
        end
    %end
else
    data = [0 0 0 0];
end

%Post data
set(handles.uitable1, 'data', data);
memberLoadData = data;
save('memberLoadData.mat', 'memberLoadData');


% --- Executes on button press in pb_done.
function pb_done_Callback(hObject, eventdata, handles)
% hObject    handle to pb_done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.uitable1, 'data');

%save data
memberLoadData = data;
save('memberLoadData.mat', 'memberLoadData')

close








%% need this function to make table editable
% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

%{
function data = getNodeData(hObject, eventdata, handles)
    data = nodeData
    
function postData(hObject, eventdata, handles,data)
        set(handles.uitable1, 'data', data);
        nodeData = data;
        save('nodeData.mat', 'nodeData');
%}


% --- Executes on button press in pb_delete_member_load.
function pb_delete_member_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_delete_member_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.uitable1, 'data');

% Delete end node
if(iscell(data))
    data = cell2mat(data)
end

data = data(1:(end-1),:);

data = num2cell(data)


%Post data
set(handles.uitable1, 'data', data);
memberLoadData = data;
save('memberLoadData.mat', 'memberLoadData')