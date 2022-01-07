function [ SubjectID, dirname_SubjectID, dirpath_SubjectID ] = getSubjectID(handles)

% GUI part
SubjectID = get(handles.edit_SubjectID,'String');
if isempty(SubjectID)
    error('SubjectID:Empty','SubjectID is empty')
end

% dir name
date = datestr(now,29);
dirname_SubjectID = [ date '__' SubjectID ];

% dir path
dirpath_SubjectID = fullfile( fileparts(pwd), 'data', dirname_SubjectID, filesep);

end % function
