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
%% SimpleMotor

p.nBlock = 6;

% visual cue frequency, in Hertz (Hz)
p.freqActionCue = 1.0;

% instructions
p.instrAction = 'pianotez';
p.instrRest   = 'restez immobile';


%% Timings

% all dur* are in seconds
p.durInstruction =  5.0;
p.durAction      = 15.0;
p.durRest        = 15.0;


%% Debugging

switch OperationMode
    case 'FastDebug'
        p.nBlock = 2;
        p.durInstruction = 1.0;
        p.durAction      = 4.0;
        p.durRest        = 2.0;
    case 'RealisticDebug'
        p.nBlock = 2;
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


%% Build planning

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', 'block#', 'instruction', 'frequence(Hz)'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

for iBlock = 1 : p.nBlock
    
    EP.AddPlanning({ 'Instruction'  NextOnset(EP) p.durInstruction iBlock p.instrRest   0              })
    EP.AddPlanning({ 'Rest'         NextOnset(EP) p.durRest        iBlock ''            0              })
    EP.AddPlanning({ 'Instruction'  NextOnset(EP) p.durInstruction iBlock p.instrAction 0              })
    EP.AddPlanning({ 'Action'       NextOnset(EP) p.durAction      iBlock ''            p.freqActionCue})
    
end
EP.AddPlanning(    { 'Instruction'  NextOnset(EP) p.durInstruction iBlock p.instrRest   0              })
EP.AddPlanning(    { 'Rest'         NextOnset(EP) p.durRest        iBlock ''            0              })

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
