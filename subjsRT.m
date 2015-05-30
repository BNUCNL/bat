function  subjsRT(rawdata,mode)
% data: 
% mode: 'all','cond'


Nsubj = length(rawdata);
Ntr = length(rawdata(1).trial(:,1));

switch mode
    case 'all'        
        RT = nan(Nsubj,Ntr);
        for s  = 1:Nsubj
            RT(s,:) = rawdata(s).trial(:,3);
        end
        % visualization
        figure,bar(RT),title('All RTs');
        
    case 'cond'
        cond = unique(rawdata(1).trial(:,1));
        Nc = length(cond);
        
        RT = nan(Nc,Nsubj,Ntr/Nc);
        
        
        for s = 1:length(rawdata)
            trial = rawdata(s).trial;
            for c = cond'
                cidx   = trial(:,1) == c;
                ctrial = trial(cidx,:);
                RT(c,s,:) = ctrial(:,3);
            end
        end
        
        
        
        figure
        for c = 1:Nc
            cRT = RT(c,:,:);
            subplot(Nc,1,c),hist(cRT(:),10000);title(sprintf('RT dist for cond %d',c));
        end
end
        