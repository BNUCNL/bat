function [first_half,second_half] = split_half_trial(repetition)
% [first_half,second_half] = split_half_trial(repetition)
% repetition: times of permutation


global STUDY
rawdata = STUDY.raw;


Nsubj = length(rawdata);
conds = unique(rawdata(1).trial(:,1));
Ncond = length(conds);
Ntrial = size(rawdata(1).trial(:,1),1);


if (mod(Ntrial,2)==1)
    midpoint = floor(Ntrial/2)+1;
else
    midpoint  = Ntrial/2;
end


first_half  = zeros(repetition,Nsubj,2*Ncond);
second_half = zeros(repetition,Nsubj,2*Ncond);

for i = 1:repetition
    % permutation
    temp = randperm(Ntrial);
    index_first_half  = temp(1:midpoint);
    index_second_half = temp(midpoint+1:Ntrial);
    
    
    % response for each half
    first_half(i,:,:)  = response(rawdata,index_first_half);
    second_half(i,:,:) = response(rawdata,index_second_half);
end

STUDY.split_half.first  = first_half; 
STUDY.split_half.second = second_half; 


function res = response(rawdata,index)
% rawdata
% RT: react time for each condtion and subject

Nsubj = length(rawdata);
conds = unique(rawdata(1).trial(:,1));
Ncond = length(conds);


RT = zeros(Nsubj,Ncond);
acc = zeros(Nsubj,Ncond);

for s = 1:Nsubj
    trial = rawdata(s).trial(index,:);
    cond  = trial(:,1);
    resp  = trial(:,2);
    rt    = trial(:,3);
    label = trial(:,4);
    
    for c = 1:Ncond
        idx     = cond == conds(c) & resp & label;
        RT(s,c) = mean(rt(idx));
        acc(s,c)= sum(idx)/sum(cond == c);
    end
end

res = [acc,RT];








