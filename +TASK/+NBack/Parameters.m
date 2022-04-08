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
%% N-Back

p.nBack      = [0 2]; % 0-back & 2-back
p.nBlock     = 3;     % repetition of each x-back block
p.catchRatio = 0.20;  % percentage of catch
p.nCatch     = 5;     % catch items per block

p.availLetter{1} = { 'B' 'N' 'D' 'Q' 'G' 'S' 'J' 'V' };
p.availLetter{2} = { 'C' 'P' 'F' 'R' 'H' 'T' 'L'  };
% this is seperated into 2 lists, to help psedo-random setup


%% Timings

% all in seconds
p.durInstruction = 4.0;
p.durStim        = 0.5;
p.durDelay       = 1.5;
p.durRest        = [8 8]; % [min max] for the jitter


%% Debugging

switch OperationMode
    case 'FastDebug'
        p.nBlock     = 1;
        p.nCatch     = 3;
        p.durInstruction = 1.0;
        p.durStim        = 0.2;
        p.durDelay       = 0.5;
        p.durRest        = [0.5 0.5];
    case 'RealisticDebug'
        p.nBlock     = 1;
        p.nCatch     = 3;
        p.durRest        = [1.0 1.0];
    case 'Acquisition'
        % pass
    otherwise
        error('mode ?')
end


%% Graphics
% graphic parameters are in a sub-function because they are common across tasks

p = TASK.Graphics( p );


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... TO HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define a planning <--- paradigme

nStim = round(p.nCatch * 1/p.catchRatio);
block_order = repmat(p.nBack, [1 p.nBlock]);
p.nTrials = length(block_order) * nStim;

blocks(length(block_order)) = struct;

for iBlock = 1 : length(block_order)
    
    % save difficulty info
    blocks(iBlock).nBack = block_order(iBlock);
    
    % generate random pseudo-random stim
    starting_subgroup = round(rand)+1;
    ending_subgroup   = -starting_subgroup + 3; % [1 2] -> [2 1]
    blk = [];
    while length(blk) < nStim % generate as much as we need
        blk = [blk Shuffle( p.availLetter{starting_subgroup} ) Shuffle( p.availLetter{ending_subgroup} )];
    end
    blk = blk(1:nStim); % crop to the right number
    
    % define position of catch trials
    position = linspace(1,nStim,p.nCatch+2); position = position(2:end-1); % evenly spread in the middle
    displacement = round(3*(rand(1,p.nCatch)-0.5)); % add some radomness {-1 0 +1} in the position
    position = round(position) + displacement;
    
    if block_order(iBlock) == 0
        blk(position) = {'X'}; % replace the catch trials
        blocks(iBlock).instruction = 'REPONDRE A "X"';
    else
        for pos_idx = 1:length(position)
            blk(position(pos_idx)) = blk(position(pos_idx)-block_order(iBlock)); % replace the catch trials
        end
        blocks(iBlock).instruction = sprintf('BLOC %d-BACK', block_order(iBlock));
    end
    
    % save
    blocks(iBlock).Trials = blk;
    blocks(iBlock).CatchIdx = position;
    vect = zeros(1,nStim);
    vect(position) = 1;
    blocks(iBlock).CatchVect = vect;
    
end

% save
p.blocks = blocks;


%% Generate jitter

all_jitters = linspace(p.durRest(1), p.durRest(2), length(block_order) + 1);
all_jitters = Shuffle(all_jitters);


%% Build planning

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', '#trial',  '#block', '#stim', 'content', 'iscatch'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

count = 0;
for iBlock = 1 : length(block_order)
    
    EP.AddPlanning({     'Rest'        NextOnset(EP) all_jitters(iBlock) []    []     []    []                          []                               })
    EP.AddPlanning({     'Instruction' NextOnset(EP) p.durInstruction    []    []     []    blocks(iBlock).instruction  []                               })
    EP.AddPlanning({     'Delay'       NextOnset(EP) p.durDelay          []    []     []    []                          []                               })
    for iStim = 1 : nStim
        count = count + 1;
        EP.AddPlanning({ 'Stim'        NextOnset(EP) p.durStim           count iBlock iStim blocks(iBlock).Trials{iStim} blocks(iBlock).CatchVect(iStim) })
        EP.AddPlanning({ 'Delay'       NextOnset(EP) p.durDelay          []    []     []    []                          []                               })
    end
end
EP.AddPlanning({         'Rest'        NextOnset(EP) all_jitters(iBlock) []    []     []    []                          []                               })


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
