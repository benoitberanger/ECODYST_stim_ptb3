function [ EP, TaskParam ] = Parameters( OperationMode )
global S

if nargout < 1 % only to plot the paradigme when we execute the function outside of the main script
    OperationMode = 'Acquisition';
end

p = struct; % This structure will contain all task specific parameters, such as Timings and Graphics


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODIFY FROM HERE....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3D Tetris

p.cube_segment = [3 2 2 2];
p.angle        = [20 40 60 100]; % degees
p.num_tetris   = 10;


%% Timings

p.durTetris   = 10;    %           seconds
p.durFixation = [5 6]; % [min max] seconds


%% Graphics
% graphic parameters are in a sub-function because they are common across tasks

p = TASK.Graphics( p );


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... TO HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define a planning <--- paradigme

nTrials = length(p.angle) * p.num_tetris * 2; % x2 because of same VS mirror


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


