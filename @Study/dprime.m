function dp = dprime(obj, plotFigure)
% obj = dprime(obj, plotFigure)
% plotFigure, true or false to indicate if the figure will be ploted
% note that dprime only work for a two-alternative forced choice task
% (2AFC)
% dp, dprime matrx(nSubjx1)

if nargin < 2, plotFigure = false; end

subj = obj.subj;
Nsubj = length(subj); % number of subjects
conds = unique(subj(1).trial(:,2));
nCond = length(conds);% number of conditions

if nCond ~= 2
    error('dprime only works for a two-alternative forced choice task')
end

dp = NaN(Nsubj,1);
for s = 1:Nsubj
    cond = subj(s).trial(:,2); % cond num
    label = subj(s).trial(:,3);% true answer
    resp = subj(s).trial(:,4); % subj response
    
    % calculate hit rate prime
    nTrial = sum(cond == cond(1));
    hit_trial  = cond == conds(1) & resp == label;
    hit_rate =  sum(hit_trial)/nTrial;
    
    % calculate false alarm rate
    false_alarm_trial = cond == conds(2) & resp ~= label;
    false_alarm_rate =  sum(false_alarm_trial)/nTrial;
    
    dp(s) = norminv(hit_rate,0,1) - norminv(false_alarm_rate,0,1);
end

 obj.dp = dp;
 
 
% plot the results
if plotFigure
    leg = sprintf('%s vs. %s', obj.cond{1},obj.cond{2});
    
    dp = dp(~isinf(dp));
    barvalues = mean(dp)';
    
    
    errors = std(dp)';
    width = .85;
    groupnames =[];
    bw_title = 'dPrime Summary';
    bw_xlabel = [];
    bw_ylabel = 'd prime';
    bw_colormap = [];
    gridstatus = [];
    bw_legend = leg;
    
    handles = barweb(barvalues, errors, width, groupnames, bw_title,...
        bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend);
  
    
    figure('Name','Histgram for d Prime');  
    hist(dp,title(sprintf('%s', leg)));
    ylabel('Freq');xlabel('d prime')
    set(gca, 'YMinorTick', 'on');
    %         axis square
end


