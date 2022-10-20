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

p.condition(1,1).type = 'semantic';
p.condition(1,1).name = 'animals';
p.condition(1,1).instruction = 'des noms d''animaux';

p.condition(1,2).type = 'semantic';
p.condition(1,2).name = 'cloths';
p.condition(1,2).instruction = 'des noms de vêtements';

p.condition(2,1).type = 'phonemic';
p.condition(2,1).name = 'F';
p.condition(2,1).instruction = 'mots débutants par « F »';

p.condition(2,2).type = 'phonemic';
p.condition(2,2).name = 'C';
p.condition(2,2).instruction = 'mots débutants par « C »';


%% Graphics
% graphic parameters are in a sub-function because they are common across tasks

p = TASK.Graphics( p );


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... TO HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Randmization

type_order = Shuffle([1 2]);
name_order = Shuffle([1 2]);


p.block(1) = p.condition(type_order(1),name_order(1));
p.block(2) = p.condition(type_order(2),name_order(1));
p.block(3) = p.condition(type_order(1),name_order(2));
p.block(4) = p.condition(type_order(2),name_order(2));


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