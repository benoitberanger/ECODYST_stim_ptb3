function Runtime()
global S

try
    %% Tuning of the task
    
    TASK.Keybindings();
    [ EP, p ] = TASK.NBack.Parameters( S.OperationMode );
    
    
    %% Prepare recorders
    
    PTB_ENGINE.PrepareRecorders( S.EP );
    S.BR = EventRecorder({'trial#' 'block#' 'stim#' 'content' 'iscatch' 'RT(s)'}, S.TaskParam.nTrials);
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS = TASK.      PREPARE.FixationCross();
    TEXT          = TASK.NBack.PREPARE.Text         ();
    
    
    %% Shortcuts
    
    ER          = S.ER; % EventRecorder
    BR          = S.BR; % BehaviourRecorder (EventRecorder)
    wPtr        = S.PTB.Video.wPtr;
    wRect       = S.PTB.Video.wRect;
    slack       = S.PTB.Video.slack;
    KEY_ESCAPE  = S.Keybinds.Common.Stop_Escape;
    KEY_Catch   = S.Keybinds.TaskSpecific.Catch;
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
    n_resp_ok = 0;
    n_catch = 0;
    
    % Loop over the EventPlanning
    nEvents = size( EP.Data , 1 );
    for evt = 1 : nEvents
        
        % Shortcuts
        evt_name     = EP.Data{evt,columns.event_name};
        evt_onset    = EP.Data{evt,columns.onset_s_};
        evt_duration = EP.Data{evt,columns.duration_s_};
        content      = EP.Data{evt,columns.content};
        
        if evt < nEvents
            next_evt_onset = EP.Data{evt+1,columns.onset_s_};
        end
        
        switch evt_name
            
            case 'StartTime' % --------------------------------------------
                
                % Draw
                FIXATIONCROSS.Draw();
                Screen('DrawingFinished', wPtr);
                Screen('Flip',wPtr);
                
                StartTime     = PTB_ENGINE.StartTimeEvent(); % a wrapper, deals with hidemouse, eyelink, mri sync, ...
                
                
            case 'StopTime' % ---------------------------------------------
                
                StopTime = WaitSecs('UntilTime', StartTime + S.ER.Data{S.ER.EventCount,2} + S.EP.Data{evt-1,3} );
                
                % Record StopTime
                S.ER.AddStopTime( 'StopTime' , StopTime - StartTime );
                
                
            case 'Rest' % -------------------------------------------------
                
                % Draw
                FIXATIONCROSS.Draw();
                Screen('DrawingFinished', wPtr);
                
                % Flip at the right moment
                desired_onset =  StartTime + evt_onset - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = StartTime + next_evt_onset - slack;
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(KEY_ESCAPE);
                        if EXIT, break, end
                    end
                    
                end % while
                
            case 'Instruction' % -------------------------------------------------
                
                % Draw
                TEXT.Draw(content, 'Instruction');
                Screen('DrawingFinished', wPtr);
                
                % Flip at the right moment
                desired_onset =  StartTime + evt_onset - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
                
                fprintf('Instructions = %s \n', content )
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = StartTime + next_evt_onset - slack;
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(KEY_ESCAPE);
                        if EXIT, break, end
                    end
                    
                end % while
                clear has_responded_stim
                clear has_responded
                
            case 'Delay' % -------------------------------------------------
                
                % Draw
                Screen('DrawingFinished', wPtr);
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameBackBuffer(wPtr,moviePtr); end
                
                % Flip at the right moment
                desired_onset =  StartTime + evt_onset - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = StartTime + next_evt_onset - slack;
                
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(KEY_ESCAPE);
                        if EXIT, break, end
                        
                        if exist('has_responded_stim', 'var')
                            if has_responded_stim
                                has_responded = 1;
                                break
                            elseif keyCode(KEY_Catch)
                                has_responded = 1;
                                RT = secs - real_onset;
                                resp_ok = iscatch;
                                n_resp_ok = n_resp_ok + resp_ok;
                                break
                            end
                        end
                        
                    end
                    
                end % while
                
                if exist('has_responded','var')
                    if has_responded
                        
                        % BR.AddEvent({trial condition angle tetris RT subj_resp resp_ok})
                        
                        if ~iscatch
                            n_resp_ok = n_resp_ok - 1;
                        end
                        
                        fprintf('RT=%5.fms   resp_ok=%1d (%3d%%)\n',...
                            round(RT * 1000),...
                            resp_ok,...
                            round(100*n_resp_ok / n_catch) ...
                            )
                    else
                        if iscatch
                            iscatch_str = '0';
                        else
                            iscatch_str = '';
                        end
                        fprintf('RT=%5sms   resp_ok=%1s (%3d%%)\n',...
                            '',...
                            iscatch_str,...
                            round(100*n_resp_ok / n_catch) ...
                            )
                    end
                    clear has_responded
                end
                
                
            case 'Stim' % -------------------------------------------------
                
                itrial  = EP.Data{evt,columns.x_trial};
                iblock  = EP.Data{evt,columns.x_block};
                istim   = EP.Data{evt,columns.x_stim};
                iscatch = EP.Data{evt,columns.iscatch};
                
                % Draw
                TEXT.Draw(content, 'Stim');
                Screen('DrawingFinished', wPtr);
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameBackBuffer(wPtr,moviePtr); end
                
                % Flip at the right moment
                desired_onset =  StartTime + evt_onset - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
                
                if iscatch
                    iscatch_str = '1';
                else
                    iscatch_str = '';
                end
                n_catch = n_catch + iscatch;
                
                fprintf('#trial=%3d   #block=%2d   #stim=%2d   content=%1s   iscatch=%1s   ',...
                    itrial,...
                    iblock,...
                    istim,...
                    content,...
                    iscatch_str ...
                    )
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = StartTime + next_evt_onset - slack;
                
                has_responded_stim = 0;
                has_responded      = 0;
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(KEY_ESCAPE);
                        if EXIT, break, end
                        
                        if keyCode(KEY_Catch)
                            has_responded_stim = 1;
                            break
                        end
                        
                    end
                    
                end % while
                
                if has_responded_stim
                    RT = secs - real_onset;
                    resp_ok = iscatch;
                    n_resp_ok = n_resp_ok + resp_ok;
                end
                
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
    
end % try

end % function
