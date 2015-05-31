function  plotSubjRT(obj)
% data:


subj = obj.subj;


Nsubj = length(subj);
conds = unique(subj(1).trial(:,2));
Nc = length(conds);
Ntr = length(subj(1).trial(:,1));



% colorspec = {'r','g','b','c','m','y','k','w',''};
rt = zeros(Nsubj,Ntr);

% plot RT of each subject
for s  = 1:Nsubj
    cond  = subj(s).trial(:,2); % cond label
    label = subj(s).trial(:,3); % true answer
    resp  = subj(s).trial(:,4); % subj response
    srt   = subj(s).trial(:,5); % subject rt
    
    rt(s,:) = srt;
   
    idx   = resp == label;
    bar(find(idx),srt(idx));
    ylim([0,8])
    
    
    title(sprintf('%s',subj(s).name));
    pause;
end

figure,bar(rt),title('All RTs');


