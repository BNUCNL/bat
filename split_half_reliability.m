function [mean_corr,std_corr] = split_half_reliablity(type,contrast)
% reliablity =  split_half_reliablity(firsthalf,secondhalf, type)
% firsthalf:  all condtions data from the first  half trials
% secondhalf: all condtions data from the second half trials
% type: Spearman or Pearson
% corrected_split_half_reliablity: corrected split_half_reliablity
% using Spearman-Brown correction

global STUDY;
firsthalf  = STUDY.split_half.first;
secondhalf = STUDY.split_half.second;


[Nrep,~,Ncond] = size(firsthalf);
if nargin < 2
    rM = zeros(Nrep,Ncond);
    for i = 1:Nrep
        for j = 1:Ncond
            [r p] = corr(firsthalf(i,:,j)',secondhalf(i,:,j)','type',type,'rows','complete');
            rM(i,j) = r;
        end
    end
else
    rM = zeros(Nrep,1);
    Nc = Ncond/2;
    contrast = contrast';
    for i = 1:Nrep
        acc1 = squeeze(firsthalf(i,:,1:Nc))*contrast;acc2 = squeeze(secondhalf(i,:,1:Nc))*contrast;
        rt1 = squeeze(firsthalf(i,:,Nc+1:end))*contrast;rt2 = squeeze(secondhalf(i,:,Nc+1:end))*contrast;
        rM(i,1) = corr(acc1,acc2,'type',type,'rows','complete');
        rM(i,2) = corr(rt1,rt2,'type',type,'rows','complete');
    end
end


%  Spearman-Brown correction
mean_corr =  2*mean(rM)./(1+mean(rM));
std_corr  =  2*std(rM)./(1+std(rM));

width = 0.85;
figure,barweb(mean_corr,std_corr,width);





STUDY.reliability.mean  = mean_corr;
STUDY.reliability.std  = std_corr;


