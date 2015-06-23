function [rmean,rstd] = splitHalfReliability(obj,para,type,nrep)
% [rmean, rstd] =  splitHalfReliablity(obj,para, type, nrep)
% para: parameter of interest, acc or rt;
% type: Spearman or Pearson
% nrep: number of repetition

if nargin < 4, nrep = 1000; end
if nargin < 3, type = 'Pearson'; end
if nargin < 2, para = 'acc'; end

subj = obj.subj;
fobj = obj; % first half object
sobj = obj; % second half object

ntr = length(subj(1).trial);
nsubj = length(subj);
ncond = length(obj.cond) + 1;


R = NaN(nrep,ncond, ncond);
for i = 1:nrep
    tmp = randperm(ntr);
    fidx = tmp(1:ntr/2); % index for first half 
    sidx = tmp(ntr/2+1:ntr); % index for second half
    
    % retrive data for two halves
    for s = 1:nsubj
        fobj.subj(s).trial = subj(s).trial(fidx,:);
        sobj.subj(s).trial = subj(s).trial(sidx,:);
    end
    
    % calculate parameter for two halves
    if strcmp(para,'acc')
        fp =  fobj.accuracy();
        sp =  sobj.accuracy();
    elseif strcmp(para,'rt')
        fp = fobj.RT();
        sp = sobj.RT();
    end
    
    % correlation between first and second half
     R(i,:,:) = corr(fp,sp,'type',type,'rows','complete'); 
end

% Spearman-Brown correction
rmean =  squeeze(2*mean(R,1)./(1+mean(R,1)));
rstd  =  squeeze(2*std(R,0,1)./(1+std(R,0,1)));

% width = 0.85;
% figure,barweb(mean_corr,std_corr,width);


