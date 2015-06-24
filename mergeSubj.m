function  subj = mergeSubj(datadir)
% subj = mergeSubj(datadir)
% Merge data from all subjects to a structure array
%^datadir: dir for raw data, one file for each subject
% subj: a structure array for all subjects


filelist = dir(fullfile(datadir,'*.mat'));
nS = length(filelist);

for i = 1:nS
    D = load(fullfile(datadir,filelist(i).name));
    subj(i)  = D.subj;
end
