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

p.dur_baseline_instruction = 5.0; % also called "baseline"
p.dur_baseline_rest        = 1.5*60 - p.dur_baseline_instruction;
% total = 1m30s

p.dur_script_instruction   = 10.0;
p.dur_script_playback      = 2.5*60 - p.dur_script_instruction;
% total = 2m30s

p.dur_postscript           = 30;

p.dur_recovery_instruction = 15.0;
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
        p.dur_postscript           = 1;
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

type_shuffled   = Shuffle({'relax' 'stress'});
number_shuffled = Shuffle([1 2]);
order = {
    type_shuffled{1} number_shuffled(1)
    type_shuffled{2} number_shuffled(2)
    type_shuffled{1} number_shuffled(2)
    type_shuffled{2} number_shuffled(1)
    };

% sanity check
order_check = strcat(order(:,1), '_', cellfun(@num2str, order(:,2)) );
assert(length(unique(order_check)) == length(order_check), 'bad randomization')


%% Build planning

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', '#block', 'condition', 'part', 'type', 'content'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

for o = 1: size(order,1)
    type = order{o,1};
    num  = order{o,2};
    EP.AddPlanning({sprintf('%s_%d__baseline_instruction', type, num)  NextOnset(EP) p.dur_baseline_instruction  num type  'baseline' 'instruction' 'baseline_instruction.mp3'})
    EP.AddPlanning({sprintf('%s_%d__baseline_rest'       , type, num)  NextOnset(EP) p.dur_baseline_rest         num type  'baseline' 'rest'        ''                        })
    EP.AddPlanning({sprintf('%s_%d__script_instruction'  , type, num)  NextOnset(EP) p.dur_script_instruction    num type  'script'   'instruction' 'script_instruction.mp3'  })
    EP.AddPlanning({sprintf('%s_%d__script_playback'     , type, num)  NextOnset(EP) p.dur_script_playback       num type  'script'   'playback'    sprintf('Script_%s%d.mp3',type,num)})
    EP.AddPlanning({sprintf('%s_%d__postscript'          , type, num)  NextOnset(EP) p.dur_postscript            num type  'script'   'postscript'  ''                        })
    EP.AddPlanning({sprintf('%s_%d__recovery_instruction', type, num)  NextOnset(EP) p.dur_recovery_instruction  num type  'recovery' 'instruction' 'recovery_instruction.mp3'})
    EP.AddPlanning({sprintf('%s_%d__recovery_rest'       , type, num)  NextOnset(EP) p.dur_recovery_rest         num type  'recovery' 'rest'        ''                        })
    EP.AddPlanning({sprintf('%s_%d__likert_immersion'    , type, num)  NextOnset(EP) p.dur_likert                num type  'lickert'  'immersion'   p.txt_likert_immersion    })
    EP.AddPlanning({sprintf('%s_%d__likert_anxiety'      , type, num)  NextOnset(EP) p.dur_likert                num type  'lickert'  'anxiety'     p.txt_likert_stress       })
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
