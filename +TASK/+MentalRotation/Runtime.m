function Runtime()
global S GL

try
    %% Tuning of the task
    
    TASK.Keybindings();
    [ EP, p ] = TASK.MentalRotation.Parameters( S.OperationMode );
    
    
    %% Prepare recorders
    
    PTB_ENGINE.PrepareRecorders( S.EP );
    S.BR = EventRecorder({'trial#' 'condition' 'angle(deg)' 'tetris[4]' 'RT(s)' 'subj_resp' 'resp_ok'}, S.TaskParam.nTrials);
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS = TASK.               PREPARE.FixationCross();
    TETRIS3D      = TASK.MentalRotation.PREPARE.Tetris3D     ();
    
    
    %% Shortcuts
    
    ER          = S.ER; % EventRecorder
    BR          = S.BR; % BehaviourRecorder (EventRecorder)
    wPtr        = S.PTB.Video.wPtr;
    wRect       = S.PTB.Video.wRect;
    slack       = S.PTB.Video.slack;
    KEY_ESCAPE  = S.Keybinds.Common.Stop_Escape;
    KEY_Same    = S.Keybinds.TaskSpecific.Same;
    KEY_Mirror  = S.Keybinds.TaskSpecific.Mirror;
    if S.MovieMode, moviePtr = S.moviePtr; end
    
    
    %% Planning columns
    
    columns = struct;
    for c = 1 : EP.Columns
        col_name = matlab.lang.makeValidName( EP.Header{c} );
        columns.(col_name) = c;
    end
    
    
    %% Initialize OpengL
    
    % Setup the OpenGL rendering context of the onscreen window for use by
    % OpenGL wrapper. After this command, all following OpenGL commands will
    % draw into the onscreen window 'win':
    Screen('BeginOpenGL', wPtr);
    
    % Setup default drawing color to yellow (R,G,B)=(1,1,0). This color only
    % gets used when lighting is disabled - if you comment out the call to
    % glEnable(GL.LIGHTING).
    glColor3f(1,0,1); % cyan == error !
    
    % Turn on OpenGL local lighting model: The lighting model supported by
    % OpenGL is a local Phong model with Gouraud shading. The color values
    % at the vertices (corners) of polygons are computed with the Phong lighting
    % model and linearly interpolated accross the inner area of the polygon from
    % the vertex colors. The Phong lighting model is a coarse approximation of
    % real world lighting with ambient light reflection (undirected isotropic light),
    % diffuse light reflection (position wrt. light source matters, but observer
    % position doesn't) and specular reflection (ideal mirror reflection for highlights).
    %
    % The model does not take any object relationships into account: Any effects
    % of (self-)occlusion, (self-)shadowing or interreflection of light between
    % objects are ignored. If you need shadows, interreflections and global illumination
    % you will either have to learn advanced OpenGL rendering and shading techniques
    % to implement your own realtime shadowing and lighting models, or
    % compute parts of the scene offline in some gfx-package like Maya, Blender,
    % Radiance or 3D Studio Max...
    %
    % If you want to do any shape from shading studies, it is very important to
    % understand the difference between a local lighting model and a global
    % illumination model!!!
    glEnable(GL.LIGHTING);
    
    % Enable proper occlusion handling via depth tests:
    glEnable(GL.DEPTH_TEST);
    
    % Use alpha-blending:
    glEnable(GL.BLEND);
    glBlendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
    
    % Enable two-sided lighting - Back sides of polygons are lit as well.
    glLightModelfv(GL.LIGHT_MODEL_TWO_SIDE,GL.TRUE);
    
    % Make sure that surface normals are always normalized to unit-length,
    % regardless what happens to them during morphing. This is important for
    % correct lighting calculations:
    glEnable(GL.NORMALIZE);
    
    % Set background clear color (RGBa)
    glClearColor(...
        S.PTB.Video.ScreenBGColor(1)/255, ...
        S.PTB.Video.ScreenBGColor(2)/255, ...
        S.PTB.Video.ScreenBGColor(3)/255, ...
        1                                 ...
        );
    
    % Set projection matrix: This defines a perspective projection,
    % corresponding to the model of a pin-hole camera - which is a good
    % approximation of the human eye and of standard real world cameras --
    % well, the best aproximation one can do with 3 lines of code ;-)
    glMatrixMode(GL.PROJECTION);
    glLoadIdentity;
    
    % Get the aspect ratio of the screen:
    AspectRatio = wRect(4)/wRect(3);
    
    % Field of view is 25 degrees from line of sight. Objects closer than
    % 0.01 distance units or farther away than 100 distance units get
    % clipped away, aspect ratio is adapted to the monitors aspect ratio:
    gluPerspective(           ....
        p.Tetris3D.FieldOfView,...
        1/AspectRatio         ,...
        0.01,100               ...
        );
    
    
    
    % Enable the first local light source GL.LIGHT_0. Each OpenGL
    % implementation is guaranteed to support at least 8 light sources,
    % GL.LIGHT0, ..., GL.LIGHT7
    
    % LIGHT0 --------------------------------------------------------------
    
    glEnable(GL.LIGHT0);
    
    glLightfv(GL.LIGHT0, GL.AMBIENT , p.Tetris3D.LIGHT0.AMBIANT);
    glLightfv(GL.LIGHT0, GL.DIFFUSE , p.Tetris3D.LIGHT0.DIFFUSE);
    glLightfv(GL.LIGHT0, GL.SPECULAR, p.Tetris3D.LIGHT0.SPECULAR);
    
    glLightfv(GL.LIGHT0,GL.POSITION,[ p.Tetris3D.LIGHT0.pos p.Tetris3D.LIGHT0.is_pt ]);
    
    
    % LIGHT1 --------------------------------------------------------------
    
    glEnable(GL.LIGHT1);
    
    glLightfv(GL.LIGHT1, GL.AMBIENT , p.Tetris3D.LIGHT1.AMBIANT);
    glLightfv(GL.LIGHT1, GL.DIFFUSE , p.Tetris3D.LIGHT1.DIFFUSE);
    glLightfv(GL.LIGHT1, GL.SPECULAR, p.Tetris3D.LIGHT1.SPECULAR);
    
    glLightfv(GL.LIGHT1, GL.POSITION, [ p.Tetris3D.LIGHT1.pos p.Tetris3D.LIGHT1.is_pt ]);
    
    
    % Finish OpenGL rendering into PTB window. This will switch back to the
    % standard 2D drawing functions of Screen and will check for OpenGL errors.
    Screen('EndOpenGL', wPtr);
    
    
    % The rest of OpenGL stuff will be done in the Tetris3D object as a method
    
    
    %% GO
    
    EXIT = false;
    secs = GetSecs();
    n_resp_ok = 0;
    
    % Loop over the EventPlanning
    nEvents = size( EP.Data , 1 );
    for evt = 1 : nEvents
        
        % Shortcuts
        evt_name      = EP.Data{evt,columns.event_name};
        evt_onset     = EP.Data{evt,columns.onset_s_};
        evt_duration  = EP.Data{evt,columns.duration_s_};
        trial         = EP.Data{evt,columns.iTrial};
        angle         = EP.Data{evt,columns.angle_deg_};
        condition     = EP.Data{evt,columns.condition};
        tetris        = EP.Data{evt,columns.tetris};
        if evt > 1
            prev_duration = EP.Data{evt-1,columns.duration_s_};
        end
        
        
        switch evt_name
            
            case 'StartTime' % --------------------------------------------
                
                % Draw
                FIXATIONCROSS.Draw();
                Screen('DrawingFinished', wPtr);
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameBackBuffer(wPtr,moviePtr); end
                Screen('Flip',wPtr);
                
                StartTime     = PTB_ENGINE.StartTimeEvent(); % a wrapper, deals with hidemouse, eyelink, mri sync, ...
                prev_onset    = StartTime;
                
                
            case 'StopTime' % ---------------------------------------------
                
                StopTime = WaitSecs('UntilTime', StartTime + S.ER.Data{S.ER.EventCount,2} + S.EP.Data{evt-1,3} );
                
                % Record StopTime
                S.ER.AddStopTime( 'StopTime' , StopTime - StartTime );
                
                
            case 'Rest' % -------------------------------------------------
                
                % Draw
                FIXATIONCROSS.Draw();
                Screen('DrawingFinished', wPtr);
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameBackBuffer(wPtr,moviePtr,round(evt_duration/S.PTB.Video.IFI)); end
                
                % Flip at the right moment
                real_onset = Screen('Flip', wPtr);
                prev_onset = real_onset;
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = prev_onset + evt_duration - slack - p.durMaxRenderTime;
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(KEY_ESCAPE);
                        if EXIT, break, end
                    end
                    
                end % while
                
                
            case 'Trial' % ------------------------------------------------
                
                % Perspective hack : render L at center of screen, save
                % image, render R at center of screen, save image, re-draw
                % both on Left and Right side of the screen
                
                switch condition
                    case 'same'
                        is_mirror = 0;
                    case 'mirror'
                        is_mirror = 1;
                    otherwise
                        error('???')
                end
                
                % LEFT
                TETRIS3D.Render (tetris,     0,         0)
                TETRIS3D.Capture('L')
                
                % RIGHT
                TETRIS3D.Render (tetris, angle, is_mirror)
                TETRIS3D.Capture('R')
                
                glClear();
                FIXATIONCROSS.Draw();
                Screen('DrawTexture', wPtr, TETRIS3D.texture_L, [], CenterRectOnPoint(TETRIS3D.img_L_rect, wRect(3)*1/4, wRect(4)/2))
                Screen('DrawTexture', wPtr, TETRIS3D.texture_R, [], CenterRectOnPoint(TETRIS3D.img_R_rect, wRect(3)*3/4, wRect(4)/2))
                Screen('Close', TETRIS3D.texture_L);
                Screen('Close', TETRIS3D.texture_R);
                
                Screen('DrawingFinished', wPtr);
                
                % Flip at the right moment
                desired_onset =  prev_onset + prev_duration - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                prev_onset = real_onset;
                
                fprintf('#trial=%2d   angle=%3d   condition=%6s   tetris=%s   ',...
                    trial,...
                    angle,...
                    condition,...
                    num2str(tetris, repmat('%+2d ', [1 length(tetris)])) ...
                    )
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = prev_onset + evt_duration - slack;
                
                has_responded = 0;
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(KEY_ESCAPE);
                        if EXIT, break, end
                        
                        if keyCode(KEY_Same)
                            subj_resp = 'same';
                            has_responded = 1;
                        end
                        if keyCode(KEY_Mirror)
                            subj_resp = 'mirror';
                            has_responded = 1;
                        end
                        
                        if has_responded
                            RT = secs - real_onset;
                            resp_ok = strcmp(subj_resp, condition);
                            n_resp_ok = n_resp_ok + resp_ok;
                            BR.AddEvent({trial condition angle tetris RT subj_resp resp_ok})
                            
                            fprintf('RT=%5.fms   subj_resp=%6s   resp_ok=%2d (%3d%%)\n',...
                                round(RT * 1000),...
                                subj_resp,...
                                resp_ok,...
                                round(100*n_resp_ok / trial) ...
                                )
                            
                            break
                        end
                        
                    end
                    
                end % while
                
                if ~has_responded
                    BR.AddEvent({trial condition angle tetris -1 '' -1})
                    fprintf('RT=%5.fms   subj_resp=%6s   resp_ok=%2d (%3d%%)\n',...
                        -1,...
                        0,...
                        -1,...
                        round(100*n_resp_ok / trial) ...
                        )
                    if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr,round(evt_duration/S.PTB.Video.IFI)); end
                else
                    if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr,round(          RT/S.PTB.Video.IFI)); end
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
    
    if ~EXIT, TETRIS3D.deleteTextures(); end
    
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
