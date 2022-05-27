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

p.nBlock = 2; % repetitions of each condition


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

p.condition(1).name = 'intention';
p.condition(1).instruction = 'Qu''est-ce que le personnage va faire ensuite ?';
p.condition(1).img = {
    'Diapositive2.png'
    'Diapositive3.png'
    'Diapositive4.png'
    'Diapositive5.png'
    'Diapositive6.png'
    'Diapositive7.png'
    'Diapositive8.png'
    'Diapositive9.png'
    'Diapositive10.png'
    'Diapositive11.png'
    };

p.condition(2).name = 'emotion';
p.condition(2).instruction = 'Qu''est ce qui va permettre au personnage\n de se sentir mieux ?';
p.condition(2).img = {
    'Diapositive13.png'
    'Diapositive14.png'
    'Diapositive15.png'
    'Diapositive16.png'
    'Diapositive17.png'
    'Diapositive18.png'
    'Diapositive19.png'
    'Diapositive20.png'
    'Diapositive21.png'
    'Diapositive22.png'
    };

p.condition(3).name = 'physical_1';
p.condition(3).instruction = 'Quelle suite est la plus probable ?';
p.condition(3).img = {
    'Diapositive24.png'
    'Diapositive25.png'
    'Diapositive26.png'
    'Diapositive27.png'
    'Diapositive28.png'
    'Diapositive29.png'
    'Diapositive30.png'
    'Diapositive31.png'
    'Diapositive32.png'
    'Diapositive33.png'
    };

p.condition(4).name = 'physical_2';
p.condition(4).instruction = 'Quelle suite est la plus probable ?';
p.condition(4).img = {
    'Diapositive35.png'
    'Diapositive36.png'
    'Diapositive37.png'
    'Diapositive38.png'
    'Diapositive39.png'
    'Diapositive40.png'
    'Diapositive41.png'
    'Diapositive42.png'
    'Diapositive43.png'
    'Diapositive44.png'
    };


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
    p.block(cond) = p.condition(block_order(cond));
    p.block(cond).img = Shuffle( p.block(cond).img );
end


%% Build planning

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', '#block', '#trial', 'content' };
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

iTrial = 0;
for iBlock = 1 : length(p.block)
    
    EP.AddPlanning    ({ 'Instruction'  NextOnset(EP) p.durInstruction  iBlock iTrial+1 p.block(iBlock).instruction })
    for trial = 1 : length(p.block(iBlock).img)
        iTrial = iTrial + 1;
        EP.AddPlanning({'Presentation'  NextOnset(EP) p.durPresentation iBlock iTrial   p.block(iBlock).img{trial}  })
        EP.AddPlanning({      'Answer'  NextOnset(EP) p.durAnswerMax    iBlock iTrial   p.block(iBlock).img{trial}  })
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
