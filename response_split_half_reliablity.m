function reliablity = response_split_half_reliablity(repnum,targmat,type)
% reliablity =  response_split_half_reliablity(repnum,targmat,type)
% An general split-half reliability analysis procedure
% repnum: Numbers of repetition; 
% targnat: Target variable
%   each row represent a partipants; 
%   each colume represent a trial/question
% type (of correlation):
%   1 - Pearson correlation
%   2 - Spearman correlation



trial = cell2mat(targmat(1).trial);
Ncond = length(unique(trial(:,1)));


reliablity = zeros(2*Ncond,1);

for c = 1:Ncond
    acc = [];
    RT  = [];
    for s = 1:length(targmat)
        ds = targmat(s);
        trial = cell2mat(ds.trial);
        cond = trial(:,1);
        resp = trial(:,2);
        rt   = trial(:,3);
        
        idx  = cond == c; 
        acc  = [acc;resp(idx)'];
        
        rtidx = (cond == c & resp);
        rt(~rtidx) = nan;
        RT   = [RT;rt(idx)'];
    end
   
    reliablity(c) = split_half_reliablity(repnum,acc,type);
    reliablity(c+Ncond) = split_half_reliablity(repnum,RT,type);    
end



