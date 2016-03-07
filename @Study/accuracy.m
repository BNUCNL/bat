function [obj,rt] = accuracy(obj, plotFigure)
% obj = accuracy(obj, plotFigure)
% plotFigure: true or false
% acc: accurcy matrix(nSubj x nCond)

if nargin < 2, plotFigure = false; end

subj = obj.subj;
Nsubj = length(subj); % number of subjects
conds = unique(subj(1).trial(:,2));
nCond = length(conds);% number of conditions

acc = NaN(Nsubj,nCond);
for s = 1:Nsubj
    cond = subj(s).trial(:,2); % cond num
    label = subj(s).trial(:,3);% true answer
    resp = subj(s).trial(:,4); % subj response
    
    % calculate acc for each condition
    for c = 1:nCond
        idx   = cond == conds(c) & resp == label;
        acc(s,c) = sum(idx)/sum(cond == c);
    end
    
    % calculate acc for all of conditions
    acc(s,nCond+1) = sum(resp == label)/length(resp);
end

obj.acc = acc;
% plot the results
if plotFigure
    leg = obj.cond;
    
    barvalues = mean(acc)';
    errors = std(acc)';
    width = .85;
    groupnames =[];
    bw_title = 'ACC Summary';
    bw_xlabel = [];
    bw_ylabel = 'Accuracy';
    bw_colormap = [];
    gridstatus = [];
    bw_legend = leg;
    barweb(barvalues, errors, width, groupnames, bw_title,...
        bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend);
    
    figure('Name','Histgram for ACC');
    nCond = nCond + 1;
    for c = 1:nCond
        subplot(1,nCond,c);
        hist(acc(:,c)),title(sprintf('%s', obj.cond{c}));
        ylabel('Freq');xlabel('RT')
        set(gca, 'YMinorTick', 'on');
        %         axis square
    end
end

