clear
% BAT code dir
codedir = 'D:\BAT';
addpath(codedir);

% parent dir for BAT study
pardir = 'D:\BAT';

% study dir for BAT study
studydir =fullfile(pardir,'study');


if ~exist(fullfile(studydir, 'SubjData.mat'),'file')
    % Merge subjdata into one structure
    % and save it to studydir
    
    rawdatadir = fullfile(pardir,'organized_num_data');
    mergeddir =  fullfile(pardir,'merged_num_data');
    if ~exist(mergeddir, 'dir')
        mkdir(mergeddir)
    end
    
    mergeRun(rawdatadir,mergeddir);
    
    subj = mergeSubj(mergeddir);
    save(fullfile(studydir, 'SubjData.mat'),'subj');
else
    % Label subjdata with MRI ID
    % load the data of interest of subjects
    % based on the idfile
    % rawmat = loadData([outfile,'.mat'],idfile);
    load(fullfile(studydir, 'SubjData.mat'));
end



% construct STUDY object
cond = {'Numerosity','Brightness'};
study = Study(studydir,'NUM LOC',cond,subj);



close all

% compute accurcy
study = study.accuracy(true);

% compute RT
 study  = study.RT(true);


% disp the extremeval of subj data
study = study.extremeRT('cond',true);


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



