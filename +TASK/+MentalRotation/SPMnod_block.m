function [ names , onsets , durations ] = SPMnod_block()
global S

%SPMNOD Build 'names', 'onsets', 'durations' for SPM

EchoStart(mfilename)

try
    %% Preparation
    
    names = {
        'Rest'
        'Click'
        };
    
    same_mb = strcmp(S.TaskParam.miniblock(:,2), 'same');
    same_angle = unique([S.TaskParam.miniblock{same_mb,1}]);
    for a = 1 : length( same_angle )
        names{end+1} = sprintf('Trial__same__%03d', same_angle(a)); %#ok<AGROW>
    end
    
    mirr_mb = strcmp(S.TaskParam.miniblock(:,2), 'mirror');
    mirr_angle = unique([S.TaskParam.miniblock{mirr_mb,1}]);
    for a = 1 : length( mirr_angle )
        names{end+1} = sprintf('Trial__mirr__%03d', mirr_angle(a)); %#ok<AGROW>
    end
    
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
    
    %     % Delete trial when subject did not respond
    %     trial_to_delete = BehaviorData.RT_s_ < 0;
    
    
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
            angle = EventData{event,5};
            cond = EventData{event,6};
            evt_name = sprintf('Trial__%s__%03d', cond(1:4), angle);
            onsets{num.(evt_name)} = [onsets{num.(evt_name)} ; EventData{event,2}];
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
            angle = EventData{event,5};
            cond = EventData{event,6};
            evt_name = sprintf('Trial__%s__%03d', cond(1:4), angle);
            durations{num.(evt_name)} = [ durations{num.(evt_name)} ; EventData{event+1,2}-EventData{event,2}] ;
            %             end
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
            % if only 1 keypres and never released (wtf ?), need to deal with this unprobable case
            if size(S.KL.KbEvents{click_spot.(keys{f}),2}) < 3
                S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),3} = [];
            end
            % the last click can be be unfinished : button down + end of stim = no button up
            if isempty(S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),3})
                S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),3} =  S.ER.Data{end,2} - S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),1};
            end
            click_onset    = [ click_onset    ; cell2mat(S.KL.KbEvents{click_spot.(keys{f}),2}(click_idx,1)) ]; %#ok<AGROW>
            click_duration = [ click_duration ; cell2mat(S.KL.KbEvents{click_spot.(keys{f}),2}(click_idx,3)) ]; %#ok<AGROW>
        else
            % pass
        end
        
    end
    
    % reorder
    [click_onset,i] = sort(click_onset,'ascend');
    click_duration = click_duration(i);
    
    onsets   {num.Click} = click_onset;
    durations{num.Click} = click_duration;
    
    
catch err
    
    sca
    warning(err.message)
    
end

EchoStop(mfilename)

end % function
