function [rmean,rstd] = splitHalfReliability(obj,para,type,nrep)
% reliablity =  split_half_reliablity(firsthalf,secondhalf, type)
% para: parameter of interest, acc or rt;
% type: Spearman or Pearson

if nargin < 4, nrep = 1000; end
if nargin < 3, type = 'Pearson'; end
if nargin < 2, para = 'acc'; end

subj = obj.subj;
fobj = obj;
sobj = obj;

ntr = length(subj(1).trial);
nsubj = length(subj);
ncond = length(obj.cond) + 1;


R = NaN(nrep,ncond, ncond);
for i = 1:nrep
    tmp = randperm(ntr);
    fidx = tmp(1:ntr/2);
    sidx = tmp(ntr/2+1:ntr);
    
    for s = 1:nsubj
        fobj.subj(s).trial = subj(s).trial(fidx,:);
        sobj.subj(s).trial = subj(s).trial(sidx,:);
    end
    
    if strcmp(para,'acc')
        fp =  fobj.accuracy();
        sp =  sobj.accuracy();
    elseif strcmp(para,'rt')
        fp = fobj.RT();
        sp = sobj.RT();
    end
    
     R(i,:,:) =corr(fp,sp,'type',type,'rows','complete'); 
end





%  Spearman-Brown correction
rmean =  squeeze(2*mean(R,1)./(1+mean(R,1)));
rstd  =  squeeze(2*std(R,0,1)./(1+std(R,0,1)));

% width = 0.85;
% figure,barweb(mean_corr,std_corr,width);


