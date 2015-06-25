function obj = matchID(obj,subjIDfile)
% matchID(obj,subjIDfile)
% The method find MRI ID(mID) for each subject
% based on behavior ID(bID)
% subjIDfile: subject ID file

[~,txt] = xlsread(subjIDfile);
mID = txt(:,1);
bID = txt(:,3);

subj = obj.subj;
nSubj = length(subj);

for s = 1:nSubj
    id = [];
    for i = 1:length(bID)
        if strcmp(subj(s).name,bID(i))
            id = [id,mID{i}];
        end
        subj(s).mID = id;
    end
end

obj.subj = subj;


