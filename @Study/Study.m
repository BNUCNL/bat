classdef Study
    % Study for Behavior Data
    % raw: structure array for raw data from
    properties
        name
        wdir
        cond
        subj
        acc
        rt
    end
    
    
    methods
        function obj = Study(wdir,name,cond,subj)
            if nargin < 4, subj   = []; end
            if nargin < 3, cond  = []; end
            if nargin < 2, name  = []; end
            if nargin < 1, wdir  = []; end
            
            obj.wdir = wdir;
            obj.name  = name;
            obj.cond  = cond;
            obj.subj = subj;   
        end     
    end
end

