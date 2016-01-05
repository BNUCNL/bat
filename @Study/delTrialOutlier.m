function [obj,stats] = delTrialOutlier(obj,meth,range,plotFigure)
% [obj,stats] = delTrialOutlier(obj,meth,range,plotFigure)
% method: ABS, IQR,or STD
% if meth is IQR for STD, range is a multiple factor to define the limit,
% e.g, [mean-range*STD, mean+ range*STD];if method is ABS: range is vector,[low,high]
% stats: number of bad trials for each subject

if nargin < 4, plotFigure = false; end

subj= obj.subj;
Nsubj = length(subj);
condID = unique(subj(1).trial(:,2));
nCond = length(condID);
stats = zeros(Nsubj,nCond);


% del bad trials for each subject
for s  = 1:Nsubj
    cond =  subj(s).trial(:,2);
%     label = subj(s).trial(:,3); % true answer
%     resp  = subj(s).trial(:,4); % subj response
    rt   = subj(s).trial(:,5);  % subject rt
    badidx = false(length(cond),nCond);
    
    for c = 1:nCond
%         idx = resp == label & cond == condID(c); % only care correct
%         trials
        idx = cond == condID(c); % care both correct and uncorrect trials
        crt = rt(idx);% rt for a conditon
        if strcmp(meth,'IQR')
            Q = prctile(crt, [25; 75]);
            IQR = Q(2) - Q(1);
            lowcut =  Q(1) - range*IQR;
            highcut = Q(2) + range*IQR;
       
        elseif strcmp(meth,'STD')
            MU = mean(crt);
            STD = std(crt);
            lowcut =  MU - range* STD;
            highcut = MU + range*STD;         
            
        elseif strcmp(meth,'ABS')
            lowcut =  range(1);
            highcut = range(2);
        end
       
        idx = idx & (rt < lowcut | rt > highcut);
        stats(s,c) = sum(idx);
        badidx(:,c) = idx;
    end
    
    subj(s).trial(any(badidx,2),:) = [];
end

obj.subj = subj;

% plot results
if plotFigure
    figure('Name','Del bad trials');
    subplot(121),hist(stats),title('Hist of the NUM of bad trials');
    subplot(122),bar(stats),title('Bar for the NUM of bad trials');
end