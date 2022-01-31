function Runtime()
global S

try
    %% Tuning of the task
    
    [ EP, TaskParam ] = TASK.MentalRotation.Parameters( S.OperationMode );
    
    
    %% Prepare recorders
    
    PTB_ENGINE.PrepareRecorders( EP );
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS = TASK.MentalRotation.PREPARE.FixationCross();
    
    
    %% Shortcuts
    
    ER          = S.ER;
    wPtr        = S.PTB.Video.wPtr;
    slack       = S.PTB.Video.slack;
    ESCAPE      = S.Keybinds.Stop_Escape;
    if S.MovieMode, moviePtr = S.moviePtr; end
    
    
    %% GO
    
    EXIT = false;
    secs = GetSecs();
    
    % Loop over the EventPlanning
    nEvents = size( EP.Data , 1 );
    for evt = 1 : nEvents
        
        % Shortcuts
        evt_name      = EP.Data{evt,1};
        % evt_onset     = EP.Data{evt,2};
        evt_duration  = EP.Data{evt,3};
        block         = EP.Data{evt,4};
        trial         = EP.Data{evt,5};
        side          = EP.Data{evt,6};
        if (evt > 1) && (evt < nEvents)
            prev_duration = EP.Data{evt-1,3};
            switch side
                case 'Left'
                    side_num = -1;
                case 'Right'
                    side_num = +1;
            end
        end
        
        switch evt_name
            
            case 'StartTime' % --------------------------------------------
                
                % Draw
                FIXATIONCROSS.Draw();
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                Screen('Flip',wPtr);
                
                StartTime     = PTB_ENGINE.StartTimeEvent(); % a wrapper, deals with hidemouse, eyelink, mri sync, ...
                prev_onset    = StartTime;
                prev_duration = 0;
                
                
            case 'StopTime' % ---------------------------------------------
                
                StopTime = PTB_ENGINE.StopTimeEvent( StartTime, evt );
                
                
            case 'BlockRest' % --------------------------------------------
                
                % Draw
                FIXATIONCROSS.Draw();
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                
                % Flip at the right moment
                desired_onset =  prev_onset + prev_duration - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                prev_onset = real_onset;
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = prev_onset + evt_duration - slack;
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(ESCAPE);
                        if EXIT, break, end
                    end
                    
                    % Draw
                    FIXATIONCROSS.Draw();
                    if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                    
                    flip_onset = Screen('Flip', wPtr);
                    
                    
                end % while
                
            otherwise % ---------------------------------------------------
                
                error('unknown envent')
                
        end % switch
        
        % if ESCAPE is pressed
        if EXIT
            StopTime = secs;
            
            % Record StopTime
            ER.AddStopTime( 'StopTime', StopTime - StartTime );
            
            sca;
            Priority(0);
            ShowCursor;
            
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
    ShowCursor;
    
    rethrow(err);
    
    if exist('moviePtr','var') %#ok<UNRCH>
        PTB_ENGINE.VIDEO.MOVIE.Finalize(moviePtr);
    end
    
end % try

end % function
