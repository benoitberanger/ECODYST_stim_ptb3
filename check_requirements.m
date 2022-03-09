function check_requirements()

assert( ~isempty(which('PsychtoolboxRoot')), '"PsychtoolboxRoot" not found : check Psychtooblox installation => http://psychtoolbox.org/' )
assert( ~isempty(which('StimTemplateContent')), '"StimTemplateContent" not found : check StimTemplate installation => https://github.com/benoitberanger/StimTemplate' )

datapath = fullfile( fileparts(pwd), 'data');
assert( exist(datapath, 'dir')>0, 'data dir does not exist, please create it : %s', datapath)

end % function
