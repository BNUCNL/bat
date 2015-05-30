function acc = estimateAccuracy()
% rawdata

global STUDY

rawdata = STUDY.raw;

Nsubj = length(rawdata);
conds = unique(rawdata(1).trial(:,1));
Ncond = length(conds);


acc = zeros(Nsubj,Ncond);
for s = 1:Nsubj
    cond = rawdata(s).trial(:,1);
    resp = rawdata(s).trial(:,2);
    label = rawdata(s).trial(:,4);

    for c = 1:Ncond 
        idx   = cond == conds(c) & resp & label;
        acc(s,c) = sum(idx)/sum(cond == c);
    end
end

groupnames = {'Cond'};
width = .85;

figure,barweb(mean(acc),std(acc),width,groupnames);
title('Accuracy Summary'),ylabel('Accuracy');


STUDY.acc = acc;