function  subjnorm = normSubjData(subjraw)
% Normalize individual subject data
% subjdata: A structure keeping the data for a subject
% trial(:,1), stimulus ID
% trial(:,2), cond label
% trial(:,3), true answer
% trial(:,4), subject answer
% trial(:,5), react time

subjnorm.name = subjraw.subj;
subjnorm.trial(:,1:2) = subjraw.TrialQueue;
subjnorm.trial(:,3) =  subjraw.TrialQueue(:,2);
subjnorm.trial(:,4) = subjraw.Response;
subjnorm.trial(:,5) = subjraw.RT;
