function reliablity = splitCorr(type)
% reliablity =  splitCorr(firsthalf,secondhalf, type)
% firsthalf:  all condtions data from the first  half trials
% secondhalf: all condtions data from the second half trials
% type: Spearman or Pearson
% corrected_split_half_reliablity: corrected split_half_reliablity
% using Spearman-Brown correction

global STUDY;
firsthalf  = STUDY.split_half.first;
secondhalf = STUDY.split_half.second;


[Nrep,~,Ncond] = size(firsthalf)
rM = zeros(Nrep,Ncond);
switch type
    case 'Pearson'
        for i = 1:Nrep
            for j = 1:Ncond
                [r p] = corr(firsthalf(i,:,j)',secondhalf(i,:,j)','type','Pearson','rows','complete');
                rM(i,j) = r;
            end
        end
        
    case 'Spearman'
        for i = 1:Nrep
            for j = 1:Ncond
                [r p] = corr(firsthalf(i,:,j)',secondhalf(i,:,j)','type','Spearman','rows','complete');
                rM(i,j) = r;
            end
        end
    otherwise
        error('Wrong type')
end

%  Spearman-Brown correction
mean_corr = mean(rM);
reliablity = 2*mean_corr./(1 + mean_corr);


STUDY.reliability.cond  = reliability;



