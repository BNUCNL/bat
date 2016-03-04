function [obj,extremeval] = extremeRT(obj,mode,plotFigure)
%  extremeval = extremeRT(obj,mode,plotFigure)
% mode: 'all': ,'cond'
% plotFigure: true or false
% extremeval: extrame value matrx 

if nargin < 3, plotFigure = false; end


subj = obj.subj;
Nsubj = length(subj);

switch mode
    case 'all' % merged different condtion together
        % max and min value to detect outlier
        extremeval = zeros(Nsubj,2);
        for s = 1:Nsubj
            
            label = subj(s).trial(:,3); % true answer
            resp  = subj(s).trial(:,4); % subj response
            rt   = subj(s).trial(:,5); % subject rt
            
            idx = label == resp;
            if any(idx)
                extremeval(s,1)  = max(rt(idx));
                extremeval(s,2)  = min(rt(idx));
            end
        end
        
        maxval = extremeval(:,1);minval = extremeval(:,2);
        if plotFigure
            % visualization
            figure('Name','ExtremeRT');
            
            subplot(1,4,1),bar(maxval);title('Max RT');
            xlabel('trial ID'),ylabel('RT(s)');
            
            subplot(1,4,2),hist(maxval);title('Max RT');
            xlabel('RT'),ylabel('Freq');
            
            subplot(1,4,3),bar(minval);title('Min RT');
            xlabel('trial ID'),ylabel('RT(s)');
            
            subplot(1,4,4),hist(minval);title('Min RT');
            xlabel('RT'),ylabel('Freq');
        end
    case 'cond' % each conditon, separately
        conds = unique(subj(1).trial(:,2));
        Nc = length(conds);
        extremeval = zeros(Nc,Nsubj,2);
        
        for s = 1:length(subj)
            cond  = subj(s).trial(:,2); % cond label
            label = subj(s).trial(:,3); % true answer
            resp  = subj(s).trial(:,4); % subj response
            rt   = subj(s).trial(:,5); % subject rt
                
            for c = 1:Nc
                idx   = cond == conds(c) & resp == label;
                if any(idx)
                    extremeval(c,s,1) = max(rt(idx));
                    extremeval(c,s,2) = min(rt(idx));
                end
            end
        end
        
        if plotFigure
            % detemine the cutoff for RT by visualization
            figure('Name','ExtremeRT')
            for c = 1:Nc
                maxval = extremeval(c,:,1);
                minval = extremeval(c,:,2);
                
                subplot(Nc,4,4*(c-1)+1),bar(maxval);title('Max RT');
                xlabel('trial ID'),ylabel('RT(s)')
                
                
                subplot(Nc,4,4*(c-1)+2),hist(maxval,1000);title('Max RT');
                xlabel('RT'),ylabel('Freq')
                
                subplot(Nc,4,4*(c-1)+3),bar(minval);title('Min RT');
                xlabel('trial ID'),ylabel('RT(s)')
                
                
                subplot(Nc,4,4*(c-1)+4),hist(minval,1000);title('Min RT');
                xlabel('RT'),ylabel('Freq')
                
            end
        end
    otherwise
        disp('Unknown Mode')
end


obj.extremeval = extremeval;



