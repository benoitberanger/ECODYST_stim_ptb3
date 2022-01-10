function OpenWindow()
global S


%% Echo in command window
EchoStop(mfilename)


%% Open

% Use GStreamer : for videos
if S.PTB.Video.GStreamer
    Screen('Preference', 'OverrideMultimediaEngine', 1);
end

% PTB opening screen will be empty = black screen
Screen('Preference', 'VisualDebugLevel', 1);

% Open PTB display window
switch S.WindowedMode
    case 0
        WindowRect = [];
    case 1
        factor = 0.5;
        [ScreenWidth, ScreenHeight]=Screen('WindowSize', S.ScreenID);
        SmallWindow = ScaleRect( [0 0 ScreenWidth ScreenHeight] , factor , factor );
        WindowRect = CenterRectOnPoint( SmallWindow , ScreenWidth/2 , ScreenHeight/2 );
end

try
    [S.PTB.Video.wPtr,S.PTB.Video.wRect] = Screen('OpenWindow',S.ScreenID,S.PTB.Video.ScreenBGColor,WindowRect,[],[],[],S.PTB.Video.AntiAliazing);
catch err
    disp(err)
    Screen('Preference', 'SkipSyncTests', 1)
    [S.PTB.Video.wPtr,S.PTB.Video.wRect] = Screen('OpenWindow',S.ScreenID,S.PTB.Video.ScreenBGColor,WindowRect,[],[],[],S.PTB.Video.AntiAliazing);
end


%% Set parameters

% Refresh time of the monitor
S.PTB.Video.slack = Screen('GetFlipInterval', S.PTB.Video.wPtr)/2;
S.PTB.Video.IFI   = Screen('GetFlipInterval', S.PTB.Video.wPtr)  ;
S.PTB.Video.FPS   = Screen('FrameRate'      , S.PTB.Video.wPtr)  ;

% Set up alpha-blending for smooth (anti-aliased) lines and alpha-blending
% (transparent background textures)
Screen('BlendFunction', S.PTB.Video.wPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Center, Width, Hight
[ S.PTB.Video.X_center_px , S.PTB.Video.Y_center_px ] = RectCenter( S.PTB.Video.wRect );
S.PTB.Video.X_total_px = S.PTB.Video.wRect(3);
S.PTB.Video.Y_total_px = S.PTB.Video.wRect(4);

% B&W colors
S.PTB.Video.BlackIndex = BlackIndex( S.PTB.Video.wPtr );
S.PTB.Video.BlackIndex = WhiteIndex( S.PTB.Video.wPtr );

% Text
S.PTB.Video.Text.Size = round(S.PTB.Video.Text.SizeRatio * S.PTB.Video.Y_total_px);
Screen('TextSize' , S.PTB.Video.wPtr, S.PTB.Video.Text.Size );
Screen('TextFont' , S.PTB.Video.wPtr, S.PTB.Video.Text.Font );
Screen('TextColor', S.PTB.Video.wPtr, S.PTB.Video.Text.Color);
Screen('Preference', 'TextRenderer', 1); % ? dont remeber why...


%% Priority

% Set max priority
S.PTB.Video.oldLevel         = Priority   (                              );
S.PTB.Video.maxPriorityLevel = MaxPriority( S.PTB.Video.wPtr             );
S.PTB.Video.newLevel         = Priority   ( S.PTB.Video.maxPriorityLevel );


%% Warm up

Screen('Flip',S.PTB.Video.wPtr);
WaitSecs(0.100);


%% Record video ?

if S.MovieMode
    PTB_ENGINE.VIDEO.MOVIE.Create();
end


%% Echo in command window

EchoStop(mfilename)


end % function
