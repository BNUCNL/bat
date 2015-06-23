function [obj,stats] = delTrial(obj,cutoff,plotFigure)
% cutoff:[lowcut,highcut]
% stats: number of bad trials for each subject

if nargin < 3, plotFigure = false; end

subj= obj.subj;
Nsubj = length(subj);
stats = zeros(Nsubj,1);


% del bad trials for each subject
for s  = 1:Nsubj
    label = subj(s).trial(:,3); % true answer
    resp  = subj(s).trial(:,4); % subj response
    srt   = subj(s).trial(:,5); % subject rt
    
    idx = (resp == label) & (srt <= cutoff(1) | srt >= cutoff(2));
    subj(s).trial(idx,:) = [];
    stats(s) = sum(idx);
end

obj.subj = subj;

% plot results
if plotFigure
    figure('Name','Del bad trials');
    subplot(121),hist(stats),title('Hist of the NUM of bad trials');
    subplot(122),bar(stats),title('Bar for the NUM of bad trials');    
end