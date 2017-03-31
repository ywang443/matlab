function [k,solution_ps,solution_pdf] = f_checkcd

%F_checkcd: Check to see if the the solutions CD is available
%
% Usage: [k,solution_ps,solution_pdf] = f_checkcd
%
% Outputs: 
%          k            = nonzero if CD containing homework 
%                         solutions was found and added to path
%          soluiton_ps  = string containing path to ps solutions
%          soluiton_pdf = string containing path to pdf solutions


% Initialize

k = 0;
drives = {'A','B','C','D','E','F','G','H','I','J','K','L','M',...
          'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}; 
pstr = {'The homework builder module, g_homework, uses the FDSP',...
        'Instructor''s CD to display solutions. Place the CD in a drive,',...
        'close the drive door, and then select the drive letter.'};

% Check for CD   
   
cd_drive = getpref('FDSP_preferences','CD_drive');
solution_path = [cd_drive filesep 'solutions'];
cd_found = exist ([cd_drive 'solutions']);
if ~cd_found
    [select,ok] = listdlg ('ListString',drives,...
                          'PromptString',pstr,...
                          'InitialValue',5,...
                          'ListSize',[300 300],...
                          'SelectionMode','single',...
                          'Name','CD Drive Request');
    if ok
        cd_drive = [drives{select} ':'];
        setpref ('FDSP_preferences','CD_drive',cd_drive)
        solution_path = [cd_drive filesep 'solutions'];
        fprintf ('Waiting for CD drive ...\n')
    end
end
    
% Add solutions folder to path

cd_found = exist ([cd_drive 'solutions']);
solution_ps  = [solution_path filesep 'ps'];
solution_pdf = [solution_path filesep 'pdf'];
warning off
   path (path,solution_ps)
   path (path,solution_pdf)
warning on
k = cd_found;
 