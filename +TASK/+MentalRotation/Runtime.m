function Runtime()
global S GL

try
    %% Tuning of the task
    
    [ EP, p ] = TASK.MentalRotation.Parameters( S.OperationMode );
    
    
    %% Prepare recorders
    
    PTB_ENGINE.PrepareRecorders( S.EP );
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS = TASK.MentalRotation.PREPARE.FixationCross();
    TETRIS3D      = TASK.MentalRotation.PREPARE.Tetris3D     ();
    
    
    %% Shortcuts
    
    ER          = S.ER; % EventRecorder
    BR          = S.BR; % BehaviourRecorder (EventRecorder)
    wPtr        = S.PTB.Video.wPtr;
    wRect       = S.PTB.Video.wRect;
    slack       = S.PTB.Video.slack;
    ESCAPE      = S.Keybinds.Stop_Escape;
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
    
    glLightfv(GL.LIGHT0, GL.AMBIENT , [0.1 0.1 0.1  1.0]);
    glLightfv(GL.LIGHT0, GL.DIFFUSE , [1.0 1.0 1.0  1.0]);
    glLightfv(GL.LIGHT0, GL.SPECULAR, [1.0 1.0 1.0  1.0]);
    
    glLightfv(GL.LIGHT0,GL.POSITION,[ p.Tetris3D.LIGHT0_pos p.Tetris3D.LIGHT0_is_pt ]);
    
    
    % LIGHT1 --------------------------------------------------------------
    
    glEnable(GL.LIGHT1);
    
    glLightfv(GL.LIGHT1, GL.AMBIENT , [0.0 0.0 0.0  1.0]);
    glLightfv(GL.LIGHT1, GL.DIFFUSE , [0.2 0.2 0.2  1.0]);
    glLightfv(GL.LIGHT1, GL.SPECULAR, [0.0 0.0 0.0  1.0]);
    
    glLightfv(GL.LIGHT1, GL.POSITION, [ p.Tetris3D.LIGHT1_pos p.Tetris3D.LIGHT1_is_pt ]);
    
    
    % Finish OpenGL rendering into PTB window. This will switch back to the
    % standard 2D drawing functions of Screen and will check for OpenGL errors.
    Screen('EndOpenGL', wPtr);
    
    
    %% GO
    
    EXIT = false;
    secs = GetSecs();
    
    % Loop over the EventPlanning
    nEvents = size( EP.Data , 1 );
    for evt = 1 : nEvents
        
        % Shortcuts
        evt_name      = EP.Data{evt,columns.event_name};
        evt_onset     = EP.Data{evt,columns.onset_s_};
        evt_duration  = EP.Data{evt,columns.duration_s_};
        trial         = EP.Data{evt,columns.iTrial};
        angle         = EP.Data{evt,columns.angle___};
        condition     = EP.Data{evt,columns.condition};
        tetris        = EP.Data{evt,columns.tetris};
        
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
                
                
            case 'Rest' % -------------------------------------------------
                
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
                
                
            case 'Trial' % ------------------------------------------------
                
                % Draw
                %                 TETRIS3D.Render(tetris)
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                
                % Flip at the right moment
                desired_onset =  prev_onset + prev_duration - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                prev_onset = real_onset;
                
                fprintf('#trial=%2d   angle=%2d   condition=%6s   tetris=%s \n',...
                    trial,...
                    angle,...
                    condition,...
                    num2str(tetris, repmat('%+2d ', [1 length(tetris)])) ...
                    )
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = prev_onset + evt_duration - slack;
                
                % Initialize amount and direction of rotation
                theta=0;
                rotatev=[ 0 0 1 ];
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(ESCAPE);
                        if EXIT, break, end
                    end
                    
                    % Draw
                    % Calculate rotation angle for next frame:
                    theta=mod(theta+0.2,360);
                    rotatev=rotatev+0.1*[ sin((pi/180)*theta) sin((pi/180)*2*theta) sin((pi/180)*theta/5) ];
                    rotatev=rotatev/sqrt(sum(rotatev.^2));
                    
                    TETRIS3D.Render(tetris, theta, rotatev)
                    TETRIS3D.Capture('R')
                    TETRIS3D.Render(tetris, theta, rotatev)
                    TETRIS3D.Capture('L')
                    glClear();
                    
                    Screen('DrawTexture', wPtr, TETRIS3D.texture_L, [], CenterRectOnPoint(TETRIS3D.img_L_rect, wRect(3)*1/4, wRect(4)/2))
                    Screen('DrawTexture', wPtr, TETRIS3D.texture_R, [], CenterRectOnPoint(TETRIS3D.img_R_rect, wRect(3)*3/4, wRect(4)/2))
                    Screen('Close', TETRIS3D.texture_L);
                    Screen('Close', TETRIS3D.texture_R);
                    
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
            
            fprintf('ESCAPE key pressed \n');
            break
        end
        
    end % for
    
    
    %% End of task execution stuff
    
    TETRIS3D.deleteTextures();
    
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
