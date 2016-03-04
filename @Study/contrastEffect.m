function [obj,ces] = contrastEffect(obj,contrast,meastype, meth,plotFigure)
% obj = calEffect(obj,contrast,meas, type)
% calculate the effect for a set of constrast
% contrast: contrast of interest, N(num of constrat)xM(num of condition);
% meastype: acc or rt
% meth: subtraction or regression
% ces: constrast of effect size

if nargin < 5, plotFigure = false; end
if nargin < 4, meth = 'subtraction'; end
if nargin < 3, meastype = 'acc'; end

subj = obj.subj;
nSubj = length(subj);
nContrast = size(contrast,1);
ces = NaN(nSubj, nContrast);


if strcmp(meastype, 'acc')
    meas  = obj.acc;
elseif strcmp(meastype,'rt')
    meas  = obj.rt;
else
    disp('meas should be acc or rt')
end

if isempty(meas)
    error('%s is empty',meastype)
end

if strcmp(meth,'subtraction')
    for c = 1:nContrast
        % calc residual for meas
        ces(:,c) = meas*contrast(c,:)';
    end
elseif strcmp(meth, 'regression')
    for c = 1:nContrast
        yc = contrast(c,:) > 0;
        xc = contrast(c,:) < 0;
        
        % calc residual for meas
        Y = mean(meas(:,yc),2);
        X = mean(meas(:,xc),2);
        b = regress(Y,X);
        ces(:,c) = Y - X*b;
    end
else
    disp('Wrong type')
end

obj.ces = ces;

% plot the results
if plotFigure
    for c = 1:nContrast
        yc = obj.cond(contrast(c,:) > 0);
        ycname = [];link='';
        for i = 1:length(yc)
            ycname = [yc{i},link];
            link = '+';
        end
        xc = obj.cond(contrast(c,:) < 0);
        xcname = [];link='';
        for i = 1:length(xc)
            xcname = [xc{i},link];
            link = '+';
        end
        leg{c}= sprintf('(%s)-(%s)', ycname, xcname);
    end
    
    barvalues = mean(ces)';
    errors = std(ces)'/sqrt(nSubj);
    width = .85;
    groupnames =[];
    bw_title = 'CES Summary';
    bw_xlabel = [];
    bw_ylabel = 'CES';
    bw_colormap = [];
    gridstatus = [];
    bw_legend = leg;
    
    figure('Name','CES Summary');
    handles = barweb(barvalues, errors, width, groupnames, bw_title,...
        bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend);
    
    figure('Name','Histgram for CES');
    for c = 1:nContrast
        subplot(1,nContrast,c);
        hist(ces(:,c)),title(sprintf('%s', leg{c}));
        ylabel('Freq');xlabel('CES')
        set(gca, 'YMinorTick', 'on');
        %         axis square
    end
    
end

