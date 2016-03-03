function rt = RT(obj,plotFigure)
%  rt = RT(obj,plotFigure)
% rt: react time for each condtion and subject
% plotFigure, true or false


if nargin < 2, plotFigure = false; end
subj = obj.subj;
Nsubj = length(subj);
conds = unique(subj(1).trial(:,2));
nCond = length(conds);


rt = zeros(Nsubj,nCond);
for s = 1:Nsubj
    cond  = subj(s).trial(:,2); % cond label
    label = subj(s).trial(:,3); % true answer
    resp  = subj(s).trial(:,4); % subj response
    srt   = subj(s).trial(:,5); % subject rt
    
    % calculate RT for each conditon
    for c = 1:nCond
        idx   = cond == conds(c) & resp == label;
        rt(s,c) = nanmean(srt(idx));
    end
    % calculate gross RT for all of conditions
    rt(s,nCond+1) = nanmean(srt(resp == label));
end


obj.rt = rt;

% plot the results
if plotFigure
    leg = obj.cond;
    barvalues = nanmean(rt)';
    errors = nanstd(rt)';
    width = .85;
    groupnames =[];
    bw_title = 'RT Summary';
    bw_xlabel = [];
    bw_ylabel = 'RT(ms)';
    bw_colormap = [];
    gridstatus = [];
    bw_legend = leg;
    
    figure('Name','RT Summary');
    handles = barweb(barvalues, errors, width, groupnames, bw_title,...
        bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend);
    
    
    figure('Name','Histgram for RT');
    nCond = nCond + 1;
    
    for c = 1:nCond
        subplot(1,nCond,c);
        hist(rt(:,c)),title(sprintf('%s', obj.cond{c}));
        ylabel('Freq');xlabel('RT')
        set(gca, 'YMinorTick', 'on');
%         axis square
        
    end
end
