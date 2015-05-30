function RT = estimateRT()
% rawdata
% RT: react time for each condtion and subject


global STUDY

rawdata = STUDY.raw;
Nsubj = length(rawdata);
conds = unique(rawdata(1).trial(:,1));
Ncond = length(conds);


RT = zeros(Nsubj,Ncond);
for s = 1:Nsubj
    cond = rawdata(s).trial(:,1);
    resp = rawdata(s).trial(:,2);
    rt   = rawdata(s).trial(:,3);
    label = rawdata(s).trial(:,4);
    
    for c = 1:Ncond
        idx   = cond == conds(c) & resp & label;
        RT(s,c) = mean(rt(idx));
    end
end



groupnames = {'Cond'};
width = .85;
figure, barweb(mean(RT),std(RT),width,groupnames);
title('RT Summary'),;ylabel('RT');


STUDY.RT = RT;