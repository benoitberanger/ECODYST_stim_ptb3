function FinilizeRecorders()
global S

% EventRecorder => real onset & duration of events
S.ER.ClearEmptyEvents();
S.ER.ComputeDurations();
S.ER.BuildGraph();
S.ER.MakeBlocks();
S.ER.BuildGraph('block');

S.BR.ClearEmptyEvents();

% KeyLogger => passive recording of key inputs (including MRI triggers)
S.KL.GetQueue();
S.KL.Stop();
switch S.OperationMode
    case 'Acquisition'
    case 'FastDebug'
        nbVolumes = ceil( S.EP.Data{end,2} / TR ) ; % nb of volumes for the estimated time of stimulation
        S.KL.GenerateMRITrigger( TR , nbVolumes + 2 , S.StartTime );
    case 'RealisticDebug'
        nbVolumes = ceil( S.EP.Data{end,2} / TR ); % nb of volumes for the estimated time of stimulation
        S.KL.GenerateMRITrigger( TR , nbVolumes + 2, S.StartTime );
    otherwise
end
S.KL.ScaleTime(S.StartTime);
S.KL.ComputeDurations();
S.KL.BuildGraph();

assignin('base','EP',S.EP)
assignin('base','ER',S.ER)
assignin('base','BR',S.BR) % <--- dont forget this one
assignin('base','KL',S.KL)


end % function
