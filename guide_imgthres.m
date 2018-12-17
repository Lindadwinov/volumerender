function varargout = guide_imgthres(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guide_imgthres_OpeningFcn, ...
                   'gui_OutputFcn',  @guide_imgthres_OutputFcn, ...
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


% --- Executes just before guide_imgthres is made visible.
function guide_imgthres_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guide_imgthres (see VARARGIN)

% Choose default command line output for guide_imgthres
handles.output = hObject;

handles.image1=image('parent',handles.axes1,...
        		        'Xdata',[],'Ydata',[],'Cdata',[]);
handles.image2=image('parent',handles.axes1,...
        		        'Xdata',[],'Ydata',[],'Cdata',[],'alphadata',0.3);                    

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guide_imgthres wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guide_imgthres_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in imglist.
function imglist_Callback(hObject, eventdata, handles)
% hObject    handle to imglist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imglist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imglist
display_update

% --- Executes during object creation, after setting all properties.
function imglist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imglist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadimg.
function loadimg_Callback(hObject, eventdata, handles)
% hObject    handle to loadimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% select a directory with DICOM images 
dirname=uigetdir;
dirinfo=dir([dirname filesep '*.dcm']);
% read image using for-loop
handles.Data.img=[];
liststr={};
for i=1:length(dirinfo)
    handles.Data.img(:,:,i)=dicomread([dirname filesep dirinfo(i).name]);    
    liststr{i}=dirinfo(i).name;
end

% update handles.imglist
set(handles.imglist,'String',liststr,'Value',1)
% update handles.axes1 and handles.image1
[row,col]=size(handles.Data.img);
set(handles.axes1,'Xlim',[1 col],'Ylim',[1 row],'Ydir','reverse')
set(handles.image1,'XData',[1 col],'YData',[1 row],...
                                      'CDataMapping','scaled')
set(handles.image2,'XData',[1 col],'YData',[1 row])
% update handles.sliderthres
set(handles.sliderthres,'min',min(handles.Data.img(:)),...
                                            'max',max(handles.Data.img(:)))

% Update handles structure
guidata(hObject, handles);
display_update  %update display


% --- Executes on button press in roipoly.
function roipoly_Callback(hObject, eventdata, handles)
% hObject    handle to roipoly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Data.roi=roipoly;
% Update handles structure
guidata(hObject, handles);
display_update

% --- Executes on slider movement.
function sliderthres_Callback(hObject, eventdata, handles)
% hObject    handle to sliderthres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value=get(handles.sliderthres,'value');
set(handles.editthres,'string',num2str(value))
display_update

% --- Executes during object creation, after setting all properties.
function sliderthres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderthres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function editthres_Callback(hObject, eventdata, handles)
% hObject    handle to editthres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editthres as text
%        str2double(get(hObject,'String')) returns contents of editthres as a double
value=get(handles.editthres,'string');
set(handles.sliderthres,'value',str2num(value))
display_update

% --- Executes during object creation, after setting all properties.
function editthres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editthres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in applythres.
function applythres_Callback(hObject, eventdata, handles)
% hObject    handle to applythres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of applythres
display_update


% --- Executes on button press in model3d.
function model3d_Callback(hObject, eventdata, handles)
% hObject    handle to model3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
thres=get(handles.sliderthres,'value');
slice=get(handles.imglist,'value');
img=handles.Data.img(:,:,slice);
% apply threshold
img(img<thres)=0;
img(img>=thres)=1;
% apply roipoly
for i=1:size(img,3)
    img(:,:,i)=img(:,:,i).*handles.Data.roi;
end
% convert image volume to isotropic
img=isotropicvol(img,0.36,0.36,0.50);
% smooth image volume
img=smooth3(img);

 [f,v] = isosurface(img);
 v=meshsmooth(f,v); 

figure('color',[0 0 0]),
patch('parent',gca,'faces',f,'vertices',v,...
           'FaceColor',[.99 .99 .99],'edgecolor','none');  
set(gca,'zdir','reverse','visible','off')     
axis equal

lighting gouraud
view(0,0)
camlight(0,0)
camlight(180,0)    

handles.Data.f=f;
handles.Data.v=v;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in exportstl.
function exportstl_Callback(hObject, eventdata, handles)
% hObject    handle to exportstl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, filepath]=uiputfile('*.stl','Please select an STL file to save');
stlwrite([filepath filename],handles.Data.f,handles.Data.v,'mode','binary')

function display_update
% update display based on the values of uicontrols
% retrieve the handles
handles=guidata(gcf);

num=get(handles.imglist,'value');
num=num(end); % considering the multiple selections
set(handles.image1,'CData',handles.Data.img(:,:,num))
colormap(gray)

if get(handles.applythres,'value')==1
    img=handles.Data.img(:,:,num);
    img=repmat(img,[1 1 3]);
    thres=get(handles.sliderthres,'value');
    % set pixels with intensity less than 110 to be 0
    img(img<thres)=0;
    
    % set pixels with intensity larger than 110 to be red
    % (255 in the first layer and 0 in the second and third layers)
    for layer=1:3 % red, green, and blue layer
        tmpimg=img(:,:,layer);
        ind=find(tmpimg>=110);
        if layer==1 % red
            tmpimg(ind)=255;
        else % green and blue layers
            tmpimg(ind)=0;
        end
        img(:,:,layer)=tmpimg;
    end
    % try to apply the roi mask
    try 
        for i=1:3 % 3 layers
            img(:,:,i)=img(:,:,i).*handles.Data.roi;
        end
    end
    set(handles.image2,'CData',img,'visible','on')
else
    set(handles.image2,'visible','off')
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

thres=get(handles.sliderthres,'value');
slice=get(handles.imglist,'value');
img=handles.Data.img(:,:,slice);

% apply roipoly
for i=1:size(img,3)
    img(:,:,i)=img(:,:,i).*handles.Data.roi;
end

% convert image volume to isotropic
img=isotropicvol(img,0.36,0.36,0.50);
% smooth image volume
img=smooth3(img);

[f,v] = isosurface(img);
% [f,v] = reducepatch(f,v,0.1);
v=meshsmooth(f,v);

s = regionprops(v, 'area');
area_bw = cat(1, s.Area);

res = 0.8594; % resolusi spasial pixel/mm
area= area_bw/res^2/100;
vol=area*3;
vol_sum = sum(vol)

set(handles.edit2,'String',[num2str(vol_sum)])

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
