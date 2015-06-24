function mergeRun(rawdatadir,mergeddir)
% mergeRun(rawdatadir,mergeddir)
% It has two function:  I)reform data structure, and assemble stimule, condtion and response
% information into a array, called trial. II) merge data from multiple runs into one file, and save it
% NOTE: in using the code, the user just need to modify this function to
% generate the standrized data structure.

% rawdir: dir for raw data
% mergedir: output dir for merged data
% trial(:,1), stimulus ID
% trial(:,2), cond label
% trial(:,3), true answer
% trial(:,4), subject answer
% trial(:,5), react time
% trial(:,6), run number

filelist = dir(fullfile(rawdatadir,'*.mat'));

nRun = 2; % number of run
idx = reshape(1:length(filelist),nRun,[])';
nSubj = size(idx,1);% number of subject

% task,
taskName = 'NUM_LOC';

% condtion
design1 = [ones(1,10), 2*ones(1,10),2*ones(1,10),ones(1,10),ones(1,10),2*ones(1,10)]';
design2 = [2*ones(1,10), ones(1,10),ones(1,10),2*ones(1,10),2*ones(1,10),ones(1,10)]';

% stimulus
stimID = zeros(60,1);



for i = 1:nSubj
    stim = [];
    cond = [];
    trueAnswer =[];
    subjAnswer = [];
    rt = [];
    run  = [];
        
    % merge runs and reformat data structure
    for j = 1:nRun
        D  = load(fullfile(rawdatadir,filelist(idx(i,j)).name));
        
        % stimulus ID
        stim = [stim;stimID];
        
        % condition label
        if D.design == 1
            d = design1;
        else
            d = design2;
        end
        cond = [cond;d];
        
        % true answer
        trueAnswer = [trueAnswer;D.corretAnswerQueue];
        
        % subj's answer
        subjAnswer = [subjAnswer;cell2mat(D.Response_all)];
        
        % subj's rt
        rt = [rt;cell2mat(D.RT_all)];
        
        % run ID
        run = [run;j*ones(length(stimID),1)];
    end  
    
    subj.name = D.subj;
    subj.taskName = taskName;       
    % assemble all information in trial
    subj.trial = [stim,cond,trueAnswer,subjAnswer,rt,run];
    
    % the merged data will be save into the mergeddir using the same name
    % as the file from the fist run
    fname = filelist(idx(i,1)).name;
    fprintf('%s\n', fname);
    save(fullfile(mergeddir,fname),'subj');
end