%% The main script to prepare data with BAT

clear
close all

% BAT code dir
codedir = 'D:\BAT';
addpath(codedir);

% parent dir for BAT study
pardir = 'D:\BAT';

% study dir for BAT study
studydir =fullfile(pardir,'study');
if ~exist(studydir, 'dir')
    mkdir(studydir)
end

rawdatadir = fullfile(pardir,'organized_num_data');
mergeddir =  fullfile(pardir,'merged_num_data');
if ~exist(mergeddir, 'dir')
    mkdir(mergeddir)
end

% merge multiple runs from a single subjectd and save it to mergedir
mergeRun(rawdatadir,mergeddir);

% merge all subject data into a structure array(i.e., subj)
subj = mergeSubj(mergeddir);
% save merged data
save(fullfile(studydir, 'SubjData.mat'),'subj');


