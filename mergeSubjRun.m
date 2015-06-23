function mergeSubjRun(rawdatadir,mergeddir)
% Normalize individual subject data and then merge them
% rawdir: dir for raw data

filelist = dir(fullfile(rawdatadir,'*.mat'));

nR = 2; % number of run
idx = reshape(1:length(filelist),nR,[])';
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