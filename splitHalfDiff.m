function [R_diff R_residual] = splitHalfDiff(repetitionN,interested_varialbe, controlled_variable,type)
% function [corrected_split_half_reliablity] = split_half_02(repetitionN,interested_varialbe, controlled_variable,type)
% An general split-half reliability analysis procedure
% repetitionN: Numbers of repetition; 
% interested_varialbe/controlled_variable:
%   each row represent a partipants; 
%   each colume represent a trial/question
% type (of correlation):
%   1 - Pearson correlation
%   2 - Spearman correlation
% Based on J.Wilmer (2008), but exactly permutation,
% NOT simply repetition as Wilmer!
% LJG 2011-03-18
% LJG modifed @ 2011-04-15
% LJG modifed @ 2011-05-24

%% Basic calculation
for i = 1:repetitionN

    for variabletype = 1:2

        if variabletype == 1
            targetV = interested_varialbe;
        elseif variabletype == 2
            targetV = controlled_variable;
        end

        [subN trialN] = size(targetV);
        all_index = [];
        repetitionCount = 0;

        % permutation
        temp = Shuffle(1:trialN);
        all_index = [all_index;temp];
        while length(all_index) ~= length(unique(all_index,'rows'))
            repetitionCount = repetitionCount+1;
            temp = Shuffle(1:trialN);
            all_index = [unique(all_index,'rows');temp];
            if repetitionCount > 5000;
                disp('Permutation number is larger than 5000! Please reset permutationN!');
                return;
            end
        end

        index_first_half = temp(1:trialN/2);
        index_second_half = temp(trialN/2+1:trialN);

        % save variable
        % FIRST/SECOND means the first or second splitted half; 
            % colume 1 - interested varialbe
            % colume 2 - controlled varabile
        mean_first_half =  nanmean(targetV(:,index_first_half),2);
        mean_second_half =  nanmean(targetV(:,index_second_half),2);
        if variabletype == 1
            FIRST(:,1) = mean_first_half;
            SECOND(:,1) = mean_second_half;
        elseif variabletype == 2
            FIRST(:,2) = mean_first_half;
            SECOND(:,2) = mean_second_half;
        end

    end % End variable type

    % Correlation: difference scores
%     subduction

%     FIRST_effect(:,1)=FIRST(:,1)-FIRST(:,2);
%     SECOND_effect(:,1)=SECOND(:,1)-SECOND(:,2);
%     division
    FIRST_effect(:,1)=(FIRST(:,1)-FIRST(:,2))./(FIRST(:,1)+FIRST(:,2));
    SECOND_effect(:,1)=(SECOND(:,1)-SECOND(:,2))./(SECOND(:,1)+SECOND(:,2));
    
    if type ==1
        [r_diff p] = corr(FIRST_effect(:,1),SECOND_effect(:,1),'type','Pearson','rows','complete');
    else
        [r_diff p] = corr(FIRST_effect(:,1),SECOND_effect(:,1),'type','Spearman','rows','complete'); 
    end
    correlation_diff(i,1)=r_diff;

    % Correlation: residual scores
    [junk junk residual_first] = regress(FIRST(:,1),[FIRST(:,2),ones(subN,1)]);
    [junk junk residual_second] = regress(SECOND(:,1),[SECOND(:,2),ones(subN,1)]);
    if type ==1
        [r_res p] = corr(residual_first,residual_second,'type','Pearson','rows','complete');
    else
        [r_res p] = corr(residual_first,residual_second,'type','Spearman','rows','complete');
    end
    correlation_residual(i,1)=r_res;

end % End repetition
    
%% Spearman-Brown correction
mean_correlation_diff = mean(correlation_diff);
R_diff = 2*mean_correlation_diff /(1 + mean_correlation_diff);

mean_correlation_res = mean(correlation_residual);
R_residual = 2*mean_correlation_res /(1 + mean_correlation_res);
