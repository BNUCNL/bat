clear
pardir = 'D:\CFE';
studydir =fullfile(pardir,'study');
codedir = fullfile(studydir,'code');
rawdatadir = fullfile(pardir,'std_CFE');
datadir = fullfile(studydir,'data');
cd(codedir);

% prepare sessid
idfile = fullfile(datadir,'sessid.txt');
% idlist = {'S0250','S0332','S0029'};
% newidlist = addID(idfile,idlist);
% newidlist = delID(idfile,idlist);

% merge data from all subjects
 outfile = fullfile(studydir,'data','std_CFE');
% mergemat(datadir,outfile);



% load the data of interest of subjects 
% based on the idfile
rawmat = loaddata([outfile,'.mat'],idfile);

 
condname = {'alignsame','aligndiff','misalignsame','misaligndiff'};
Ncond = length(condname);

repetition = 10;
[first_half,second_half] = half_split_trial(repetition,rawmat);


reliability = split_corr(first_half,second_half,'Pearson');

figure,bar(reliability)


first_cfe  = first_half(:,:,3)-first_half(:,:,1);
second_cfe = second_half(:,:,3)-second_half(:,:,1);


cfe_reliability = split_corr(first_cfe,second_cfe,'Pearson')
figure,bar(cfe_reliability)


