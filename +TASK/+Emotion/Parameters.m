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
%% Emotion


%% Timings

% all dur* are in seconds

p.dur_baseline_instruction = 15.0; % also called "baseline"
p.dur_baseline_rest        = 1.5*60 - p.dur_baseline_instruction;
% total = 1m30s

p.dur_script_instruction   = 10.0;
p.dur_script_playback      = 2.5*60 - p.dur_script_instruction;
% total = 2m30s

p.dur_recovery_instruction = 5.0;
p.dur_recovery_rest        = 1*60 - p.dur_recovery_instruction;
% total = 1m00s

% stotal = 5m00s

p.dur_likert = 10;


%% Text

p.txt_likert_immersion = 'A quel point vous êtes-vous projeté ?';
p.txt_likert_stress    = 'Quel niveau de stress/anxiété/tension ?';

p.likert_N         =  5;
p.likert_label_bot = {'1' '2' '3' '4' '5'};
p.likert_label_top = {
    'pas du tout'
    ''
    ''
    ''
    'énormément'
    };


%% Debugging

switch OperationMode
    case 'FastDebug'
        p.dur_baseline_instruction = 1;
        p.dur_baseline_rest        = 1;
        p.dur_script_instruction   = 1;
        p.dur_script_playback      = 1;
        p.dur_recovery_instruction = 1;
        p.dur_recovery_rest        = 1;
        p.dur_likert               = 3;
    case 'RealisticDebug'
        p.dur_baseline_rest        = 3;
        p.dur_recovery_rest        = 3;
        p.dur_likert               = 5;
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
%% Randmization




%% Build planning

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', '#block', 'condition', 'part', 'type', 'content'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

EP.AddPlanning({'relax_1_baseline_instruction'  NextOnset(EP) p.dur_baseline_instruction  1 'relax'  'baseline' 'instruction' 'baseline_instruction.mp3'})
EP.AddPlanning({'relax_1_baseline_rest'         NextOnset(EP) p.dur_baseline_rest         1 'relax'  'baseline' 'rest'        ''})
EP.AddPlanning({'relax_1_script_instruction'    NextOnset(EP) p.dur_script_instruction    1 'relax'  'script'   'instruction' 'script_instruction.mp3'})
EP.AddPlanning({'relax_1_script_playback'       NextOnset(EP) p.dur_script_playback       1 'relax'  'script'   'playback'    'Script_Relax1.mp3'})
EP.AddPlanning({'relax_1_recovery_instruction'  NextOnset(EP) p.dur_recovery_instruction  1 'relax'  'recovery' 'instruction' 'recovery_instruction.mp3'})
EP.AddPlanning({'relax_1_recovery_rest'         NextOnset(EP) p.dur_recovery_rest         1 'relax'  'recovery' 'rest'        ''})
EP.AddPlanning({'relax_1_likert_immersion'      NextOnset(EP) p.dur_likert                1 'relax'  'lickert'  'immersion'   p.txt_likert_immersion})
EP.AddPlanning({'relax_1_likert_anxiety'        NextOnset(EP) p.dur_likert                1 'relax'  'lickert'  'anxiety'     p.txt_likert_stress})

EP.AddPlanning({'stress_1_baseline_instruction' NextOnset(EP) p.dur_baseline_instruction  1 'stress' 'baseline' 'instruction' 'baseline_instruction.mp3'})
EP.AddPlanning({'stress_1_baseline_rest'        NextOnset(EP) p.dur_baseline_rest         1 'stress' 'baseline' 'rest'        ''})
EP.AddPlanning({'stress_1_script_instruction'   NextOnset(EP) p.dur_script_instruction    1 'stress' 'script'   'instruction' 'script_instruction.mp3'})
EP.AddPlanning({'stress_1_script_playback'      NextOnset(EP) p.dur_script_playback       1 'stress' 'script'   'playback'    'Script_Stress1.mp3'})
EP.AddPlanning({'stress_1_recovery_instruction' NextOnset(EP) p.dur_recovery_instruction  1 'stress' 'recovery' 'instruction' 'recovery_instruction.mp3'})
EP.AddPlanning({'stress_1_recovery_rest'        NextOnset(EP) p.dur_recovery_rest         1 'stress' 'recovery' 'rest'        ''})
EP.AddPlanning({'stress_1_likert_immersion'     NextOnset(EP) p.dur_likert                1 'stress' 'lickert'  'immersion'   p.txt_likert_immersion})
EP.AddPlanning({'stress_1_likert_anxiety'       NextOnset(EP) p.dur_likert                1 'stress' 'lickert'  'anxiety'     p.txt_likert_stress})

EP.AddPlanning({'relax_2_baseline_instruction'  NextOnset(EP) p.dur_baseline_instruction  2 'relax'  'baseline' 'instruction' 'baseline_instruction.mp3'})
EP.AddPlanning({'relax_2_baseline_rest'         NextOnset(EP) p.dur_baseline_rest         2 'relax'  'baseline' 'rest'        ''})
EP.AddPlanning({'relax_2_script_instruction'    NextOnset(EP) p.dur_script_instruction    2 'relax'  'script'   'instruction' 'script_instruction.mp3'})
EP.AddPlanning({'relax_2_script_playback'       NextOnset(EP) p.dur_script_playback       2 'relax'  'script'   'playback'    'Script_Relax2.mp3'})
EP.AddPlanning({'relax_2_recovery_instruction'  NextOnset(EP) p.dur_recovery_instruction  2 'relax'  'recovery' 'instruction' 'recovery_instruction.mp3'})
EP.AddPlanning({'relax_2_recovery_rest'         NextOnset(EP) p.dur_recovery_rest         2 'relax'  'recovery' 'rest'        ''})
EP.AddPlanning({'relax_2_likert_immersion'      NextOnset(EP) p.dur_likert                2 'relax'  'lickert'  'immersion'   p.txt_likert_immersion})
EP.AddPlanning({'relax_2_likert_anxiety'        NextOnset(EP) p.dur_likert                2 'relax'  'lickert'  'anxiety'     p.txt_likert_stress})

EP.AddPlanning({'stress_2_baseline_instruction' NextOnset(EP) p.dur_baseline_instruction  2 'stress' 'baseline' 'instruction' 'baseline_instruction.mp3'})
EP.AddPlanning({'stress_2_baseline_rest'        NextOnset(EP) p.dur_baseline_rest         2 'stress' 'baseline' 'rest'        ''})
EP.AddPlanning({'stress_2_script_instruction'   NextOnset(EP) p.dur_script_instruction    2 'stress' 'script'   'instruction' 'script_instruction.mp3'})
EP.AddPlanning({'stress_2_script_playback'      NextOnset(EP) p.dur_script_playback       2 'stress' 'script'   'playback'    'Script_Stress2.mp3'})
EP.AddPlanning({'stress_2_recovery_instruction' NextOnset(EP) p.dur_recovery_instruction  2 'stress' 'recovery' 'instruction' 'recovery_instruction.mp3'})
EP.AddPlanning({'stress_2_recovery_rest'        NextOnset(EP) p.dur_recovery_rest         2 'stress' 'recovery' 'rest'        ''})
EP.AddPlanning({'stress_2_likert_immersion'     NextOnset(EP) p.dur_likert                2 'stress' 'lickert'  'immersion'   p.txt_likert_immersion})
EP.AddPlanning({'stress_2_likert_anxiety'       NextOnset(EP) p.dur_likert                2 'stress' 'lickert'  'anxiety'     p.txt_likert_stress})

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
