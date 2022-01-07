function TaskList = getTaskList()

task_folder = './+TASK';

d = dir(fullfile(task_folder,'+*'));

TaskList = {d.name}';
TaskList = regexprep(TaskList, '\+', '');

end % function
