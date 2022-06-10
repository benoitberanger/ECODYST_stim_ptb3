function Runtime()
global S

try
    %% Tuning of the task
    
    TASK.Keybindings();
    [ EP, p ] = TASK.SocialCognition.Parameters( S.OperationMode );
    
    
    %% Prepare recorders
    
    PTB_ENGINE.PrepareRecorders( S.EP );
    S.BR = EventRecorder({'block#' 'block_name' 'trial#' 'content' 'target(L/R)' 'RT(s)' 'side(L/R)' 'ok'}, S.TaskParam.nTrials);
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS = TASK.                PREPARE.FixationCross();
    TEXT          = TASK.SocialCognition.PREPARE.Text         ();
    IMAGE         = TASK.SocialCognition.PREPARE.Image        ();
    
    
    %% Shortcuts
    
    ER          = S.ER; % EventRecorder
    BR          = S.BR; % BehaviourRecorder (EventRecorder)
    wPtr        = S.PTB.Video.wPtr;
    wRect       = S.PTB.Video.wRect;
    slack       = S.PTB.Video.slack;
    KEY_ESCAPE  = S.Keybinds.Common.Stop_Escape;
    KEY_Right   = S.Keybinds.TaskSpecific.Right;
    KEY_Left    = S.Keybinds.TaskSpecific.Left;
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
    
    % Loop over the EventPlanning
    nEvents = size( EP.Data , 1 );
    for evt = 1 : nEvents
        
        % Shortcuts
        evt_name     = EP.Data{evt,columns.event_name};
        evt_onset    = EP.Data{evt,columns.onset_s_};
        evt_duration = EP.Data{evt,columns.duration_s_};
        content      = EP.Data{evt,columns.content};
        iblock       = EP.Data{evt,columns.x_block};
        block_name   = EP.Data{evt,columns.block_name};
        itrial       = EP.Data{evt,columns.x_trial};
        target_LR    = EP.Data{evt,columns.target_L_R_};
        
        if evt < nEvents
            next_evt_onset = EP.Data{evt+1,columns.onset_s_};
        end
        
        switch evt_name
            
            case 'StartTime' % --------------------------------------------
                
                % Draw
                FIXATIONCROSS.Draw();
                Screen('DrawingFinished', wPtr);
                Screen('Flip',wPtr);
                
                StartTime = PTB_ENGINE.StartTimeEvent(); % a wrapper, deals with hidemouse, eyelink, mri sync, ...
                
                
            case 'StopTime' % ---------------------------------------------
                
                StopTime = WaitSecs('UntilTime', StartTime + S.ER.Data{S.ER.EventCount,2} + S.EP.Data{evt-1,3} );
                
                % Record StopTime
                S.ER.AddStopTime( 'StopTime' , StopTime - StartTime );
                
                
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
                
                fprintf('block#=%4d // block_name=%10s // Instructions = %s \n', iblock, block_name, content)
                
                IMG_prepareInstruction = PrepareTrial(IMAGE,itrial);
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = StartTime + next_evt_onset - slack;
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(KEY_ESCAPE);
                        if EXIT, break, end
                    end
                    
                end % while
                
                
            case 'Presentation' % -----------------------------------------
                
                % Draw
                if strcmp(EP.Data{evt-1,columns.event_name}, 'Instruction')
                    IMG_trial = IMG_prepareInstruction;
                    desired_onset =  StartTime + evt_onset - slack;
                else
                    IMG_trial = IMG_preparePresentation;
                    desired_onset =  0; % now
                end
                IMG_trial.Draw();
                Screen('FillRect',wPtr,[0 0 0 255],[0 wRect(4)/2 wRect(3) wRect(4)]); % mask the lower part of the image
                Screen('DrawingFinished', wPtr);
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameBackBuffer(wPtr,moviePtr); end
                
                % Flip at the right moment
                real_onset = Screen('Flip', wPtr, desired_onset);
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
                
                fprintf('block#=%1d  block_name=%10s  trial#=%2d  content=%17s  target(L/R)=%1s   ',...
                    iblock,...
                    block_name,...
                    itrial,...
                    content,...
                    target_LR...
                    )
                
                if itrial < p.nTrials
                    IMG_preparePresentation = PrepareTrial(IMAGE,itrial+1);
                end
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = StartTime + next_evt_onset - slack;
                
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(KEY_ESCAPE);
                        if EXIT, break, end
                    end
                    
                end % while
                
            case 'Answer' % -------------------------------------------
                
                % Draw
                IMG_trial.Draw();
                IMG_trial.CloseTexture();
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
                
                
                has_responded = false;
                while (secs < next_onset)
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(KEY_ESCAPE);
                        if EXIT, break, end
                        
                        if keyCode(KEY_Right)
                            side = 'R';
                            has_responded = true;
                            break;
                        elseif keyCode(KEY_Left)
                            side = 'L';
                            has_responded = true;
                            break;
                        end
                        
                    end
                    
                end % while
                
                if has_responded
                    RT = secs - real_onset;
                    ok = target_LR == side;
                    n_resp_ok = n_resp_ok + ok;
                else
                    RT = -inf;
                    side = '';
                    ok = [];
                end
                
                fprintf('RT(ms)=%4d  side(L/R)=%1s  ok=%1d  n_resp_ok=%2d (%3d%%) \n',...
                    round(RT*1000),...
                    side,...
                    ok,...
                    n_resp_ok,...
                    round(100*n_resp_ok/itrial)...
                    )
                
                S.BR.AddEvent({iblock, block_name, itrial content, target_LR, RT, side, ok})
                
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

function IMG = PrepareTrial(IMAGE,trial)

IMAGE(trial).Load();
IMAGE(trial).MakeTexture();
IMAGE(trial).Maximize();

IMG = IMAGE(trial);

end % function
