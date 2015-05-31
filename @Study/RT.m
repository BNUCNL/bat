function rt = RT(obj)
% RT: react time for each condtion and subject

subj = obj.subj;
Nsubj = length(subj);
conds = unique(subj(1).trial(:,2));
Ncond = length(conds);


rt = zeros(Nsubj,Ncond);
for s = 1:Nsubj
    cond  = subj(s).trial(:,2); % cond label
    label = subj(s).trial(:,3); % true answer
    resp  = subj(s).trial(:,4); % subj response
    srt   = subj(s).trial(:,5); % subject rt
    
    for c = 1:Ncond
        idx   = cond == conds(c) & resp == label;
        rt(s,c) = mean(srt(idx));
    end
        rt(s,Ncond+1) = mean(srt(resp == label));
end



obj.rt = rt;

leg = obj.cond;
leg{end+1} = 'Overall';

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

handles = barweb(barvalues, errors, width, groupnames, bw_title,...
    bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend);
 