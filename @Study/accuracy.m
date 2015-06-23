function obj = accuracy(obj, plotFigure)

if nargin < 2, plotFigure = false; end

subj = obj.subj;
Nsubj = length(subj); % number of subjects
conds = unique(subj(1).trial(:,2));
Ncond = length(conds);% number of conditions


acc = NaN(Nsubj,Ncond);
for s = 1:Nsubj
    cond = subj(s).trial(:,2); % cond num
    label = subj(s).trial(:,3);% true answer
    resp = subj(s).trial(:,4); % subj response
    
    % calculate acc for each condition
    for c = 1:Ncond
        idx   = cond == conds(c) & resp == label;
        acc(s,c) = sum(idx)/sum(cond == c);
    end
     
    % calculate acc for all of conditions
    acc(s,Ncond+1) = sum(resp == label)/length(resp);
end

obj.acc = acc;


% plot the results
if plotFigure 
    leg = obj.cond;
    leg{end+1} = 'Overall';
    
    barvalues = mean(acc)';
    errors = std(acc)';
    width = .85;
    groupnames =[];
    bw_title = 'Accuracy Summary';
    bw_xlabel = [];
    bw_ylabel = 'Accuracy';
    bw_colormap = [];
    gridstatus = [];
    bw_legend = leg;
    
    handles = barweb(barvalues, errors, width, groupnames, bw_title,...
        bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend);
    
    
    figure('Name','Histgram for ACC');
    subplot(121),hist(acc(:,1)),title(sprintf('%s', obj.cond{1}));
    subplot(122),hist(acc(:,2)),title(sprintf('%s', obj.cond{2}));
    set(gca, 'YMinorTick', 'on')
end

