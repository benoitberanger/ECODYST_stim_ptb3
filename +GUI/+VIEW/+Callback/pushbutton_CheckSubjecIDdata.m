function pushbutton_CheckSubjecIDdata(hObject, ~)
handles = guidata(hObject);

[ ~ , ~ , dirpath_SubjectID ] = GUI.CONTROLLER.getSubjectID(handles);

if ~isdir( dirpath_SubjectID )
    warning('SubjectID directory does not exist : %s' , fileparts(dirpath_SubjectID) )
    return
end

% Content order : older to newer
dirContent = dir(dirpath_SubjectID);

% Display dir
fprintf('\nSubjectID data dir %s content : \n', dirpath_SubjectID)

% Display content
for idx = 1 : length(dirContent)
    fprintf(' %s \n', dirContent(idx).name)
end

end % function
