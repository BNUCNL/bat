clear
% BAT code dir
codedir = 'D:\BAT';
addpath(codedir);

% parent dir for BAT study
pardir = 'D:\BAT';

% study dir for BAT study
studydir =fullfile(pardir,'study');



if ~exist(fullfile(studydir, 'reformSubjData'),'file')
    % Merge subjdata into one structure
    % and save it to studydir
    rawdatadir = fullfile(pardir,'organized_tom_data');
    mergeddir =  fullfile(pardir,'merged_tom_data');
    mergeSubjRun(rawdatadir,mergeddir);
    
    subj = reformSubjData(mergeddir);
    save(fullfile(studydir, 'reformSubjData'),'subj');
else
    % Label subjdata with MRI ID
    % load the data of interest of subjects
    % based on the idfile
    % rawmat = loadData([outfile,'.mat'],idfile);
    subj = load(fullfile(studydir, 'reformSubjData.mat'));
end



% construct STUDY object
cond = {'False Belief','Physical Reality'};
study = Study(studydir,'TOM LOC',cond,subj);



close all

% % compute accurcy
% study = study.accuracy(true);

% compute RT
% study  = study.RT();


% disp the extremeval of subj data
% study = study.extremeRT('cond');


% study.plotSubjRT()

%
% % delete trial acording the cutoff
% [study,stats] = study.delTrial([1,6]);


%
% % disp the extremeval disp after remove ouliter
% extremeval = study.extremeRT('all');




% %%  reliability
nrep = 10;
[rmean,rstd] = study.splitHalfReliability('rt','Pearson',nrep);
squeeze(rmean);



