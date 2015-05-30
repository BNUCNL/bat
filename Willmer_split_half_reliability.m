function corrected_split_half_reliablity = split_half_reliablity(repetitionN,targetV, type)
% function [corrected_split_half_reliablity] = split_half_reliablity(repetitionN,targetV, type)
% An general split-half reliability analysis procedure
% repetitionN: Numbers of repetition; 
% targetV: Target variable
%   each row represent a partipants; 
%   each colume represent a trial/question
% type (of correlation):
%   1 - Pearson correlation
%   2 - Spearman correlation



%% Preparation
[subN, trialN] = size(targetV);
correlationM = zeros(repetitionN,1);




for i = 1:repetitionN
    % permutation
    temp = randperm(trialN);    
    index_first_half = temp(1:trialN/2);
    index_second_half = temp(trialN/2+1:trialN);
    
    % Correlation
    mean_first_half  =  nanmean(targetV(:,index_first_half),2);
    mean_second_half =  nanmean(targetV(:,index_second_half),2);
    if type ==1
        [r p] = corr(mean_first_half,mean_second_half,'type','Pearson','rows','complete');
    else 
        [r p] = corr(mean_first_half,mean_second_half,'type','Spearman','rows','complete');       
    end
    correlationM(i,1)=r;
end

%% Spearman-Brown correction
mean_correlation = mean(correlationM);
corrected_split_half_reliablity = 2*mean_correlation /(1 + mean_correlation);
