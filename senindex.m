% [d_prime, c_bias] = senindex(reskey, actkey)
% For detail of d_prime and c_bias,please see http://openwetware.org/wiki/Beauchamp:dprime
% d_prime,c_bias: the d_prime and c_bias of each subject
% reskey : response key value of each subject
% actkey : the standard key value of each subject
% by HTC. 2016.1


function [d_prime,c_bias] = senindex( reskey,actkey )

% 1 as signals ,2 as noise
% So,hit = 1/1 , false alarm = 1/2
reskey_signal = reskey(actkey==1);
reskey_noise = reskey(actkey==2);
phit = (length(find(reskey_signal==1))+1)/(length(reskey_signal)+2);
pfalse = (length(find(reskey_noise==1))+1)/(length(reskey_noise)+2);
d_prime = norminv(phit,0,1) - norminv(pfalse,0,1);
c_bias = -(norminv(phit,0,1)+norminv(pfalse,0,1))/2;

end

