function varargout = UI(varargin)
% UI MATLAB code for UI.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI

% Last Modified by GUIDE v2.5 12-Aug-2015 16:48:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @UI_OpeningFcn, ...
    'gui_OutputFcn',  @UI_OutputFcn, ...
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


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI (see VARARGIN)







% Choose default command line output for UI
handles.output = hObject;

handles.Model = StructureClass;
% Update handles structure
guidata(hObject, handles);



% UIWAIT makes UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get default command line output from handles structure
varargout{1} = handles.output;



function editText_cmd_Callback(hObject, eventdata, handles)
% hObject    handle to editText_cmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText_cmd as text
%        str2double(get(hObject,'String')) returns contents of editText_cmd as a double
set(handles.editText_cmd, 'String','');



% --- Executes on button press in rb_globalAxes.
function rb_globalAxes_Callback(hObject, eventdata, handles)
% hObject    handle to rb_globalAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_globalAxes


% --------------------------------------------------------------------
function Menu_main_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function example_menu_Callback(hObject, eventdata, handles)
% hObject    handle to example_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function View_menu_Callback(hObject, eventdata, handles)
% hObject    handle to View_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hFigure = openfig('currentfig.fig', 'new', 'invisible');
% assuming there is only one axes in your stored figure:
% hAxes = get(hFigure);
% assuming we are in a callback and the tag of your figure is figure1:
%hCopy = copyobj(hFigure, handles.axes1);
%set(hCopy);

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function centreView_menuItem_Callback(hObject, eventdata, handles)
% hObject    handle to centreView_menuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = 1:10
y = sin(x)
hfig = openfig('currentFig.fig');

%plot(handles.axes1, x,y)
plot(handles.axes1, hfig)


% --------------------------------------------------------------------
function simpleBeam_menuItem_Callback(hObject, eventdata, handles)
% hObject    handle to simpleBeam_menuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('simple_beam.mat')
handles.filename = 'simple_beam.mat';
%redraw()

% --------------------------------------------------------------------
function cBeam_menuItem_Callback(hObject, eventdata, handles)
% hObject    handle to cBeam_menuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('cantilever_beam.mat')
handles.filename = 'cantilever_beam.mat';
%redraw()

% --------------------------------------------------------------------
function truss_menuItem_Callback(hObject, eventdata, handles)
% hObject    handle to truss_menuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('truss.mat')
handles.filename = 'truss.mat';
%redraw()

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function swayFrame_menuItem_Callback(hObject, eventdata, handles)
% hObject    handle to swayFrame_menuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('sway_frame.mat')
handles.filename = 'sway_frame.mat';
%redraw()

% --------------------------------------------------------------------
function open_menuItem_Callback(hObject, eventdata, handles)
% hObject    handle to open_menuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, path] = uigetfile('*.mat', 'Open project')
load(filename);
% --------------------------------------------------------------------
function saveAs_menuItem_Callback(hObject, eventdata, handles)
% hObject    handle to saveAs_menuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = uiputfile('my_project.mat', 'Save file as')
handles.filename = filename;
save(filename);

% --------------------------------------------------------------------
function menuItem_save_Callback(hObject, eventdata, handles)
% hObject    handle to menuItem_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~exists(handles.filename))
    saveAs_menuItem_Callback(hObject, eventdata, handles)
else
    save(handles.filename)
end


% --- Executes on button press in pushb_cmd_clear.
function pushb_cmd_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushb_cmd_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.editText_cmd, 'String', ''); 

% --- Executes on button press in pushb_cmd_exe.
function pushb_cmd_exe_Callback(hObject, eventdata, handles)
% hObject    handle to pushb_cmd_exe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_clear.
function pb_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pb_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.OutputTextBox, 'String', '');


% --------------------------------------------------------------------
function structure_menu_Callback(hObject, eventdata, handles)
% hObject    handle to structure_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function nodes_menuItem_Callback(hObject, eventdata, handles)
% hObject    handle to nodes_menuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('Node')
nodeUI();


% --------------------------------------------------------------------
function members_menuItem_Callback(hObject, eventdata, handles)
% hObject    handle to members_menuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('Member')
memberUI();

% --------------------------------------------------------------------
function materials_menuItem_Callback(hObject, eventdata, handles)
% hObject    handle to materials_menuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('Material')
materialUI();

% --------------------------------------------------------------------
function sections_menuItem_Callback(hObject, eventdata, handles)
% hObject    handle to sections_menuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('Section')
sectionUI();


% --------------------------------------------------------------------
function menu_analyse_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analyse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('UIforms')

% Extract Data
data = guidata(hObject);

% Get null model
model = data.Model

% analyse the model and return
model = AnalyseScript(model);

if(model.analysis_status)
    set(handles.radiob_bendingMoment,'Enable','on')  %enable checkbox
    set(handles.radiob_deflections,'Enable','on')  %enable checkbox
    set(handles.radiob_axialForces,'Enable','on')  %enable checkbox
    set(handles.radiob_shearForces,'Enable','on')  %enable checkboxUI
    set(handles.radiob_reactions,'Enable','on')  %enable checkbox
    
elseif(~model.analysis_status)
    set(handles.radiob_bendingMoment,'Enable','off')  %enable checkbox
    set(handles.radiob_deflections,'Enable','off')  %enable checkbox
    set(handles.radiob_axialForces,'Enable','off')  %enable checkbox
    set(handles.radiob_shearForces,'Enable','off')  %enable checkbox
    set(handles.radiob_reactions,'Enable','off')
else
    error('Model analysis status not set correctly');
end


%image = imread('Lenna.jpg');
%imshow(image, 'parent',handles.axes1)


% Generate a fig file

% Load the fig file
h=hgload('currentfig.fig');
set(h,'Visible','off');
tmpaxes=findobj(h,'Type','axes');

% Copy the axes

copyobj(allchild(tmpaxes),handles.axes1);

% Clean up
close(h)

handles.Model = model;
% Update handles structure
guidata(hObject, handles);









% --------------------------------------------------------------------
function menuItem_distLoads_Callback(hObject, eventdata, handles)
% hObject    handle to menuItem_distLoads (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('Member Loads')
memberLoadsUI()

% --------------------------------------------------------------------
function menuItem_nodeLoads_Callback(hObject, eventdata, handles)
% hObject    handle to menuItem_nodeLoads (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('Node Loads')
nodeLoadsUI()


% --- Executes on button press in radiob_reactions.
function radiob_reactions_Callback(hObject, eventdata, handles)
% hObject    handle to radiob_reactions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiob_reactions
status = handles.radiob_reactions.Value
axes(handles.axes1);
hline = findobj(gcf, 'tag', 'reactions');
if(status)
    set(hline,'Visible','on')
elseif(~status)
    set(hline,'Visible','off')
end

% --- Executes on button press in radiob_restraints.
function radiob_restraints_Callback(hObject, eventdata, handles)
% hObject    handle to radiob_restraints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiob_restraints
%x = openfig('currentfig')
status = handles.radiob_restraints.Value
axes(handles.axes1);
hline = findobj(gcf, 'tag', 'restraint');
if(status)
    set(hline,'Visible','on')
elseif(~status)
    set(hline,'Visible','off')
end


% --- Executes on button press in radiob_distributedLoads.
function radiob_distributedLoads_Callback(hObject, eventdata, handles)
% hObject    handle to radiob_distributedLoads (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiob_distributedLoads
status = handles.radiob_distributedLoads.Value
axes(handles.axes1);
hline = findobj(gcf, 'tag', 'load');
if(status)
    set(hline,'Visible','on')
elseif(~status)
    set(hline,'Visible','off')
end

% --- Executes on button press in radiob_pointLoads.
function radiob_pointLoads_Callback(hObject, eventdata, handles)
% hObject    handle to radiob_pointLoads (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiob_pointLoads
status = handles.radiob_pointLoads.Value
axes(handles.axes1);
hline = findobj(gcf, 'tag', 'pointLoads');
if(status)
    set(hline,'Visible','on')
elseif(~status)
    set(hline,'Visible','off')
end

% --- Executes on button press in radiob_axialForces.
function radiob_axialForces_Callback(hObject, eventdata, handles)
% hObject    handle to radiob_axialForces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiob_axialForces
status = handles.radiob_axialForces.Value
axes(handles.axes1);
hline = findobj(gcf, 'tag', 'axial');
if(status)
    set(hline,'Visible','on')
elseif(~status)
    set(hline,'Visible','off')
end

% --- Executes on button press in radiob_shearForces.
function radiob_shearForces_Callback(hObject, eventdata, handles)
% hObject    handle to radiob_shearForces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiob_shearForces
status = handles.radiob_shearForces.Value
axes(handles.axes1);
hline = findobj(gcf, 'tag', 'shear');
if(status)
    set(hline,'Visible','on')
elseif(~status)
    set(hline,'Visible','off')
end

% --- Executes on button press in radiob_bendingMoment.
function radiob_bendingMoment_Callback(hObject, eventdata, handles)
% hObject    handle to radiob_bendingMoment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiob_bendingMoment
status = handles.radiob_bendingMoment.Value
axes(handles.axes1);
hline = findobj(gcf, 'tag', 'bmd');
if(status)
    set(hline,'Visible','on')
elseif(~status)
    set(hline,'Visible','off')
end

% --- Executes on button press in radiob_deflections.
function radiob_deflections_Callback(hObject, eventdata, handles)
% hObject    handle to radiob_deflections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiob_deflections
status = handles.radiob_deflections.Value
axes(handles.axes1);
hline = findobj(gcf, 'tag', 'deflections');
if(status)
    set(hline,'Visible','on')
elseif(~status)
    set(hline,'Visible','off')
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
[xmouse,ymouse,button] = ginput(1);

% Extract Data
data = guidata(hObject);

% Get null model
model = data.Model

% analyse the model and return
report = model.mouseClick(xmouse,ymouse,button)
string = struct2str(report, '')
%string = evalc(['disp(report)'])
set(handles.OutputTextBox, 'String', string);
