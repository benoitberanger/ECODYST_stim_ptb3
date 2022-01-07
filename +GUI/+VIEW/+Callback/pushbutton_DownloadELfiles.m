function pushbutton_DownloadELfiles(hObject, ~)
handles = guidata(hObject);

[ ~, ~, dirpath_SubjectID ] = CONTROLLER.getSubjectID(handles);

el_file = fullfile( dirpath_SubjectID, 'eyelink_files_to_download.txt' );

if ~exist(el_file,'file')
    error('File does not exists : %s', el_file)
end

Eyelink.downloadELfiles(dirpath_SubjectID)

end % function
