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
%% Fluency


%% Timings

% all dur* are in seconds
p.durInstruction =  5.0;
p.durBlockRest   = 30.0;
p.durBlockAction = 60.0;


%% Debugging

switch OperationMode
    case 'FastDebug'
        p.durInstruction = 1.0;
        p.durBlockRest   = 2.0;
        p.durBlockAction = 3.0;
    case 'RealisticDebug'
        % pass
    case 'Acquisition'
        % pass
    otherwise
        error('mode ?')
end


%% Fluency blocks

instruction_rest = 'repos';

c = 1;
p.condition(c).type = 'semantic';
p.condition(c).name = 'animals';
p.condition(c).instruction = 'des noms d''animaux';

c = 2;
p.condition(c).type = 'semantic';
p.condition(c).name = 'cloths';
p.condition(c).instruction = 'des noms de vêtements';

c = 3;
p.condition(c).type = 'phonemic';
p.condition(c).name = 'F';
p.condition(c).instruction = 'mots débutants par « F »';

c = 4;
p.condition(c).type = 'phonemic';
p.condition(c).name = 'C';
p.condition(c).instruction = 'mots débutants par « C »';


%% Graphics
% graphic parameters are in a sub-function because they are common across tasks

p = TASK.Graphics( p );


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... TO HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Randmization

block_order = Shuffle(1:4);

for cond = 1 : length(block_order)
    p.block(cond)      = p.condition(block_order(cond));
end


%% Build planning

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', '#block', 'type', 'name', 'instruction'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

for iBlock = 1 : length(p.block)

    name = ['block_action_' p.block(iBlock).type '_' p.block(iBlock).name];
    
    EP.AddPlanning({'instr_rest'    NextOnset(EP) p.durInstruction iBlock ''                   ''                   instruction_rest})
    EP.AddPlanning({'block_rest'    NextOnset(EP) p.durBlockRest   iBlock ''                   ''                   ''})
    
    EP.AddPlanning({'instr_action'  NextOnset(EP) p.durInstruction iBlock ''                   ''                   p.block(iBlock).instruction})
    EP.AddPlanning({name            NextOnset(EP) p.durBlockAction iBlock p.block(iBlock).type p.block(iBlock).name ''})
     
end

EP.AddPlanning(    {'instr_rest'    NextOnset(EP) p.durInstruction iBlock ''                   ''                   instruction_rest})
EP.AddPlanning(    {'block_rest'    NextOnset(EP) p.durBlockRest   iBlock ''                   ''                   ''})

p.nTrials = iBlock*4 + 2;


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