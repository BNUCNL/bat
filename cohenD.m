% [effectsize mean1 mean2 std1 std2] = cohen_d(X,Y,type)
% Effect size caculator: Cohen's d
% X, Y should be a colume of vectors;
% Type 1: indepdent sample t test; type 2: matched sample t test
% by LJG & WRS. 2010.7
% modifed by LJG @ 2011.4

function [effectsize mean1 mean2 std1 std2] = cohen_d(X,Y,type)
    
    mean1 = mean(X);
    mean2 = mean(Y);
    std1 = std(X);
    std2 = std(Y);

    if type == 1 % indepdent samplle
        n1=length(X);
        n2=length(Y);  
        s=sqrt(((n1-1)*std1^2+(n2-1)*std2^2)/(n1+n2-2));
        effectsize = (mean1 - mean2)/s;
    elseif type ==2 % related sample
        r = corr(X,Y);
        effectsize = (mean1 - mean2)/sqrt(std1^2 + std2^2 - 2*r*std1*std2);
    end
    
    effectsize = abs(effectsize); 
    
end