function  plotSubjRT()
% data:

global STUDY

rawdata = STUDY.raw;
condname = STUDY.cond;


Nsubj = length(rawdata);
cond = unique(rawdata(1).trial(:,1));
Nc = length(cond);
Ntr = length(rawdata(1).trial(:,1));



colorspec = {'r','g','b','c','m','y','k','w',''};
rt = zeros(Nsubj,Ntr);

% plot RT of each subject
for s  = 1:Nsubj
    trial = rawdata(s).trial;
    rt(s,:) = trial(:,3);
    
    h = figure;
    hold on;
    
    for c = 1:Nc
        plot(trial(trial(:,1)==cond(c),3),sprintf('%so',colorspec{c}));
    end
    
    title(sprintf('%s',rawdata(s).subject.ID));
    legend(condname,'location','Best');
    hold off;
    pause;
    close(h);
end

figure,bar(rt),title('All RTs');


