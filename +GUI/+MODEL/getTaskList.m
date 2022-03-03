function TaskList = getTaskList()

task_folder = './+TASK';

d = dir(fullfile(task_folder,'+*'));

dirname = {d.name}';
TaskList_raw = regexprep(dirname, '\+', ''); % remove the + at the begining

% discard only UPPER case dirs
TaskList_upper = upper(TaskList_raw);
Task_idx = ~strcmp(TaskList_upper, TaskList_raw);
TaskList = TaskList_raw(Task_idx);

end % function
