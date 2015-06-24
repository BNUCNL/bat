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


if ~exist(fullfile(studydir, 'SubjData.mat'),'file')
    % Merge subjdata into one structure and save it to studydir
    
    rawdatadir = fullfile(pardir,'organized_num_data');
    mergeddir =  fullfile(pardir,'merged_num_data');
    if ~exist(mergeddir, 'dir')
        mkdir(mergeddir)
    end
    
    mergeRun(rawdatadir,mergeddir);
    
    subj = mergeSubj(mergeddir);
    save(fullfile(studydir, 'SubjData.mat'),'subj');
else
    
    load(fullfile(studydir, 'SubjData.mat'));
    % delete bad subjects at this point
    subj(78) = [];
end



% construct STUDY object
cond = {'Numerosity','Brightness','Total'};
study = Study(studydir,'NUM_LOC',cond,subj);


% compute accurcy
close all
study = study.accuracy(true);
study = study.delSubjOutlier('IQR',2,'ACC',true);



% compute RT
close all
study = study.RT(true);
study = study.delSubjOutlier('ABS',[0.5,1.2],'RT',true);



% delete trial acording the cutoff
close all
[study,stats] = study.delTrialOutlier('IQR',2);


% study.plotSubjRT()
close all
study = study.accuracy(true);
study = study.RT(true);


outFile = fullfile(studydir, sprintf('%s.txt',study.name));
study.export(outFile);



% % disp the extremeval of subj data
% study = study.extremeRT('cond',true); 
% % % disp the extremeval disp after remove ouliter
% extremeval = study.extremeRT('all');


% %%  reliability
% nrep = 10;
% [rmean,rstd] = study.splitHalfReliability('rt','Pearson',nrep);
% squeeze(rmean);



