function edit_SubjectID(hObject, ~)

MinNrChar = 3;

id_str = get(hObject,'String');

if length(id_str) < MinNrChar
    set(hObject,'String','')
    error('SubjectID must be at least %d chars', MinNrChar)
end

fprintf('SubjectID OK : %s \n', id_str)

end % function
