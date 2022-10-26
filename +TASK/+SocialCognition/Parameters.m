function [ EP, TaskParam ] = Parameters( OperationMode )
global S

if nargin < 1 % only to plot the paradigme when we execute the function outside of the main script
    OperationMode = 'Acquisition';
end

p = struct; % This structure will contain all task specific parameters, such as Timings and Graphics


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODIFY FROM HERE....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Social cognition

p.nBlock = 1; % repetitions of each condition


%% Timings

% all dur* are in seconds
p.durInstruction  = 6.0;
p.durPresentation = 6.0;
p.durAnswerMax    = 4.0;


%% Debugging

switch OperationMode
    case 'FastDebug'
        p.nBlock          = 1;
        p.durInstruction  = 1.0;
        p.durPresentation = 0.5;
        p.durAnswerMax    = 0.2;
    case 'RealisticDebug'
        p.nBlock          = 1;
        p.durInstruction  = 6.0;
        p.durPresentation = 6.0;
        p.durAnswerMax    = 4.0;
    case 'Acquisition'
        % pass
    otherwise
        error('mode ?')
end

%% Image location

p.imgDir = fullfile( fileparts(pwd), 'img_SocialCognition' );

c = 1;
p.condition(c).name        = 'intention';
p.condition(c).instruction = 'Qu''est-ce que le personnage va faire ensuite ?';
p.condition(c).png         = dir( fullfile(p.imgDir, p.condition(c).name,'*png') );
p.condition(c).img         = {p.condition(c).png.name}';
p.condition(c).side        = cellfun(@(x) x{1}, regexp(p.condition(c).img,'_(\w).png','tokens') );

c = 2;
p.condition(c).name        = 'emotion';
p.condition(c).instruction = 'Qu''est ce qui va permettre au personnage\n de se sentir mieux ?';
p.condition(c).png         = dir( fullfile(p.imgDir, p.condition(c).name,'*png') );
p.condition(c).img         = {p.condition(c).png.name}';
p.condition(c).side        = cellfun(@(x) x{1}, regexp(p.condition(c).img,'_(\w).png','tokens') );

c = 3;
p.condition(c).name        = 'physical_1';
p.condition(c).instruction = 'Quelle suite est la plus probable ?';
p.condition(c).png         = dir( fullfile(p.imgDir, p.condition(c).name,'*png') );
p.condition(c).img         = {p.condition(c).png.name}';
p.condition(c).side        = cellfun(@(x) x{1}, regexp(p.condition(c).img,'_(\w).png','tokens') );

c= 4;
p.condition(c).name        = 'physical_2';
p.condition(c).instruction = 'Quelle suite est la plus probable ?';
p.condition(c).png         = dir( fullfile(p.imgDir, p.condition(c).name,'*png') );
p.condition(c).img         = {p.condition(c).png.name}';
p.condition(c).side        = cellfun(@(x) x{1}, regexp(p.condition(c).img,'_(\w).png','tokens') );


%% Graphics
% graphic parameters are in a sub-function because they are common across tasks

p = TASK.Graphics( p );


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... TO HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Randmization

block_order = [];
for blk = 1 : p.nBlock
    block_order = [block_order Shuffle(1:length(p.condition))];
end

for cond = 1 : length(block_order)
    p.block(cond)      = p.condition(block_order(cond));
    [~, index]         = Shuffle( p.block(cond).img );
    p.block(cond).img  = p.block(cond).img (index);
    p.block(cond).side = p.block(cond).side(index);
end


%% Build planning

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', '#block', 'block_name', '#trial', 'content', 'target(L/R)' };
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

iTrial = 0;
for iBlock = 1 : length(p.block)
    
    EP.AddPlanning    ({ 'Instruction'  NextOnset(EP) p.durInstruction  iBlock p.block(iBlock).name iTrial+1 p.block(iBlock).instruction ''})
    for trial = 1 : length(p.block(iBlock).img)
        iTrial = iTrial + 1;
        EP.AddPlanning({'Presentation'  NextOnset(EP) p.durPresentation iBlock p.block(iBlock).name iTrial   p.block(iBlock).img{trial}  p.block(iBlock).side{trial} })
        EP.AddPlanning({      'Answer'  NextOnset(EP) p.durAnswerMax    iBlock p.block(iBlock).name iTrial   p.block(iBlock).img{trial}  p.block(iBlock).side{trial} })
    end
    
end
p.nTrials = iTrial;


% --- Stop ----------------------------------------------------------------

EP.AddStopTime('StopTime',NextOnset(EP));

EP.BuildGraph();


%% Display

% To prepare the planning and visualize it, we can execute the function
% without output argument

if nargin < 1
    
    fprintf( '\n' )
    fprintf(' \n Total stim duration : %g seconds \n' , NextOnset(EP) )
    fprintf( '\n' )
    
    EP.Plot();
    
end


%% Save

TaskParam = p;

S.EP        = EP;
S.TaskParam = TaskParam;


end % function
