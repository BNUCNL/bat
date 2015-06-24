function obj = delSubjOutlier(obj,meth,range,param,plotFigure)
% [obj,badSubj] = delSubjOutlier(obj,meth,range,param,plotFigure)
% The method detect outlier subject based on ACC or RT
% param: ACC or RT
% meth: ABS, IQR,or STD
% range: if meth is IQR for STD, range is a multiple factor to define
% the limit;e.g, [mean-range*STD, mean+ range*STD]. if method is ABS,range is vector,[low,high]
% badSuhj: index matrix for bad subject

if nargin < 5, plotFigure = false; end
if nargin < 4, param = 'ACC';end

if strcmp(param,'ACC')
    D  = obj.acc;
elseif strcmp(param,'RT')
    D  = obj.rt;
else
    disp('Wrong Param')
end

[nSubj,nCond] = size(D);
badSubj = false(nSubj,nCond);

% detect outlier using different approach
if strcmp(meth,'IQR')
    Q = prctile(D, [25; 75]);
    IQR = Q(2,:) - Q(1,:);
    lowcut =  Q(1,:) - range*IQR;
    highcut = Q(2,:) + range*IQR;
    
elseif strcmp(meth,'STD')
    MU = mean(D);
    STD = std(D);
    lowcut =  MU - range* STD;
    highcut = MU + range*STD;
    
elseif strcmp(meth,'ABS')
    lowcut =  repmat(range(1),1,nCond);
    highcut = repmat(range(2),1,nCond);
end

% print outlier subject name
for c = 1:nCond
    idx = D(:,c) < lowcut(c) | D(:,c) > highcut(c);
    badSubj(:,c) = idx;
    idx = find(idx);
    fprintf(1,'%d outlier for %s %s\n',length(idx),obj.cond{c},param);
    
    for i = 1:length(idx)
        fprintf(1,'%d: %s\n',idx(i),obj.subj(idx(i)).name);
    end
end

% delete subject
badSubjIdx = any(badSubj,2);
obj.subj(badSubjIdx) = [];
fprintf(1,'In total,%d Subjects have been discard\n', sum(badSubjIdx));

if plotFigure
    newD = D(~badSubjIdx,:);
    figure('Name',sprintf('Hist for %s',param));
    for c = 1:nCond
        subplot(1,nCond,c),
        [n1, xout1] = hist(D(:,c));
        bar(xout1,n1,'r'); hold on
        [n2, xout2] = hist(newD(:,c));
        bar(xout2,n2,'g');
    end
end
