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
%% 3D Tetris

p.cube_segment = [1 1 1 1] * 4;
p.angle        = [0 60]; % degees == difficulty level
p.num_tetris   = 10;


%% Timings

p.durTetris   = 10;    %           seconds
p.durFixation = [5 6]; % [min max] seconds


%% Debugging

switch OperationMode
    case 'FastDebug'
        p.num_tetris  = 2;
        p.durTetris   = 1;
        p.durFixation = [0.5 0.6];
    case 'RealisticDebug'
        
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

nAngle  = length(p.angle);
nTrials = nAngle * p.num_tetris * 2; % x2 because of same VS mirror
p.nTrials = nTrials;


%% Generate tetris

nSeg = length(p.cube_segment);

all_tetris = zeros(p.num_tetris, nSeg); % contain all generated tetris

for t = 1 : p.num_tetris
    
    if t == 1
        
        tetris = generate_random_tetris(nSeg);
        
        all_tetris(t,:) = tetris; % since its the first, just store it
        
    else
        
        while 1
            
            tetris = generate_random_tetris(nSeg);
            
            is_new_tetris = ~any(sum(all_tetris == tetris,2) == nSeg);
            
            if is_new_tetris
                all_tetris(t,:) = tetris;
                break
            end
            
        end
        
    end
    
end

% shuffle one last time
all_tetris = Shuffle(all_tetris,2);


%% Generate Fixation jitter

all_jitters = linspace(p.durFixation(1), p.durFixation(2), nTrials);
all_jitters = Shuffle(all_jitters);


%% Pseudo-randomize events

event_list = cell(nTrials, 3);

mb_length = nAngle * 2;

for n = 1 : p.num_tetris
    
    miniblock_same = cell(nAngle,2);
    miniblock_same(:,1) = num2cell(p.angle');
    miniblock_same(:,2) = {'same'};
    
    miniblock_mirror = miniblock_same;
    miniblock_mirror(:,2) = {'mirror'};
    
    miniblock = Shuffle([miniblock_same ; miniblock_mirror], 2);
    
    idx = (1:mb_length) + (n-1)*mb_length;
    event_list(idx,1:2) = miniblock;
    
end

tetris_list = repmat(all_tetris, [mb_length 1]);
tetris_list = Shuffle(tetris_list,2);

event_list(:,3) = num2cell(tetris_list,2);

% event_table = cell2table(event_list,...
%     'VariableNames', {'angle', 'condition', 'tetris'},...
%     'RowNames', cellstr(num2str( (1:nTrials)' )));


%% Build planning

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', 'iTrial', 'angle(°)', 'condition', 'tetris'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

for iTrial = 1 : nTrials
    
    EP.AddPlanning({ 'Rest'  NextOnset(EP) all_jitters(iTrial) iTrial [] [] []})
    EP.AddPlanning({ 'Trial' NextOnset(EP) p.durTetris         iTrial event_list{iTrial,:}})
    
end


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

function tetris = generate_random_tetris(nSeg)

% generate X Y Z order
order = Shuffle([1 2 3]);
if nSeg > 3
    order = repmat(order, [1 ceil(nSeg/3)]);
    order = order(1:nSeg);
end

% generate positive or negative axis direction
signs = sign(rand(1,nSeg) - 0.5);

% finalize
tetris = order.*signs;

end % function
