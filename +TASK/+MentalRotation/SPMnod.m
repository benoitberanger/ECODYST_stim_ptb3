function [ names , onsets , durations, pmod, orth, tmod ] = SPMnod
global S

%SPMNOD Build 'names', 'onsets', 'durations' for SPM

EchoStart(mfilename)

try
    %% Preparation
    
    names = {
        'Rest'
        'Trial'
        'Click'
        };
    
    % 'onsets' & 'durations' for SPM
    onsets    = cell(size(names));
    durations = cell(size(names));
    
    % Shortcut
    EventData    = S.ER.BlockData;
    BehaviorData = S.BR.data2table;
    
    num = [];
    for n = 1 : length(names)
        num.(names{n}) = n;
    end
    
    
    %% Onsets building
    
    for event = 1:size(EventData,1)
        
        if strcmp(EventData{event,1}, 'StartTime') || strcmp(EventData{event,1}, 'StopTime')
            %pass
        else
            onsets{num.(EventData{event,1})} = [onsets{num.(EventData{event,1})} ; EventData{event,2}];
        end
        
    end
    
    
    %% Durations building
    
    
    for event = 1:size(EventData,1)
        
        if strcmp(EventData{event,1}, 'StartTime') || strcmp(EventData{event,1}, 'StopTime')
            %pass
        else
            durations{num.(EventData{event,1})} = [ durations{num.(EventData{event,1})} ; EventData{event+1,2}-EventData{event,2}] ;
        end
        
    end
    
    
    %% Add Clicks to SPM model input
    
    keys = KbName(struct2array(S.Keybinds.TaskSpecific));
    
    for f = 1:length(keys)
        click_spot.(keys{f}) = regexp(S.KL.KbEvents(:,1),keys{f});
        click_spot.(keys{f}) = ~cellfun(@isempty,click_spot.(keys{f}));
        click_spot.(keys{f}) = find(click_spot.(keys{f}));
    end
    click_onset    = [];
    click_duration = [];
    
    count = 0 ;
    for f = 1:length(keys)
        
        count = count + 1 ;
        
        if ~isempty(S.KL.KbEvents{click_spot.(keys{f}),2})
            click_idx = cell2mat(S.KL.KbEvents{click_spot.(keys{f}),2}(:,2)) == 1;
            click_idx = find(click_idx);
            % the last click can be be unfinished : button down + end of stim = no button up
            if isempty(S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),3})
                S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),3} =  S.ER.Data{end,2} - S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),1};
            end
            click_onset    = [ click_onset    ; cell2mat(S.KL.KbEvents{click_spot.(keys{f}),2}(click_idx,1)) ];
            click_duration = [ click_duration ; cell2mat(S.KL.KbEvents{click_spot.(keys{f}),2}(click_idx,3)) ];
        else
            % pass
        end
        
    end
    
    % reorder
    [click_onset,i] = sort(click_onset,'ascend');
    click_duration = click_duration(i);
    
    onsets   {num.Click} = click_onset;
    durations{num.Click} = click_duration;
    
    
    %% data correction
    
    BehaviorData.subj_resp_num = double(strcmp(BehaviorData.subj_resp,'mirror'));
    
    trial_to_correct = BehaviorData.RT_s_ < 0;
    BehaviorData.RT_s_        (trial_to_correct) = mean(BehaviorData.RT_s_        (~trial_to_correct));
    BehaviorData.subj_resp_num(trial_to_correct) = mean(BehaviorData.subj_resp_num(~trial_to_correct));
    BehaviorData.resp_ok      (trial_to_correct) = mean(BehaviorData.resp_ok      (~trial_to_correct));
    
    
    %% Parmetric modulation
    
    % time modulation : none
    tmod = num2cell(zeros(size(names)));
    
    % orthogonalization : none
    orth = num2cell(zeros(size(names)));
    
    pmod = struct('name',{''},'param',{},'poly',{});
    
    % condition = same vs mirror
    pmod(2).name {1} = 'condition__same0_mirror1';
    pmod(2).param{1} = strcmp(BehaviorData.condition,'mirror');
    pmod(2).param{1} = pmod(2).param{1} - mean(pmod(2).param{1});
    pmod(2).poly {1} = 1;
    
    % angle
    pmod(2).name {2} = 'angle';
    pmod(2).param{2} = BehaviorData.angle_deg_;
    pmod(2).param{2} = pmod(2).param{2} - mean(pmod(2).param{2});
    pmod(2).poly {2} = 1;
    
    % RT
    pmod(2).name {3} = 'RT';
    pmod(2).param{3} = BehaviorData.RT_s_;
    pmod(2).param{3} = pmod(2).param{3} - mean(pmod(2).param{3});
    pmod(2).poly {3} = 1;
    
    pmod(2).name {4} = 'subjresp__same0_mirror1';
    pmod(2).param{4} = BehaviorData.subj_resp_num;
    pmod(2).param{4} = pmod(2).param{4} - mean(pmod(2).param{4});
    pmod(2).poly {4} = 1;
    
    pmod(2).name {5} = 'respok';
    pmod(2).param{5} = double(BehaviorData.resp_ok);
    pmod(2).param{5} = pmod(2).param{5} - mean(pmod(2).param{5});
    pmod(2).poly {5} = 1;
    
    
catch err
    
    sca
    warning(err.message)
    
end

EchoStop(mfilename)

end % function
