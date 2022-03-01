function [ StopTime ] = StopTimeEvent( StartTime, evt )
global S

% Last event duration handeling
switch S.Task
    
    case 'MentalRotation'
        StopTime = GetSecs;
        
    case 'NBack'
        StopTime = WaitSecs('UntilTime', StartTime + S.ER.Data{S.ER.EventCount,2} + S.EP.Data{evt-1,3} );
        
end

% Record StopTime
S.ER.AddStopTime( 'StopTime' , StopTime - StartTime );

end % function
