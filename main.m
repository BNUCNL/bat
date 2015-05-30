clear
pardir = 'D:\CFE';
studydir =fullfile(pardir,'study');
codedir = 'D:\behavior';
rawdatadir = fullfile(pardir,'std_CFE');
datadir = fullfile(studydir,'data');
cd(codedir);


global STUDY;

condname = {'alignsame','aligndiff','misalignsame','misaligndiff'};
Ncond = length(condname);

STUDY.cond = condname;


% prepare sessid
idfile = fullfile(datadir,'sessid.txt');
% idlist = {'S0250','S0332','S0029'};
% newidlist = prepsessid(idfile,'add',idlist);

% merge data from all subjects
outfile = fullfile(studydir,'data','std_CFE');
% mergedata(rawdatadir,outfile);



% load the data of interest of subjects 
% based on the idfile
rawmat = loaddata([outfile,'.mat'],idfile);

Nsubj = length(rawmat);

% plotSubjRT()


% disp the extremeval of rawmat
extremeval = extremeRT('all');




% estimate the acc and RT for rawmat
rawRT  = estimateRT();
rawacc = estimateAccuracy();


% delete trial acording the cutoff
[newmat,stats] = delTrial(rawmat,[0.2,6]);


% disp the extremeval disp after remove ouliter
extremeval = extremeRT(newmat,'all');



% estimate the acc and RT for newmat
newRT = estimateRT();
newacc = estimateAccuracy();



%%  reliability 
repetition = 10;
[first_half,second_half] = split_half_trial(repetition);
[mean_corr,std_corr] = split_half_reliability('Pearson');

[mean_corr,std_corr] = split_half_reliability('Pearson',[1 0 -1 0]);


