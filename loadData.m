function  targmat = loadData(mergematfile,idfile)
% Load targmat according to the idfile

global STUDY

% % read data
allmat = load(mergematfile);
allmat = allmat.allmat;



fid = fopen(idfile);
idlist = textscan(fid,'%s');
idlist = idlist{1};
fclose(fid);


idx = zeros(length(allmat),1);
for i = 1:length(idlist)
    for j = 1:length(allmat)
        if strcmp(allmat(j).subject.ID, idlist{i})
            idx(j) = 1;
        end
    end
end

targmat = allmat(idx==1);

STUDY.ids = idlist;
STUDY.raw =  targmat;
STUDY.mat = mergematfile;
