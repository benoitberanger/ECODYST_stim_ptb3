function [ ParPortMessages ] = Prepare()
global S

%% On ? Off ?

switch S.ParPort
    
    case 'On'
        
        % Open parallel port
        OpenParPort;
        
        % Set pp to 0
        WriteParPort(0)
        
    case 'Off'
        
end

%% Prepare messages

% fill here...
msg.Event01 = 1;
msg.Event02 = 2;
msg.Event03 = 3;


%% Finalize

% Pulse duration
msg.duration    = 0.003; % seconds

ParPortMessages = msg; % shortcut


end % function
