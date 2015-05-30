function extremeval = extremeRT(mode)
% rawdata:
% mode: 'all','cond'

global STUDY
rawdata = STUDY.raw;
Nsubj = length(rawdata);

switch mode
    case 'all'
        % max and min value to detect outlier
        extremeval = zeros(Nsubj,2);
        for s = 1:Nsubj
            trial = rawdata(s).trial;
            label = trial(:,4)==1;
            extremeval(s,1)  = max(trial(label,3));
            extremeval(s,2)  = min(trial(label,3));
        end
        
        
        maxval = extremeval(:,1);minval = extremeval(:,2);
        
        % visualization
        figure;
        subplot(1,4,1),bar(maxval);title('Max RT');
        subplot(1,4,2),hist(maxval);title('Max RT');
        subplot(1,4,3),bar(minval);title('Min RT');
        subplot(1,4,4),hist(minval);title('Min RT');
        
    case 'cond'
        cond = unique(rawdata(1).trial(:,1));
        Nc = length(cond);
        extremeval = zeros(Nc,Nsubj,2);
        
        for s = 1:length(rawdata)
            trial = rawdata(s).trial;
            for c = cond'
                cidx = trial(:,1) == c;
                ctrial = trial(cidx,:);
                extremeval(c,s,1) = max(ctrial(:,3));
                extremeval(c,s,2) = min(ctrial(:,3));
            end
        end
        
        
        
        % detemine the cutoff for RT by visualization
        figure
        for c = 1:Nc
            maxval = extremeval(c,:,1);
            minval = extremeval(c,:,2);
            
            subplot(Nc,4,4*(c-1)+1),bar(maxval);title('Max RT');
            subplot(Nc,4,4*(c-1)+2),hist(maxval,1000);title('Max RT');
            subplot(Nc,4,4*(c-1)+3),bar(minval);title('Min RT');
            subplot(Nc,4,4*(c-1)+4),hist(minval,1000);title('Min RT');
        end
    otherwise
        disp('Unknown Mode')
end


STUDY.extremeval = extremeval;



