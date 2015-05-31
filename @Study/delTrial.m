function [obj,stats] = delTrial(obj,cutoff)

% cutoff:[lowcut,highcut]
% stats: number of bad trials for each subject

subj= obj.subj;
Nsubj = length(subj);
stats = zeros(Nsubj,1);


for s  = 1:Nsubj
    label = subj(s).trial(:,3); % true answer
    resp  = subj(s).trial(:,4); % subj response
    srt   = subj(s).trial(:,5); % subject rt
    
    idx = (resp == label) & (srt <= cutoff(1) | srt >= cutoff(2));
    subj(s).trial(idx,:) = []; 
    stats(s) = sum(idx);  
end

obj.subj = subj;

figure;
subplot(121),hist(stats),title('Hist of the NUM of bad trials');
subplot(122),bar(stats),title('Bar for the NUM of bad trials');



