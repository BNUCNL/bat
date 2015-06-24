function  plotSubjRT(obj)
% plotSubjRT(obj)
% polt RT for each subject

subj = obj.subj;
Nsubj = length(subj);
conds = unique(subj(1).trial(:,2));
Nc = length(conds);
Ntr = length(subj(1).trial(:,1));

% plot RT of each subject
for s  = 1:Nsubj
    cond  = subj(s).trial(:,2); % cond label
    label = subj(s).trial(:,3); % true answer
    resp  = subj(s).trial(:,4); % subj response
    srt   = subj(s).trial(:,5); % subject rt
    
    figure('Name',subj(s).name)
    idx   = resp == label;
    subplot(121),
    bar(find(idx),srt(idx));
    ylim([0,2])
    ylabel('RT(s)')
    title(sprintf('%s-trial',subj(s).name));
    
    
    
    subplot(122),
    hist(srt(idx));
    title(sprintf('%s-Hist',subj(s).name));
     ylabel('RT(s)')
    
    pause;
end

% figure,bar(rt),title('All RTs');


