function Runtime()
global S

try
    %% Tuning of the task
    
    TASK.Keybindings();
    [ EP, p ] = TASK.Fluency.Parameters( S.OperationMode );
    
    
    %% Prepare recorders
    
    PTB_ENGINE.PrepareRecorders( S.EP );
    S.BR = EventRecorder({'event_name' '#block', 'type', 'name', 'instruction', 'mic_data', 'nsample', 'dur', 'expected_dur', 'delta'}, p.nTrials);
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS = TASK.            PREPARE.FixationCross();
    TEXT          = TASK.Fluency.PREPARE.Text         ();
    
    
    %% Shortcuts
    
    ER          = S.ER; % EventRecorder
    BR          = S.BR; % BehaviourRecorder (EventRecorder)
    wPtr        = S.PTB.Video.wPtr;
    wRect       = S.PTB.Video.wRect;
    slack       = S.PTB.Video.slack;
    pahandle    = S.PTB.Audio.Record.pahandle;
    fs          = S.PTB.Audio.Record.SamplingFrequency;
    KEY_ESCAPE  = S.Keybinds.Common.Stop_Escape;
    if S.MovieMode, moviePtr = S.moviePtr; end
    
    
    %% Planning columns
    
    columns = struct;
    for c = 1 : EP.Columns
        col_name = matlab.lang.makeValidName( EP.Header{c} );
        columns.(col_name) = c;
    end
    
    
    %% GO
    
    EXIT = false;
    secs = GetSecs();
    audiodata = [];
    prev = struct;
    
    % Loop over the EventPlanning
    nEvents = size( EP.Data , 1 );
    for evt = 1 : nEvents
        
        % Shortcuts
        evt_name     = EP.Data{evt,columns.event_name };
        evt_onset    = EP.Data{evt,columns.onset_s_   };
        evt_duration = EP.Data{evt,columns.duration_s_};
        iblock       = EP.Data{evt,columns.x_block    };
        type         = EP.Data{evt,columns.type       };
        name         = EP.Data{evt,columns.name       };
        instruction  = EP.Data{evt,columns.instruction};
        
        if evt < nEvents
            next_evt_onset = EP.Data{evt+1,columns.onset_s_};
        end
        
        if evt > 1
           prev.evt_name    = EP.Data{evt-1,columns.event_name };
           prev.evt_duration= EP.Data{evt-1,columns.duration_s_};
           prev.iblock      = EP.Data{evt-1,columns.x_block    };
           prev.type        = EP.Data{evt-1,columns.type       };
           prev.name        = EP.Data{evt-1,columns.name       };
           prev.instruction = EP.Data{evt-1,columns.instruction};
        end
        
        switch evt_name
            
            case 'StartTime' % --------------------------------------------
                
                % Draw
                FIXATIONCROSS.Draw();
                Screen('DrawingFinished', wPtr);
                Screen('Flip',wPtr);
                
                % Start audio capture immediately and wait for the capture to start.
                % We set the number of 'repetitions' to zero,
                % i.e. record until recording is manually stopped.
                PsychPortAudio('Start', pahandle, 0, 0, 1);
                StartTime = PTB_ENGINE.StartTimeEvent(); % a wrapper, deals with hidemouse, eyelink, mri sync, ...
                GetAudioData(pahandle, fs); % empy buffer
                
            case 'StopTime' % ---------------------------------------------
                
                StopTime = WaitSecs('UntilTime', StartTime + S.ER.Data{S.ER.EventCount,2} + S.EP.Data{evt-1,3} );
                
                % Record StopTime
                S.ER.AddStopTime( 'StopTime' , StopTime - StartTime );
                
                % last audio data
                PsychPortAudio('Stop', pahandle);
                [audiodata, nsample, dur] = GetAudioData(pahandle, fs); % get audio data
                BR.AddEvent({prev.evt_name prev.iblock prev.type prev.name prev.instruction audiodata nsample dur prev.evt_duration dur-prev.evt_duration});
    
                
            case {'instr_rest', 'instr_action'} % -------------------------------------------------
                
                % Draw
                TEXT.Draw(instruction, 'Instruction');
                Screen('DrawingFinished', wPtr);
                
                % Flip at the right moment
                desired_onset =  StartTime + evt_onset - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                [audiodata, nsample, dur] = GetAudioData(pahandle, fs); % get audio data
                if evt > 2 % meaningful data start after the 1st 'instr_rest' block (which is 2nd event)
                    BR.AddEvent({prev.evt_name prev.iblock prev.type prev.name prev.instruction audiodata nsample dur prev.evt_duration dur-prev.evt_duration});
                end
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
                
                fprintf('block#=%1d // block_name=%30s // instructions = %s \n', iblock, evt_name, instruction)
                                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = StartTime + next_evt_onset - slack;
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(KEY_ESCAPE);
                        if EXIT, break, end
                    end
                    
                end % while
                
                
            case {'block_rest', 'block_action_semantic_animals', 'block_action_semantic_cloths', 'block_action_phonemic_F', 'block_action_phonemic_C'}
                
                % Draw
                FIXATIONCROSS.Draw();
                Screen('DrawingFinished', wPtr);
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameBackBuffer(wPtr,moviePtr); end
                
                % Flip at the right moment
                real_onset = Screen('Flip', wPtr, desired_onset);
                [audiodata, nsample, dur] = GetAudioData(pahandle, fs); % get audio data
                BR.AddEvent({prev.evt_name prev.iblock prev.type prev.name prev.instruction audiodata nsample dur prev.evt_duration dur-prev.evt_duration});
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
                
                fprintf('block#=%1d // block_name=%30s \n', iblock, evt_name)
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = StartTime + next_evt_onset - slack;
                
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(KEY_ESCAPE);
                        if EXIT, break, end
                    end
                    
                end % while
                
            otherwise % ---------------------------------------------------
                
                error('unknown envent')
                
        end % switch
        
        % if ESCAPE is pressed
        if EXIT
            StopTime = secs;
            
            % Record StopTime
            ER.AddStopTime( 'StopTime', StopTime - StartTime );
            
            Priority(0);
            
            fprintf('ESCAPE key pressed \n');
            break
        end
        
    end % for
    
    
    %% End of task execution stuff
    
    % Save some values
    S.StartTime = StartTime;
    S.StopTime  = StopTime;
    
    PTB_ENGINE.FinilizeRecorders();
    
    % Close parallel port
    if S.ParPort, CloseParPort(); end
    
    % Diagnotic
    switch S.OperationMode
        case 'Acquisition'
        case 'FastDebug'
            % plotDelay(EP,ER);
        case 'RealisticDebug'
            % plotDelay(EP,ER);
    end
    
    try % I really don't want to this feature to screw a standard task execution
        if exist('moviePtr','var')
            PTB_ENGINE.VIDEO.MOVIE.Finalize(moviePtr);
        end
    catch
    end
    
    
catch err
    
    sca;
    Priority(0);
    
    rethrow(err);
    
    if exist('moviePtr','var') %#ok<UNRCH>
        PTB_ENGINE.VIDEO.MOVIE.Finalize(moviePtr);
    end
    
    try
        PsychPortAudio('Stop', pahandle);
        PsychPortAudio('Close');
    catch
    end
    
end % try

end % function


function [audiodata, nsample, dur] = GetAudioData(pahandle, fs)

audiodata = PsychPortAudio('GetAudioData', pahandle);
nsample = length(audiodata);
dur = nsample/fs;

end % function
