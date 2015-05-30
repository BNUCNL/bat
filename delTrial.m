function [rawdata,stats] = delTrial(rawdata,cutoff)
% rawdata:
% cutoff:[lowcut,highcut]
% stats: number of bad trials for each subject

Nsubj = length(rawdata);
stats = zeros(Nsubj,1);
for s  = 1:Nsubj
    rt   = rawdata(s).trial(:,3);
    label = rawdata(s).trial(:,4);
    label(rt <= cutoff(1) | rt >= cutoff(2)) = 0;
    
    rawdata(s).trial(:,4) = label;   
    stats(s) = sum(label==0);
    
end


figure;
subplot(121),hist(stats),title('Hist of the NUM of bad trials');
subplot(122),bar(stats),title('Bar for the NUM of bad trials');



