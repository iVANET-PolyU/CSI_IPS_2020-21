function [] = checkDir(maindir,targetdir,encreate)
%% Code checks whether the target directory exists.
% If it does not exist, either error or create.
% Prepared by Josyl Rocamora (HKPolyU 2020)

    if ~exist([maindir targetdir])
        fprintf('Directory "%s" does not exist!\n', [maindir targetdir]); 
        if encreate==1 
            fprintf('Creating folder...\n');
            mkdir(maindir,targetdir);  
        end
    end
    
end