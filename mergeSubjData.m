function  subj = mergeSubjData(rawdatadir)
% Normalize individual subject data and then merge them
% rawdir: dir for raw data

filelist    = dir(fullfile(rawdatadir,'*.mat'));

for i = 1:length(filelist)
   subjdata = load(fullfile(rawdatadir,filelist(i).name));
   subj(i)  = normSubjData(subjdata);
end