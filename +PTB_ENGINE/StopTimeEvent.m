function [ StopTime ] = StopTimeEvent( StartTime, evt )
global S

% Last event duration handeling
% StopTime = WaitSecs('UntilTime', StartTime + S.ER.Data{S.ER.EventCount,2} + S.EP.Data{evt-1,3} );
StopTime = GetSecs;

% Record StopTime
S.ER.AddStopTime( 'StopTime' , StopTime - StartTime );

end % function
