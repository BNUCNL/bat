%% The main script to process data with BAT

clear
close all

% BAT code dir
codedir = 'D:\BAT';
addpath(codedir);

% parent dir for BAT study
pardir = 'D:\BAT';

% study dir for BAT study
studydir =fullfile(pardir,'study');
if exist(fullfile(studydir, 'SubjData.mat'),'file')
    load(fullfile(studydir, 'SubjData.mat'));
else
    error('SubjData is not existed.');
end

% construct STUDY object
cond = {'Numerosity','Brightness','Total'};
study = Study(studydir,'NUM_LOC',cond,subj);

close all
% compute accurcy
study = study.accuracy(true);
% delete outlier subject according to ACC
study = study.delSubjOutlier('IQR',2,'ACC',true);

close all
% compute RT
study = study.RT(true);
% delete subject according to mean RT
study = study.delSubjOutlier('ABS',[0.5,1.2],'RT',true);

close all
% delete outlier trials according to RT
[study,stats] = study.delTrialOutlier('IQR',2);

%% polt RT distribution for each subject
% study.plotSubjRT()

% recompute ACC and RT after remove bad subjects and bad trials
close all
study = study.accuracy(true);
study = study.RT(true);

% calculate split-half reliability
nrep = 1000;
contrast = [1 -1 0];
[rAcc,rRT] = study.splitHalfReliability(contrast,'Pearson',nrep);

% find MRI ID for each subject
subjIDfile = 'D:\BAA\SUBJDEMO\allSubjID.xlsx';
study = study.matchID(subjIDfile);

% export ACC and RT to a text file
outFile = fullfile(studydir, sprintf('new%s.txt',study.name));
study.export(outFile);


% % disp the extremeval of subj data
% study = study.extremeRT('cond',true);

% % % disp the extremeval disp after remove ouliter
% extremeval = study.extremeRT('all');



