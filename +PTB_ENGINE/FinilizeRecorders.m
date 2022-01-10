function FinilizeRecorders()
global S

% EventRecorder => real onset & duration of events
S.ER.ClearEmptyEvents();
S.ER.ComputeDurations();
S.ER.BuildGraph();
S.ER.MakeBlocks();
S.ER.BuildGraph('block');

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
S.KL.ScaleTime();
S.KL.ComputeDurations();
S.KL.BuildGraph();

% SampleRecorder => records the nutcrackers(joystick) or mouse
S.SR.ClearEmptySamples();

assignin('base','EP',S.EP)
assignin('base','ER',S.ER)
assignin('base','KL',S.KL)
assignin('base','SR',S.SR)

assignin('base','RT_produce',S.RT_produce)
assignin('base','RT_rest'   ,S.RT_rest   )
assignin('base','Stability' ,S.Stability )

end % function
