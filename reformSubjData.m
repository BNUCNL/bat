function  subj = reformSubjData(datadir)
% subj = reformSubjData(datadir)
% reformat individual subject data from the megered file;
% for this, data structure is changed.
% subj: a structure keeping the data for a subject
% trial(:,1), stimulus ID
% trial(:,2), cond label
% trial(:,3), true answer
% trial(:,4), subject answer
% trial(:,5), react time
% trial(:,6), run number

filelist = dir(fullfile(datadir,'*.mat'));
nS = length(filelist);

for i = 1:nS
    subjraw  = load(fullfile(datadir,filelist(i).name));
    subjraw  = subjraw.subj;
    subj(i).name = subjraw.name;
    subj(i).trial(:,1:2) = subjraw.TrialQueue;
    subj(i).trial(:,3) =  subjraw.TrialQueue(:,2);
    subj(i).trial(:,4) = subjraw.Response;
    subj(i).trial(:,5) = subjraw.RT;
    subj(i).run(:,6) =  subjraw.run;
end
