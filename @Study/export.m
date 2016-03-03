function export(obj,fileName,format)
% export(obj,fileName, format)
% The method export ACC and RT to text file.
% fileName: file name for output
% format: xls or txt

if nargin < 3
    format = 'xls';
end

[pathstr,fname] = fileparts(fileName);

subj = obj.subj;
acc = obj.acc;
rt = obj.rt;
nSubj = length(subj);
if strcmp(format, 'xls')
    nspid = cell(nSubj,1);
    nspname = nspid;
    for i = 1:nSubj
        nspid{i} = subj(i).NSPID;
        nspname{i} = subj(i).name;
    end
    
    fileName = fullfile(pathstr,sprintf('%s.xlsx',fname));
    xlswrite(fileName,[{'NAME'},{'NSPID'},{'ACC'},{'RT'}],1,'A1');
    xlswrite(fileName,[nspname,nspid],1,'A2');
    xlswrite(fileName,[acc,rt],1,'C2');
    
elseif strcmp(format,'txt')
    fileName = fullfile(pathstr,sprintf('%s.txt',fname));
    fid = fopen(fileName,'w');
    fprintf(fid,'%s\t%s\t%s\t%s\n','Name','NSPID','ACC','RT');
    for i = 1:length(subj)
        fprintf(fid,'%s\t%s\t%.4f\t%.4f\n',subj(i).name,subj(i).NSPID,acc(i),rt(i));
    end
    fclose(fid);
else
    error('Wrong Format.Only support xls or txt');
end