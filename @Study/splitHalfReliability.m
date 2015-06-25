function [rAcc,rRT] = splitHalfReliability(obj,contrast,type,nrep)
% [rAcc,rRT] = splitHalfReliablity(obj,contrast, type, nrep)
% contrast: contrast of interest;
% type: Spearman or Pearson
% nrep: number of repetition

if nargin < 4, nrep = 1000; end
if nargin < 3, type = 'Pearson'; end

subj = obj.subj;
fobj = obj; % first half object
sobj = obj; % second half object

nSubj = length(subj);
nCond = length(obj.cond);
R = NaN(nrep,nCond, nCond);

for i = 1:nrep
    % retrive data for two halves
    for s = 1:nSubj
        nTrial = length(subj(s).trial);
        randidx = randperm(nTrial);
        fidx = randidx(1:floor(nTrial/2)); % index for first half;
        sidx = randidx(floor(nTrial/2+1):nTrial); % index for second half
        
        fobj.subj(s).trial = subj(s).trial(fidx,:);
        sobj.subj(s).trial = subj(s).trial(sidx,:);
    end
    
    % calculate parameter for two halves
    facc =  fobj.accuracy().acc;
    sacc =  sobj.accuracy().acc;
    frt = fobj.RT().rt;
    srt = sobj.RT().rt;
    
    % calculate param for each contrast.
    for c = 1:size(contrast,1)
        % ACC
        facc = [facc,facc*contrast(c,:)'];
        sacc = [sacc,sacc*contrast(c,:)'];
        
        % RT
        frt = [frt,frt*contrast(c,:)'];
        srt = [srt,srt*contrast(c,:)'];
    end
    
    % correlation between first and second half
    accR(i,:,:) = corr(facc,sacc,'type',type,'rows','complete');
    rtR(i,:,:) = corr(frt,srt,'type',type,'rows','complete');
end

% Spearman-Brown correction
rAcc.mean = squeeze(2*mean(accR,1)./(1+mean(accR,1)));
rAcc.std  = squeeze(2*std(accR,0,1)./(1+std(accR,0,1)));

rRT.mean = squeeze(2*mean(rtR,1)./(1+mean(rtR,1)));
rRT.std  = squeeze(2*std(rtR,0,1)./(1+std(rtR,0,1)));


% width = 0.85;
% figure,barweb(meanR,stdR,width);


