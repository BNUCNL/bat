function mergeSubjRun(rawdatadir,mergeddir)
% mergeSubjRun(rawdatadir,mergeddir)
% Merge all runs from a subject to the first run;
% the data structure remain the same, just as more trials 
% are conducted in the first run. 
% rawdatadir: dir for raw data which is separated for each run.
% mergeddir: dir to save the merged mat file

filelist = dir(fullfile(rawdatadir,'*.mat'));

nR = 2; % number of run for each subject
idx = reshape(1:length(filelist),nR,[])'; % index for each subject 
nS = size(idx,1);% number of subject


for i = 1:nS
    RT = [];
    Response = [];
    TrialQueue = [];
    acc = [];
    acq = [];
    experimentDur = [];
    run  =[];
    
    % merge runs
    for j = 1:nR
        D  = load(fullfile(rawdatadir,filelist(idx(i,j)).name));
        RT = [RT;D.RT];
        Response = [Response; D.Response];
        TrialQueue = [TrialQueue; D.TrialQueue];
        acc = [acc; D.acc];
        acq = [acq; D.acq];
        experimentDur = [experimentDur, D.experimentDur];
        run = [run;j*ones(length(D.RT),1)];
    end
    
    subj.name = D.subj;
    subj.taskName = D.taskName;
    subj.RT = RT;
    subj.Response = Response;
    subj.TrialQueue = TrialQueue;
    subj.acc = acc;
    subj.acq = acq;
    subj.experimentDur = experimentDur;
    subj.run = run;
    
    
    
    fname = filelist(idx(i,1)).name;
    fprintf('%s\n', fname);
    save(fullfile(mergeddir,fname),'subj');
end