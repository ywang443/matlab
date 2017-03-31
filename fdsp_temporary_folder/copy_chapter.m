function copy_chapter (k)

% COPY_CHAPTER: Copy files for chapter k to the appropriate FDSP directories.
%
% Inputs:
%         k = chapter number

clc
source = sprintf ('c:\\book4\\chap%d',k);
exam = 'c:\fdsp\examples';
fig  = 'c:\fdsp\figures';
prob = 'c:\fdsp\problems';
fdsptemp = 'c:\fdsptemp';

problems = [2, 10,16,22,26,32,32
            14,22,32,35,38,43,43
            7, 15,18,21,27,27,27
            5, 10,19,22,30,33,33
            2, 14,23,36,39,44,46
            4, 10,18,23,26,31,31
            3, 10,20,25,27,30,30
            10,16,26,33,40,43,43
            8, 16,25,30,34,39,39];

fprintf ('Copy FDSP files for chapter %d.',k)
f_wait

% copy example files

fprintf ('Copying example files for chapter %d ...\n',k);
copyfile ([source filesep 'exam\exam*.m'],exam)
try 
    copyfile ([source filesep 'exam\*.mat'],exam)
catch
end

% copy figure files

fprintf ('Copying figure files for chapter %d ...\n',k);
copyfile ([source filesep 'fig\fig*.m'],fig)
try
   copyfile ([source filesep 'fig\fig*.mat'],fig)
catch
end

% copy problem files

fprintf ('Copying problem files for chapter %d ...\n',k);
try
   probmat = sprintf ('prob\\prob%d_*.mat',k);
   copyfile ([source filesep probmat],prob)
   if k == 3
       copyfile ([source filesep 'prob\hello.mat'],prob)
   end
catch
end 
for i = 1 : length(problems(k,:))
    probi = sprintf ('prob%d_%d.pdf',k,problems(k,i));
    copyfile ([source filesep 'prob' filesep probi],prob)
end

try
   probm = sprintf ('prob\\prob%d_*.m',k);
   copyfile ([source filesep probm],fdsptemp)
   userm = sprintf ('prob\\u_*.m');
   copyfile ([source filesep userm],fdsptemp)
catch
end