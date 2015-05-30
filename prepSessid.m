function  newidlist = prepsessid(idfile,opstr,idlist)
 % newidlist = prepsessid(idfile,opstr,idlist)
 % prepare sessid file for the study
 % idfile: text file which store the ID, every row is one ID
 % opstr: operation string: 'make','add','del'
 % idlist: IDs to be preprocessed(a Nx1 string cell array)


switch lower(opstr)
        
     case 'make'
        disp('Make ID File')
        newidlist = makeID(idfile,idlist);
    
    case 'add'
        disp('Add ID to ID File')
        newidlist = addID(idfile,idlist);
        
    case 'del'
        disp('Del ID from ID File')
        newidlist = delID(idfile,idlist);
        
    otherwise
        disp('Unknown Opstr.')
end


function  newidlist = makeID(idfile,idlist)
% Make idfile according the idlist
% idfile: name for sessid file which store the ID, every row is one ID
% idlist: ID to be deletd(a string cell array)


newidlist = idlist;

fid = fopen(idfile,'w+');
for i = 1:length(newidlist)
    fprintf(fid,'%s\n',newidlist{i})
end
fclose(fid);

function  newidlist = addID(idfile,idlist)
% Add idlist to the idfile
% idfile: text file which store the ID, every row is one ID
% idlist: ID to be added(a string cell array)

fid = fopen(idfile);
newidlist = textscan(fid,'%s');
newidlist = newidlist{1};
fclose(fid);

if size(idlist,1)==1
    idlist = idlist';
end

fid = fopen(idfile,'a+');
for i = 1:length(idlist)
    fprintf(fid,'%s\n',idlist{i});
end
fclose(fid);

newidlist = [newidlist;idlist];



function  newidlist = delID(idfile,idlist)
% Delete id in the idlist from the idfile
% idfile: text file which store the ID, every row is one ID
% idlist: ID to be deletd(a string cell array)

fid = fopen(idfile);
newidlist = textscan(fid,'%s');
newidlist = newidlist{1};
fclose(fid);


idx = zeros(length(newidlist),1);
for i = 1:length(idlist)
    for j = 1:length(newidlist)
        if strcmp(newidlist{j}, idlist{i})
            idx(j) = 1;
        end
    end
end


newidlist = newidlist(idx==0);

fid = fopen(idfile,'w+');
for i = 1:length(newidlist)
    fprintf(fid,'%s\n',newidlist{i})
end
fclose(fid);