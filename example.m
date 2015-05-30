% example codefor visualize the data with matlab

% --------------------------------------------------------------------------
% In this example, we have four conditons, so there are 8 variables.
% The first four variabls are the accucry for each conditon,and 
% the second four variables are the RT for each condtion.
%--------------------------------------------------------------------------


condname = {'alignsame','aligndiff','misalignsame','misaligndiff'};
Ncond = length(condname);

% Get the max and max value for each variable(column)
maxval = max(targ);
minval = min(targ);


% Get Descriptive statistics
boxplot(targ,'notch','on')



% plot scatter and histgram for the acc from cond1 and cond3
close all
figure, scatterhist(targ(:,1),targ(:,3))
xlabel(condname{1}),ylabel(condname{3})
title('scatterhist for cond1 and cond3')

% Plot the scatter matrix for the acc from all conditons to detect the
% outlier
[H,AX,BigAx,P] = plotmatrix(targ(:,1:4),'or');
for t= 1:4
    title(AX(1,t),condname{t},'fontsize',12);
    ylabel(AX(t,1),condname{t},'fontsize',12);
end


% plot the scatter matrix for the RT from all conditons to detect the
% outlier
[H,AX,BigAx,P] = plotmatrix(targ(:,5:8),'or');
for t= 1:4
    title(AX(1,t),condname{t},'fontsize',12);
    ylabel(AX(t,1),condname{t},'fontsize',12);
end

% plot the data as the time serise
andrewsplot(targ)

% plot the correlation matrix between the raw score using bar
bar3(corrcoef(targ(:,1:4))-eye(4)) % for correlations of acc
bar3(corrcoef(targ)-eye(8)) % for correlations of all 8 varibale


% plot the correlation matrix between the raw score using color map
imagesc(corrcoef(targ,1:4)-eye(4)) % for correlationsof acc
imagesc(corrcoef(targ)-eye(8)) % for correlations of all 8 varibale








