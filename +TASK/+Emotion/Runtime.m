function Runtime()
global S

% nested function (cannot be in the try/catch part)
    function printlog()
        fprintf('block#=%1d  -  block_name=%29s  -  condition=%6s  -  part=%8s  -  type=%11s  -  content=%s \n', iblock, evt_name, condition, part, type ,content)
    end

try
    %% Tuning of the task
    
    TASK.Keybindings();
    [ EP, p ] = TASK.Emotion.Parameters( S.OperationMode );
    
    
    %% Prepare recorders
    
    PTB_ENGINE.PrepareRecorders( S.EP );
    S.BR = EventRecorder({'block#' 'block_name' 'condition' 'part' 'type' 'content' 'RT(s)' 'value'}, 4*2);
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS = TASK.        PREPARE.FixationCross();
    TEXT          = TASK.Emotion.PREPARE.Text         ();
    AUDIOFILE     = TASK.Emotion.PREPARE.AudioFile    ();
    LIKERT        = TASK.Emotion.PREPARE.Likert       ();
    
    
    %% Shortcuts
    
    ER           = S.ER; % EventRecorder
    BR           = S.BR; % BehaviourRecorder (EventRecorder)
    wPtr         = S.PTB.Video.wPtr;
    wRect        = S.PTB.Video.wRect;
    slack        = S.PTB.Video.slack;
    KEY_ESCAPE   = S.Keybinds.Common.Stop_Escape;
    KEY_LEFT     = S.Keybinds.TaskSpecific.Left;
    KEY_RIGHT    = S.Keybinds.TaskSpecific.Right;
    KEY_VALIDATE = S.Keybinds.TaskSpecific.Validate;
    
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
    
    % Loop over the EventPlanning
    nEvents = size( EP.Data , 1 );
    for evt = 1 : nEvents
        
        % Shortcuts
        evt_name     = EP.Data{evt,columns.event_name};
        evt_onset    = EP.Data{evt,columns.onset_s_};
        evt_duration = EP.Data{evt,columns.duration_s_};
        iblock       = EP.Data{evt,columns.x_block};
        condition    = EP.Data{evt,columns.condition};
        part         = EP.Data{evt,columns.part};
        type         = EP.Data{evt,columns.type};
        content      = EP.Data{evt,columns.content};
        
        if evt < nEvents
            next_evt_onset = EP.Data{evt+1,columns.onset_s_};
        end
        
        if strcmp(evt_name, 'StartTime') % --------------------------------
            
            % Draw
            FIXATIONCROSS.Draw();
            Screen('DrawingFinished', wPtr);
            Screen('Flip',wPtr);
            
            StartTime = PTB_ENGINE.StartTimeEvent(); % a wrapper, deals with hidemouse, eyelink, mri sync, ...
            
            
        elseif strcmp(evt_name, 'StopTime') % -----------------------------
            
            StopTime = WaitSecs('UntilTime', StartTime + S.ER.Data{S.ER.EventCount,2} + S.EP.Data{evt-1,3} );
            
            % Record StopTime
            S.ER.AddStopTime( 'StopTime' , StopTime - StartTime );
            
            
        elseif strcmp(type, 'instruction') % ------------------------------
            
            % Draw
            FIXATIONCROSS.Draw();
            Screen('DrawingFinished', wPtr);
            
            % Playback at the right moment
            idx = find(contains({AUDIOFILE.filename},content));
            desired_onset =  StartTime + evt_onset - S.PTB.Audio.Playback.anticipation;
            real_onset = AUDIOFILE(idx).Playback(desired_onset);
            Screen('Flip', wPtr, desired_onset);
            
            % Save onset
            ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
            
            if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
            
            printlog()
            
            % While loop for most of the duration of the event, so we can press ESCAPE
            next_onset = StartTime + next_evt_onset - slack;
            while secs < next_onset
                
                [keyIsDown, secs, keyCode] = KbCheck();
                if keyIsDown
                    EXIT = keyCode(KEY_ESCAPE);
                    if EXIT, break, end
                end
                
            end % while
            
            
        elseif strcmp(type, 'rest') % -------------------------------------
            
            % Draw
            FIXATIONCROSS.Draw();
            Screen('DrawingFinished', wPtr);
            
            % Flip at the right moment
            desired_onset =  StartTime + evt_onset - slack;
            real_onset = Screen('Flip', wPtr, desired_onset);
            
            % Save onset
            ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
            
            if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
            
            printlog()
            
            % While loop for most of the duration of the event, so we can press ESCAPE
            next_onset = StartTime + next_evt_onset - slack;
            while secs < next_onset
                
                [keyIsDown, secs, keyCode] = KbCheck();
                if keyIsDown
                    EXIT = keyCode(KEY_ESCAPE);
                    if EXIT, break, end
                end
                
            end % while
            
         elseif strcmp(type, 'postscript') % ------------------------------
            
            % Draw
            % black screen
            Screen('DrawingFinished', wPtr);
            
            % Flip at the right moment
            desired_onset =  StartTime + evt_onset - slack;
            real_onset = Screen('Flip', wPtr, desired_onset);
            
            % Save onset
            ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
            
            if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
            
            printlog()
            
            % While loop for most of the duration of the event, so we can press ESCAPE
            next_onset = StartTime + next_evt_onset - slack;
            while secs < next_onset
                
                [keyIsDown, secs, keyCode] = KbCheck();
                if keyIsDown
                    EXIT = keyCode(KEY_ESCAPE);
                    if EXIT, break, end
                end
                
            end % while
            
        elseif strcmp(type, 'playback') % -------------------------------------
            
            % Draw
            % black screen
            Screen('DrawingFinished', wPtr);
            
            % Playback at the right moment
            idx = find(contains({AUDIOFILE.filename},content));
            desired_onset =  StartTime + evt_onset - S.PTB.Audio.Playback.anticipation;
            real_onset = AUDIOFILE(idx).Playback(desired_onset);
            Screen('Flip', wPtr);
            
            % Save onset
            ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
            
            if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
            
            printlog()
            
            % While loop for most of the duration of the event, so we can press ESCAPE
            next_onset = StartTime + next_evt_onset - slack;
            while secs < next_onset
                
                [keyIsDown, secs, keyCode] = KbCheck();
                if keyIsDown
                    EXIT = keyCode(KEY_ESCAPE);
                    if EXIT, break, end
                end
                
            end % while
            
        elseif strcmp(part, 'lickert') % ----------------------------------
            
            % Draw
            LIKERT.MoveMiddle();
            LIKERT.Draw(content);
            Screen('DrawingFinished', wPtr);
            
            % Flip at the right moment
            desired_onset =  StartTime + evt_onset - slack;
            real_onset = Screen('Flip', wPtr, desired_onset);
            
            % Save onset
            ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
            
            if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
            
            printlog()
            
            % While loop for most of the duration of the event, so we can press ESCAPE
            next_onset = StartTime + next_evt_onset - slack;
            has_responded = false;
            while secs < next_onset
                
                [keyIsDown, secs, keyCode] = KbCheck();
                if keyIsDown
                    EXIT = keyCode(KEY_ESCAPE);
                    if EXIT, break, end
                    
                    if ~has_responded
                        
                        if keyCode(KEY_VALIDATE)
                            LIKERT.cursor_color = LIKERT.cursor_color_valid;
                            LIKERT.Draw();
                            Screen('DrawingFinished', wPtr);
                            Screen('Flip', wPtr);
                            has_responded = true;
                            
                            RT = secs-real_onset;
                            fprintf('RT=%5dms   -   value=%d\n', round(RT*1000), LIKERT.cursor_pos)
                        end
                        
                        if keyCode(KEY_LEFT)
                            LIKERT.MoveLeft();
                            LIKERT.Draw(content);
                            Screen('DrawingFinished', wPtr);
                            Screen('Flip', wPtr);
                            WaitSecs(0.200);
                        end
                        
                        if keyCode(KEY_RIGHT)
                            LIKERT.MoveRight();
                            LIKERT.Draw(content);
                            Screen('DrawingFinished', wPtr);
                            Screen('Flip', wPtr);
                            WaitSecs(0.200);
                        end
                        
                    end
                    
                end
                
            end % while
            
            if ~has_responded
                RT = -1;
                fprintf('RT=           -   value=%d\n', LIKERT.cursor_pos)
            end
            BR.AddEvent({iblock evt_name condition part type content RT LIKERT.cursor_pos})
            
            
        else % ------------------------------------------------------------
            
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
