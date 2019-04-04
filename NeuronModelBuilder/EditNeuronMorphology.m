function varargout = EditNeuronMorphology(varargin)
% EDITNEURONMORPHOLOGY MATLAB code for EditNeuronMorphology.fig
%      EDITNEURONMORPHOLOGY, by itself, creates a new EDITNEURONMORPHOLOGY or raises the existing
%      singleton*.
%
%      H = EDITNEURONMORPHOLOGY returns the handle to a new EDITNEURONMORPHOLOGY or the handle to
%      the existing singleton*.
%
%      EDITNEURONMORPHOLOGY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDITNEURONMORPHOLOGY.M with the given input arguments.
%
%      EDITNEURONMORPHOLOGY('Property','Value',...) creates a new EDITNEURONMORPHOLOGY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EditNeuronMorphology_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EditNeuronMorphology_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EditNeuronMorphology

% Last Modified by GUIDE v2.5 16-Nov-2018 10:56:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EditNeuronMorphology_OpeningFcn, ...
                   'gui_OutputFcn',  @EditNeuronMorphology_OutputFcn, ...
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

% --- Executes just before EditNeuronMorphology is made visible.
function EditNeuronMorphology_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EditNeuronMorphology (see VARARGIN)

% Choose default command line output for EditNeuronMorphology
handles.output = hObject;
handles.select = false;
handles.current_compartment_position = [0 0 0];
% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using EditNeuronMorphology.

% UIWAIT makes EditNeuronMorphology wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EditNeuronMorphology_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LoadNeuron_Callback(hObject, eventdata, handles)
% hObject    handle to LoadNeuron (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.mat');
handles.filename = fullfile(path,file);
tempStruct = load(fullfile(path,file));
handles.NM = tempStruct.NeuronParams;
setupNeuron(hObject,handles);
guidata(hObject, handles);


function setupNeuron(hObject,handles)
fnames = fieldnames(handles.NM);
labelNames =[];

if isfield(handles.NM, 'labelNames')
    labelNames = handles.NM.labelNames;
else
    for f = 1:length(fnames)
        if endsWith(fnames{f}, 'ID')
            labelNames{end+1} = fnames{f};
        end
    end
    handles.NM.labelNames = labelNames;
end
handles.NM.labelNames
if ~ isfield(handles.NM, 'axon_ID')
    handles.NM.axon_ID = [];
    handles.NM.labelNames{end+1}= 'axon_ID';
end
handles.current_compartment = 1;
cla;
clear tempStruct;
viewMorphologyEditor(handles.NM);
handles.selectbutton.Enable = 'on';
handles.rotateButton.Enable = 'on';
[t1, t2, t3, handles.NM]  = getTablesFromStruct(handles.NM);
set(handles.uitable1,'Data', [t1.Properties.VariableNames;table2cell(t1)]);
set(handles.uitable2,'Data', [t2.Properties.VariableNames;table2cell(t2)]);
set(handles.uitable3,'Data', [t3.Properties.VariableNames;table2cell(t3)]);
set(handles.uitable3,'ColumnEditable',true(1,length(handles.NM.labelNames)))
guidata(hObject, handles);

function [t1, t2, t3, NM] = getTablesFromStruct(NM)
    attrpercomp = {'compartmentDiameterArr'};
    for s = attrpercomp
        NMpercomp.(s{1}) = NM.(s{1})';
    end
    t1 = struct2table(NMpercomp);
    fnames = fieldnames(NM);
    labelNames = NM.labelNames;

    
    for f = fnames'
        if length(NM.(f{1})) == 1 && ~ismember(f{1}, labelNames) && ~strcmp(f, 'numCompartments')
            NMwholeC.(f{1}) = NM.(f{1});
        end
    end
    t2 = struct2table(NMwholeC);
    labels = [];
    for l = labelNames
        labelled = NM.(l{1});
        labelsaslogical = logical(zeros(1,NM.numCompartments));
        labelsaslogical(labelled) = 1;
        labels.(l{1}) = labelsaslogical';
    end
    t3 = struct2table(labels);

% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.OldValue.String, 'Rotate')
    rotate3d(handles.axes2,'off');
end
if strcmp(eventdata.NewValue.String, 'Rotate')
    rotate3d(handles.axes2,'on');
end
if strcmp(eventdata.OldValue.String, 'Select')
        handles.select = false; 
        handles.datacursor.Enable = 'off';
end
if strcmp(eventdata.NewValue.String, 'Select')
        handles.select = true; 
        handles.datacursor = datacursormode;
        handles.datacursor.DisplayStyle = 'datatip';
        handles.datacursor.SnapToDataVertex = 'on';
        set(handles.datacursor,'UpdateFcn',{@selectCompartment,handles.output})     
end
if strcmp(eventdata.OldValue.String, 'Extend')
    set(handles.axes2,'ButtonDownFcn','') 
    handles.extendButton.Enable = 'off';
    disp('Finished Extending.')
end
if strcmp(eventdata.NewValue.String, 'Extend')
    handles.axes2.View = [0,0];
    
    set(handles.axes2,'ButtonDownFcn',{@newCompartment,handles.output}) 
    handles.selectbutton.Enable = 'off';
    handles.extendButton.Enable = 'off';
    
    disp('Extending..')
end
if strcmp(eventdata.NewValue.String, 'Delete')
    if ismember(handles.current_compartment, handles.NM.compartmentParentArr)
        errordlg('Can only delete childless compartments.');
    else
        handles.NM = deleteCompartment(handles.NM,handles.current_compartment);
        cla;
        handles = rmfield(handles,'previousLine');
        handles.NM
        viewMorphologyEditor(handles.NM);
        
    end
    handles.deletebutton.Enable = 'off';
end


guidata(hObject, handles);

function NM = deleteCompartment(NM, iComp)
    NM.compartmentParentArr(iComp:end-1) = NM.compartmentParentArr(iComp+1:end) ;
    NM.compartmentParentArr(end) = [];
    NM.compartmentParentArr(NM.compartmentParentArr>iComp) = NM.compartmentParentArr(NM.compartmentParentArr>iComp)-1;
    NM.compartmentDiameterArr(iComp:end-1) = NM.compartmentDiameterArr(iComp+1:end);
    NM.compartmentDiameterArr(end) = [];
    NM.compartmentXPositionMat(iComp:end-1,:) = NM.compartmentXPositionMat(iComp+1:end,:) ;
    NM.compartmentXPositionMat(end,:) =[];
    NM.compartmentYPositionMat(iComp:end-1,:) = NM.compartmentYPositionMat(iComp+1:end,:);
    NM.compartmentYPositionMat(end,:) =[];
    NM.compartmentZPositionMat(iComp:end-1,:) = NM.compartmentZPositionMat(iComp+1:end,:);
    NM.compartmentZPositionMat(end,:) =[];
    NM.compartmentLengthArr(iComp:end-1) = NM.compartmentLengthArr(iComp+1:end);
    NM.compartmentLengthArr(end) = [];
    NM.numCompartments = NM.numCompartments-1;

function text = selectCompartment(~,event_obj,hFigure)
    text = event_obj.Target.Tag;
    handles      = guidata(hFigure);
        
    if isfield(handles, 'previousLine')
        handles.previousLine.Color = [0 0 0];
    end
    event_obj.Target.Color = [0 0.7 0.7];
    handles.previousLine = event_obj.Target;
    handles.current_compartment = str2double(event_obj.Target.Tag);
    if handles.current_compartment == 0
        disp(['current compartment: ' num2str(handles.current_compartment)]);
    end
    
    handles.current_compartment_position = event_obj.Position;
    handles.extendButton.Enable = 'on';
    handles.deleteButton.Enable = 'on';
    guidata(hFigure,handles);
    

function text = newCompartment(~,event_obj,hFigure)
    handles      = guidata(hFigure);
    clickpt = event_obj.IntersectionPoint([1 3]);
    disp(clickpt)
    event_obj.Source.View = [90,0];
    axis(event_obj.Source, [clickpt(1)-10 clickpt(1)+10 -200 200 clickpt(2)-10 clickpt(2)+10]);
    %axis(event_obj.Source,'autoxz');
    set(handles.axes2,'ButtonDownFcn',{@newCompartmentY,clickpt,hFigure}) 
    guidata(handles.output,handles);

    
function text = newCompartmentY(~,event_obj,xz, hFigure)
    handles      = guidata(hFigure);
    clickpt = event_obj.IntersectionPoint(2);
    XYZ = [xz(1) clickpt xz(2)];
    event_obj.Source.View = [0,0];
    handles.NM  = addCompartment(handles,handles.current_compartment_position,XYZ,...
        handles.current_compartment, handles.NM.compartmentDiameterArr(handles.current_compartment));
   
    handles = rmfield(handles,'previousLine');
    setupNeuron(handles.output,handles);
    handles.selectbutton.Enable = 'on';
    guidata(handles.output,handles);

% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function NM = addCompartment(handles, XYZ1, XYZ2, parentID, defdiameter)
    diameter = inputdlg('Enter the diameter of the new compartment in microns.', 'Enter the diameter', [1 35], {num2str(defdiameter)}); 
    NM = handles.NM;
    NM.compartmentParentArr(end+1) = parentID;
    NM.compartmentDiameterArr(end+1) = str2double(diameter);
    NM.compartmentXPositionMat(end+1,:) = [XYZ1(1), XYZ2(1)];
    NM.compartmentYPositionMat(end+1,:) = [XYZ1(2), XYZ2(2)];
    NM.compartmentZPositionMat(end+1,:) = [XYZ1(3), XYZ2(3)];
    NM.compartmentLengthArr(end+1) = sqrt(sum((XYZ2-XYZ1).^2));
    NM.numCompartments = handles.NM.numCompartments+1;


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over deleteButton.
function deleteButton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to deleteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile(handles.filename);
NeuronParams = handles.NM;
save(fullfile(path,file),'NeuronParams' );


% --- Executes when selected cell(s) is changed in uitable3.
function uitable3_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable3 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
% disp(['inds ' num2str(eventdata.Indices)])
% size(hObject.Data)
% label = hObject.Data(1,eventdata.Indices(2));
% handles.NM.(cell2mat(label)) = find(cell2mat(hObject.Data(2:end,eventdata.Indices(2))));
% [t1, t2, t3, handles.NM]  = getTablesFromStruct(handles.NM);
% set(handles.uitable3,'Data', [t3.Properties.VariableNames;table2cell(t3)]);


% --- Executes when entered data in editable cell(s) in uitable3.
function uitable3_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable3 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
label = hObject.Data(1,eventdata.Indices(2));
handles.NM.(cell2mat(label)) = find(cell2mat(hObject.Data(2:end,eventdata.Indices(2))));
cla;
viewMorphologyEditor(handles.NM);
guidata(handles.output,handles);

% --- Executes on button press in addLabel.
function addLabel_Callback(hObject, eventdata, handles)
% hObject    handle to addLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
labelname = inputdlg('Enter the name of the new label.', 'Add new label name', [1 35]);
if ismember(labelname, handles.NM.labelNames)
    errordlg('label Name already exists.')
else
    handles.NM.labelNames{end+1} = labelname{1};
    handles.NM.(labelname{1}) = [];
    [t1, t2, t3, handles.NM]  = getTablesFromStruct(handles.NM);
    set(handles.uitable3,'Data', [t3.Properties.VariableNames;table2cell(t3)]);
	set(handles.uitable3,'ColumnEditable',true(1,length(handles.NM.labelNames)))
end
guidata(handles.output,handles);


% --------------------------------------------------------------------
function createNewCell_Callback(hObject, eventdata, handles)
% hObject    handle to createNewCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
basemodels = load('neurons.mat');
handles.filename = '';
list = {};
for n = 1:length(basemodels.NP)
    list{end+1} = basemodels.NP(n).name;
end
[indx,~] = listdlg('ListString',list, 'SelectionMode','single');
handles.NM = basemodels.NP(indx);
setupNeuron(hObject,handles);