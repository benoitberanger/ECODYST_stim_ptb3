function [ names, onsets, durations, pmod, orth, tmod ] = SPMnod_parametric()
global S

%SPMNOD Build 'names', 'onsets', 'durations' for SPM

EchoStart(mfilename)

try
    %% Preparation
    
    names = {
        'Rest'
        'Trial'
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
    
    % Delete trial when subject did not respond
    %     trial_to_delete = BehaviorData.RT_s_ < 0;
    trial_OutOfTime = BehaviorData.RT_s_ < 0;
    
    
    %% Onsets building
    
    trial_count = 0;
    for event = 1:size(EventData,1)
        
        if strcmp(EventData{event,1}, 'StartTime') || strcmp(EventData{event,1}, 'StopTime')
            %pass
        elseif strcmp(EventData{event,1}, 'Trial')
            trial_count = trial_count + 1;
            %             if trial_to_delete(trial_count)
            %                 % pass
            %             else
            onsets{num.(EventData{event,1})} = [onsets{num.(EventData{event,1})} ; EventData{event,2}];
            %             end
        else
            onsets{num.(EventData{event,1})} = [onsets{num.(EventData{event,1})} ; EventData{event,2}];
        end
        
    end
    
    
    %% Durations building
    
    trial_count = 0;
    for event = 1:size(EventData,1)
        
        if strcmp(EventData{event,1}, 'StartTime') || strcmp(EventData{event,1}, 'StopTime')
            %pass
        elseif strcmp(EventData{event,1}, 'Trial')
            trial_count = trial_count + 1;
            %             if trial_to_delete(trial_count)
            %                 % pass
            %             else
            durations{num.(EventData{event,1})} = [ durations{num.(EventData{event,1})} ; EventData{event+1,2}-EventData{event,2}] ;
            %             end
        else
            durations{num.(EventData{event,1})} = [ durations{num.(EventData{event,1})} ; EventData{event+1,2}-EventData{event,2}] ;
        end
        
    end
    
    
    %% Add Clicks to SPM model input
    
    %     keys = KbName(struct2array(S.Keybinds.TaskSpecific));
    %
    %     for f = 1:length(keys)
    %         click_spot.(keys{f}) = regexp(S.KL.KbEvents(:,1),keys{f});
    %         click_spot.(keys{f}) = ~cellfun(@isempty,click_spot.(keys{f}));
    %         click_spot.(keys{f}) = find(click_spot.(keys{f}));
    %     end
    %     click_onset    = [];
    %     click_duration = [];
    %
    %     count = 0 ;
    %     for f = 1:length(keys)
    %
    %         count = count + 1 ;
    %
    %         if ~isempty(S.KL.KbEvents{click_spot.(keys{f}),2})
    %             click_idx = cell2mat(S.KL.KbEvents{click_spot.(keys{f}),2}(:,2)) == 1;
    %             click_idx = find(click_idx);
    %             % if only 1 keypres and never released (wtf ?), need to deal with this unprobable case
    %             if size(S.KL.KbEvents{click_spot.(keys{f}),2}) < 3
    %                 S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),3} = [];
    %             end
    %             % the last click can be be unfinished : button down + end of stim = no button up
    %             if isempty(S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),3})
    %                 S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),3} =  S.ER.Data{end,2} - S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),1};
    %             end
    %             click_onset    = [ click_onset    ; cell2mat(S.KL.KbEvents{click_spot.(keys{f}),2}(click_idx,1)) ];
    %             click_duration = [ click_duration ; cell2mat(S.KL.KbEvents{click_spot.(keys{f}),2}(click_idx,3)) ];
    %         else
    %             % pass
    %         end
    %
    %     end
    %
    %     % reorder
    %     [click_onset,i] = sort(click_onset,'ascend');
    %     click_duration = click_duration(i);
    %
    %     onsets   {num.Click} = click_onset;
    %     durations{num.Click} = click_duration;
    
    
    %% data correction
    
    %     % Delete trial when subject did not respond
    %     BehaviorData(trial_to_delete,:) = [];
    
    BehaviorData.subj_resp_num = double(strcmp(BehaviorData.subj_resp,'mirror'));
    BehaviorData.RT_s_(trial_OutOfTime) = S.TaskParam.durTetris; % use maximum time value
    BehaviorData.resp_ok(trial_OutOfTime) = 0; % use maximum time value
    BehaviorData.subj_resp_num(trial_OutOfTime) = 0.5;
    
    
    %% Parmetric modulation
    
    % time modulation : none
    tmod = num2cell(zeros(size(names)));
    
    % orthogonalization : none
    orth = num2cell(zeros(size(names)));
    
    pmod = struct('name',{''},'param',{},'poly',{});
    
    % condition = same vs mirror
    pmod(2).name {1} = 'condition__same-1_mirror+1';
    pmod(2).param{1} = strcmp(BehaviorData.condition,'mirror')*2-1;
    pmod(2).poly {1} = 1;
    
    % angle
    pmod(2).name {2} = 'angle';
    pmod(2).param{2} = BehaviorData.angle_deg_;
    pmod(2).poly {2} = 1;
    
    % RT
    pmod(2).name {3} = 'RT';
    pmod(2).param{3} = BehaviorData.RT_s_;
    pmod(2).poly {3} = 1;
    
    pmod(2).name {4} = 'subjresp__same-1_mirror+1';
    pmod(2).param{4} = BehaviorData.subj_resp_num*2-1;
    pmod(2).poly {4} = 1;
    
    pmod(2).name {5} = 'respok';
    pmod(2).param{5} = BehaviorData.resp_ok*2-1;
    pmod(2).poly {5} = 1;
    
    
catch err
    
    sca
    warning(err.message)
    
end

EchoStop(mfilename)

end % function
