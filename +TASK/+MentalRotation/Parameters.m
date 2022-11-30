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
%% 3D Tetris (1/2)

p.cube_segment = [4 3 4 3]; % IMPORTANT : keep an asymatric tetris, so there is no ambiguity

p.miniblock  = {
    % angle  name
    0        'same'
    0        'same'
    120      'same'
    120      'mirror'
    };

p.num_tetris = 15;  % == number of repetitions


%% Timings

p.durTetris   = 10;    %           seconds
p.durFixation = [5 6]; % [min max] seconds

% In this task the 3D rendering VERY fast, but capturing the image to
% perform the hack is VERY slow. This parameter is used to help having
% better timings for the "Rest" event. On my dev computer, the whole
% render+drawing time is ~80ms.
p.durMaxRenderTime = 0.100; % seconds


%% Debugging

switch OperationMode
    case 'FastDebug'
        p.num_tetris  = 2;
        p.durFixation = [0.2 0.2];
    case 'RealisticDebug'
        p.num_tetris  = 4;
        p.durFixation = [0.5 0.8];
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

nTrials = size(p.miniblock,1) * p.num_tetris;
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

all_jitters = linspace(p.durFixation(1), p.durFixation(2), nTrials + 1);
all_jitters = Shuffle(all_jitters);


%% Pseudo-randomize events

event_list = {};
for n = 1 : p.num_tetris
    event_list = [event_list ; Shuffle(p.miniblock,2)]; %#ok<AGROW> 
end

tetris_list = repmat(all_tetris, [size(p.miniblock,1) 1]);
tetris_list = Shuffle(tetris_list,2);

event_list(:,3) = num2cell(tetris_list,2);


%% Build planning

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', 'iTrial', 'angle(deg)', 'condition', 'tetris'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

for iTrial = 1 : nTrials
    
    EP.AddPlanning({ 'Rest'  NextOnset(EP) all_jitters(iTrial) iTrial   [] [] []             })
    EP.AddPlanning({ 'Trial' NextOnset(EP) p.durTetris         iTrial   event_list{iTrial,:} })
    
end

EP.AddPlanning({ 'Rest'  NextOnset(EP) all_jitters(iTrial+1)   iTrial+1 [] [] []             })


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
