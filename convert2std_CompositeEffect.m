function done = convert2std_CompositeEffect(sourDir,destDir,staNum,mode)
% done = convert2std(sourDir,destDir,staNum,mode)
%   sourDir --> data directory containing raw .mat file
%   destDir --> data directory where store standard .mat file
%   staNum  --> 测试起始编号
%   mode --> 0 -- just display the errors & choose a right result
%            1 -- convert result with interaction
%
%   ***ATTENTION : all the pathway MUST be the RELATIVE address***
%
% Example:
%   done = convert2std('raw','std',51,0)
%
% Edited by Huang Lijie, 2010-12-15
% Last Modified by Huang Lijie, 2011-02-26
%==========================================================================

% clear all

% configure evironment variable
eval(['!mkdir ',destDir]);
rootDir = pwd;
srcDir = strcat(rootDir,'\src');
libDir = strcat(rootDir,'\lib');
sourDir = strcat(rootDir,'\',sourDir);
destDir = strcat(rootDir,'\',destDir);
addpath(srcDir)
addpath(rootDir)

if mode == 0
    cd(sourDir)
    file = dir('*.mat');
    tempNum = 0;
elseif mode == 1
    load temp.mat
    cd(sourDir)
else
    sprintf('You enter a wrong mode parameter')
    return
end
fileNum = size(file);

% read config file

convertConfig=convertConfig_CompositeEffect;
templib = convertConfig;

% configure the lib path
subjLib = strcat(libDir,'\',templib.subjFile);
experLib = strcat(libDir,'\',templib.experFile);
connLib = strcat(libDir,'\',templib.connFile);
devLib = strcat(libDir,'\',templib.devFile);
notesLib = strcat(rootDir,'\',templib.notesFile);

% remove NAN in lib table
%---------------------------------------------------------
[num,txt,connIndex] = xlsread(connLib);
[mm nn] = size(connIndex);
for i = 1:mm
    for j = 1:nn
        if isnan(connIndex{i,j})
            connIndex{i,j} = '';
        end
    end
end
[num,txt,SubjIndex] = xlsread(subjLib);
[mm nn] = size(SubjIndex);
for i = 1:mm
    for j = 1:nn
        if isnan(SubjIndex{i,j})
            SubjIndex{i,j} = '';
        end
    end
end
[num,txt,experIndex] = xlsread(experLib);
[mm nn] = size(experIndex);
for i = 1:mm
    for j = 1:nn
        if isnan(experIndex{i,j})
            experIndex{i,j} = '';
        end
    end
end
[num,txt,noteIndex] = xlsread(notesLib);
[mm nn] = size(noteIndex);
for i = 1:mm
    for j = 1:nn
        if isnan(noteIndex{i,j})
            noteIndex{i,j} = '';
        end
    end
end
[num,txt,deviceIndex] = xlsread(devLib);
[mm nn] = size(deviceIndex);
for i = 1:mm
    for j = 1:nn
        if isnan(deviceIndex{i,j})
            deviceIndex{i,j} = '';
        end
    end
end
clear num txt mm nn

% input experimenter name
if mode == 0
    % input the experimenter name
    experNum = '2';%input('Input the number of experimenters:\n','s');
    while isempty(str2double(experNum))
        experNum = '2';% input('Input the number of experimenters:\n','s');
    end
    experNum = str2double(experNum);
    expindex = zeros(experNum,1);
    for j = 1:experNum
        fprintf('The name of experimenter No.%d in Chinese is\n',j)
        experName = input('','s');
        index = findExperIndex(experName, experIndex);
        while isempty(index)
            fprintf('You enter a wrong name, please input again\n')
            fprintf('The name of experimenter No.%d in Chinese',j)
            experName = input('is\n','s');
            index = findExperIndex(experName, experIndex);
        end
        expindex(j) = index;
    end
end

% read connFile to get index of typeID & objID
[m,n] = size(connIndex);
fsea = 0;
indexOfAll = 0;
for len = 1:m
    if strcmp(templib.designInfo.basic.ID,connIndex{len,3})
        indexOfAll = len;
        fsea = 1;
        break
    end
end
if fsea == 0
    fprintf('You enter a wrong designID, plsese check your config file')
    return
end

for i = 1:fileNum
    load(file(i).name)
    %======================================================
    % convert raw file to the std mat file
    %------------------------------------------------------
    % Subject's Information
    
    % Get subject's information from lib
    SubjName = lower(SubjectID);
    SubjGender = Gender;
    index = findSubjIndex('Pinyin', SubjName, SubjGender, SubjIndex, mode);
    if isempty(index)
        if mode == 0
            tempNum = tempNum + 1;
            tempFile(tempNum,1) = file(i);
            tempIndex(tempNum,1) = i;
        end
        continue
    else
        lsess.subject.ID = SubjIndex{index,1};      % format Sxxxx
        lsess.subject.name = SubjIndex{index,2};    % in Chinese
        lsess.subject.namePinyin = SubjIndex{index,3};
        lsess.subject.gender = SubjIndex{index,4};  % m/f
        lsess.subject.tel = SubjIndex{index,5};
        lsess.subject.L1_PIDNum = SubjIndex{index,6};
        lsess.subject.L2_PIDNum = SubjIndex{index,7};
        lsess.subject.email = SubjIndex{index,8};
        lsess.subject.major = SubjIndex{index,9};
        lsess.subject.school = SubjIndex{index,10};
        lsess.subject.nation = SubjIndex{index,11};
        lsess.subject.handness = SubjIndex{index,12};   % l->left, r->right
        lsess.subject.isMarried = SubjIndex{index,13};  % 0/1 -> N/Y
        lsess.subject.department = SubjIndex{index,14};
        birthDate_temp = cell2mat(SubjIndex(index,15));
        birthDate_temp = datevec(birthDate_temp);
        lsess.subject.birthDate = birthDate_temp(1:3);  % [yyyy mm dd]
        lsess.subject.birthPlace = '';
        lsess.subject.eduBackground = SubjIndex{index,16};
    end
    
    %------------------------------------------------------------
    % Experimeter's Information
    for j = 1:experNum
        lsess.experimenter(j).ID = experIndex{expindex(j),1};   % Exxx
        lsess.experimenter(j).name = experIndex{expindex(j),2};
        lsess.experimenter(j).gender = experIndex{expindex(j),3};  % m/f
        lsess.experimenter(j).PIDType = experIndex{expindex(j),8};
        lsess.experimenter(j).PIDNum = experIndex{expindex(j),9};
        lsess.experimenter(j).tel = experIndex{expindex(j),11};
        lsess.experimenter(j).position = experIndex{expindex(j),4};
        lsess.experimenter(j).projectGroup = experIndex{expindex(j),5};
        lsess.experimenter(j).major = experIndex{expindex(j),6};
        lsess.experimenter(j).nation = experIndex{expindex(j),7};
        lsess.experimenter(j).department = experIndex{expindex(j),10};
        lsess.experimenter(j).email = experIndex{expindex(j),12};
    end

    %----------------------------------------------------------
    % Device Information
    index = findDevIndex(templib.devName, deviceIndex);
    if ~isempty(index)
        lsess.device.ID = deviceIndex{index,1};       % format DVxxx
        lsess.device.name = deviceIndex{index,2};
        lsess.device.class = deviceIndex{index,3};
        lsess.device.deviceType = deviceIndex{index,4};
        lsess.device.parameter = deviceIndex{index,5};
        lsess.device.isVaild = deviceIndex{index,6};    %0/1
    end

    %---------------------------------------------------------
    % Experiment Design Information
    
    % basic information
    lsess.designInfo.basic.ID = templib.designInfo.basic.ID;
    lsess.designInfo.basic.name = templib.designInfo.basic.name;
    lsess.designInfo.basic.group = templib.designInfo.basic.group;
    lsess.designInfo.basic.progammeID = ...
        templib.designInfo.basic.progammeID;
    lsess.designInfo.basic.designer = ...
        templib.designInfo.basic.designer;
    lsess.designInfo.basic.programmer = ...
        templib.designInfo.basic.programmer;
    lsess.designInfo.basic.designDate = ...
        templib.designInfo.basic.designDate;
    lsess.designInfo.basic.designReference = ...
        templib.designInfo.basic.designReference;
    
    % Experiment Type
    lsess.designInfo.type.ID = connIndex{indexOfAll,6};      % format ETxxx
    lsess.designInfo.type.type = connIndex{indexOfAll,8};
    lsess.designInfo.type.parentID = connIndex{indexOfAll,7};
    
    % Experiment Objective
    lsess.designInfo.objective.ID = connIndex{indexOfAll,4};
    lsess.designInfo.objective.parentID = connIndex{indexOfAll,5};
    
    % Configuration
    %----------------------------------------------------------------------
    % Notes: Some configuration variables, used during test, can be stored
    %        there.
    lsess.designInfo.config.softName = templib.designInfo.config.softName;
    lsess.designInfo.config.softVer = templib.designInfo.config.softVer;
    lsess.designInfo.config.PTBVer = templib.designInfo.config.PTBVer;
    %----------------------------------------------------------------------
    
    %---------------------------------------------------------
    % Test Information
    
    % search the notes
    [m,n] = size(noteIndex);
    for len = 1:m
        if strcmp(lsess.subject.ID,noteIndex{len,1})
            lsess.testInfo.notes = noteIndex{len,4};
            break
        else
            lsess.testInfo.notes = '';
        end
    end
    
    % make testID
    testIDHead = strcat('T',templib.designInfo.basic.ID(2:4));
    if mode == 1
        testNum = tempIndex(i) + staNum - 1;
    else
        testNum = i + staNum - 1;
    end
    [m,n] = size(num2str(testNum)');
    switch m
        case 1
            str0 = '000';
        case 2
            str0 = '00';
        case 3
            str0 = '0';
        otherwise
            str0 = '';
    end
    lsess.testInfo.ID = strcat(testIDHead,str0,num2str(testNum));
    lsess.testInfo.group = templib.testInfo.group;
    lsess.testInfo.batch = templib.testInfo.batch;
	lsess.testInfo.testTimes = templib.testInfo.testTimes;
    lsess.testInfo.datafile = file(i).name;
    lsess.testInfo.location = templib.testInfo.location;
    
    %--------------------------------------------------------- 
    %---------------------------------------------------------
    % 需自己修改——从这里开始！
    
        % 屏幕刷新率(数值，e.g.[85])
        lsess.designInfo.config.refreshRate = [];
        
        % 屏幕分辨率(e.g., [1024 768])
        lsess.designInfo.config.resRate = screenRect(3:4);
        
        % 测试日期[xxxx xx xx]
        lsess.testInfo.date = [];
        
        % 实验持续时长 (按min计时)*******************************

%         lsess.testInfo.duration = (experimentDuration/60);
         lsess.testInfo.duration = (experimentDur/60);
        % Design & trial information
        % 此处参照PPT中对于标准.mat的说明填写，一定要double check，以防出错
        % condition (from_trialQueue(:,2)_colume 1)

        [trialNum,junk] = size(trialQ2);
        index_align_same = [];
        index_align_different = [];
        index_misalign_same = [];
        index_misalign_different = [];
        for j = 1:trialNum
            if trialQ2(j,2)<=12;
                condition(j) = 1;
                index_align_same = [index_align_same j];
            elseif trialQ2(j,2)>=13 && trialQ2(j,2)<=16;
                condition(j) = 2;
                index_align_different = [index_align_different j];
            elseif trialQ2(j,2)>=17 && trialQ2(j,2)<=20;
                condition(j)= 3;
                index_misalign_same = [index_misalign_same j];
            elseif trialQ2(j,2)>=21 && trialQ2(j,2)<=24;
                condition(j) = 4;
                index_misalign_different = [index_misalign_different j];
            end
            lsess.trial{j,1} = condition(j);
        end
        %          ACC
        % colume 4 of trialQ2: anticipated answer
        index_same = [index_align_same index_misalign_same];
        index_different = [index_align_different index_misalign_different];
        trialQ2(index_same,4) = 1;
        trialQ2(index_different,4) = 2;
        
        for j = 1:trialNum
            if trialQ2(j,4) == key(j,1)
                answerQ(j,1) = 1;
            else
                answerQ(j,1) = 0;
            end
            lsess.trial{j,2} = answerQ(j,1);
            lsess.trial{j,3} =RT(j);
        end
 
        
        % RT (colume 3)

            
%         end

%             % condition (colume 1)
%             if design(j,2) == 3
%                 condition = 1;
%             elseif design(j,2) == 6
%                 condition = 2;
%             end
%             lsess.trial{j,1} = condition;
% 
%             % accuracy (colume 2)
%             
%                 acc_array = zeros(1,8); 
%                 
%                 % Save resonse info
%                 acc_array(1:4) = [resultArray{j,3}(1,[1 3]),resultArray{j,3}(2,[1 3])];
%                     % colume 1: assumed response on T1
%                     % colume 2: actual response on T1
%                     % colume 3: assumed response on T2
%                     % colume 4: actual response on T2
% 
% %                 % Exact order    
% %                 acc_array(5) = ((acc_array(1))==(acc_array(2))); % T1
% %                 acc_array(6) = ((acc_array(3))==(acc_array(4))); % T2
% % 
% %                 % Igore order
% %                 acc_array(7) = (acc_array(1)==acc_array(2) | acc_array(1)==acc_array(4)); % T1
% %                 acc_array(8) = (acc_array(3)==acc_array(2) | acc_array(3)==acc_array(4)); % T2
%             
%                 lsess.trial{j,2} = acc_array;
%             
%             % RT (colume 3)
%             lsess.trial{j,3} = [];
%             
%         end
    
        % 保存一些关于的原始变量(Design的信息、原始的反应记录、程序运行完后初步计算出的Effect)
        % 变量名与原始.mat文件完全同名
        % Example: lsess.rawVariable.XXX = XXX ("XXX"为原始.mat中的变量名)
        lsess.rawVariable.design = whichDesign;
        lsess.rawVariable.Queue = trialQ2;
        lsess.rawVariable.anslist = key;
        lsess.rawVariable.correctNum = correctNum;
    
    % 需自己修改——到此为止！
    %--------------------------------------------------------- 
    %--------------------------------------------------------- 
    
    % save the std mat file
    subdir = strcat(destDir,'\',lsess.testInfo.ID);
    mkdir(subdir)
    desstr = strcat(subdir,'\',lsess.subject.namePinyin,'_raw.mat');
    copyfile(file(i).name,desstr);
    cd(subdir)

    convDate = datestr(clock,'yyyymmdd');
    strname = strcat(lsess.subject.namePinyin,'_',...
                     convDate,'_',...
                     lsess.designInfo.basic.name,'_std.mat');
    save(strname,'lsess')
    clear lsess
    cd(sourDir)
end

cd(rootDir);
if mode == 0
    if tempNum ~= 0
        file = tempFile;
        save temp.mat file tempIndex expindex experNum
    end
else
    delete temp.mat
end

if mode == 1
    temp_filename = findTestID (destDir);
    tpN = length(temp_filename);
    DIETList = temp_filename(3:tpN,1);
    save importList.mat DIETList
end

done = 1;