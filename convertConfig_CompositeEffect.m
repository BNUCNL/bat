function temp = convertConfig_CompositeEffect()
% a config file of converter
%
% Edited by Huang Lijie, 2010-01-13
% Last Modified by Huang Lijie, 2011-02-14
%==========================================================================

%% 库文件名设定
%---------------------------------------------------
% 被试信息表
temp.subjFile = 'subject.xlsx';
% 主试信息表
temp.experFile = 'experimenter.xlsx';
% 实验设计-类型-目的关联表
temp.connFile = 'ID.reference.new.xlsx';
% 设备信息表
temp.devFile = 'device.xlsx';
% 主试记录信息
temp.notesFile = 'AttentionBlink.notes.xlsx';

%% 实验设计信息 - 具体信息请根据变量名在数据字典中查询
%------------------------------------------------------
% 实验设计编号 - format 'Dxxx'
temp.designInfo.basic.ID = 'D019';
% 实验设计名称
temp.designInfo.basic.name = 'Composite';
% 实验设计组别
temp.designInfo.basic.group = '';
% 实验程序名称
temp.designInfo.basic.progammeID = '****.m';
% 实验设计人
temp.designInfo.basic.designer = '李小白、朱棋';
% 编程人
temp.designInfo.basic.programmer = '徐睿';
% 实验设计日期 - format [yyyy mm dd]
temp.designInfo.basic.designDate = [2010 02 24];
% 参考文献
temp.designInfo.basic.designReference = ...
         '2004-Le Grand-Impairment in holistic face processing following early visual deprivation';
% 使用软件名称
temp.designInfo.config.softName = 'Matlab';
% 软件版本 - format [7.1]
temp.designInfo.config.softVer = '7.1';
% PTB版本
temp.designInfo.config.PTBVer = '2.54';

%% 测试信息
%-----------------------------------------------------------------------
% 测试组别
temp.testInfo.group = '';
% 测试批次
temp.testInfo.batch = 1;
% 测试地点
temp.testInfo.location = '脑成像中心二层行为室';
% 单个被试测试次数
% NOTE : 也许需要针对每个被试单独修改
temp.testInfo.testTimes = 1;

%% 设备信息
temp.devName = 'PC_Unkown';
