% G_SAMPLE: GUI module for signal sampling
%
% Usage: g_sample;
%
% Version: 1.0
%
% Description:
%              This graphical user interface module is used
%              to interactively investigate the sampling of
%              of analog signals. The effects of the sampling
%              rate, the anti-alising filter, and the ADC 
%              characteristics can be examined.
% Edit window:
%              n  = anti-aliasing filter order
%              Fc = anti-aliasing filter cutoff frequency
%              N  = ADC precision
%              Vr = ADC reference voltage
% Type window:
%              Constant input
%              Damped exponential input
%              Cosine input
%              Square wave input
%              User-defined input
% View window:
%              Time signals
%              Maginitude spectra
%              Filter magnitude response
%              ADC input-output characteristic
% Slider bar:
%              Sampling frequency: fs
% Menu bar:
%              Caliper option
%              Print option
%              Help option
%              Exit option
% See also: 
%              F_DSP G_RECONSTRUCT G_SYSTEM G_SPECTRA 
%              G_CORRELATE G_FILTERS G_FIR G_MULTIRATE
%              G_IIR G_ADAPT

% Programming notes:

% 1) Browsing for user.m file still has a few quirks.

% Check MATLAB Version

if (f_oldmat)
   return
end

% Initialize

clc
clear all
pv = 1;                   % plot view
xm = 4;                   % input signal selection
xm_old = xm;              % previous xm 
fs = 20;                  % sampling frequency
fs_min = 1;               % minimum sampling frequency
fs_max = 100;             % maximum sampling frequency
n = 4;                    % anti-aliasing filter order
n_min = 0;                % minimum anti-aliasing filter order
n_max = 16;               % maximum anti-aliasing fitler order
Fc = fs/4;                % anti-aliasing filter cutoff frequency
Fc_min = 1;               % minimum anti-aliasing filter cutoff frequency  
Fc_max = 20;              % maximum anti-aliasing filter cutoff frequency
N = 8;                    % ADC precision (bits)
N_min = 1;                % minimum ADC precision (bits)
N_max = 24;               % maximum ADC precision (bits)
Vr = 1.0;                 % ADC reference voltage
Vr_min = 0;               % minimum ADC reference voltage  
Vr_max = 100;             % maximum ADC reference voltage
white = [1 1 1];

% Strings

userinput = 'u_sample1';
plotstr = 'f_plotsamp (pv,han(6),hc_fs,xm,n,Fc,N,Vr,userinput,fsize); ';
barstr = 'f_showslider (hc_fs,han,fs,''Hz'',1); ';
inputstr = '';
g_module = 'g_sample';
drawstr = 'f_drawsamp (han(1),colors,fsize); ';

% Create figure window with tiled axes
 
[hf_1,han,pos,colors,fsize] = f_guifigure (g_module);

% Add menu options

f_calmenu (plotstr)
f_printmenu (han,drawstr)
f_helpmenu ('f_tipssamp',g_module)
f_exitmenu

% Draw block diagram

eval(drawstr)

% Edit boxes

axes (han(2))
hc_n = f_editbox (n,n_min,n_max,pos(2,:),2,1,1,colors(2,:),white,plotstr,'Filter order',fsize);
hc_Fc = f_editbox (Fc,Fc_min,Fc_max,pos(2,:),2,2,1,colors(2,:),white,plotstr,'Filter cutoff frequency',fsize);
hc_N = f_editbox (N,N_min,N_max,pos(2,:),2,1,2,colors(3,:),white,plotstr,'Number of bits',fsize);
hc_Vr = f_editbox (Vr,Vr_min,Vr_max,pos(2,:),2,2,2,colors(3,:),white,plotstr,'Reference voltage',fsize);

% Select input type

nt = 5;
msg = {'The M-file function u_fir1 is a function of (f,fs).  The user-defined',...
       'M-file function for g_sample must be a function of t. See files u_sample1',... 
       'and u_reconstruct1.m for examples.'};
labels = {'Constant','Damped exponential','Cosine','Square wave','User-defined'};
ustr = ['user = f_getfun (userinput,''Select user input function''); '...
        'if isequal(user,0), '...
        '   set (hc_type(xm),''Value'',0), '...
        '   set (hc_type(xm_old),''Value'',1), '...
        '   xm = xm_old; '...
        'else, '...
        '   userinput = user; '...
        '   xm_old = xm; '...
        'end; '...
        'user1 = lower(user); '...
        'if strcmp(user1,''u_fir1.m'') | strcmp(user1,''u_fir1''), '... 
        '   button = questdlg (msg,''User-defined M-file function warning'',''Ok'',''Ok''); '...   
        '   userinput = ''u_sample1''; '...    
        'end; '];
xstr = 'xm_old = xm;';
tipstrs = {'x_a(t) = 1','x_a(t) = exp(-t)','x_a(t) = cos(2*pi*t)',...
           'x_a(t) = sgn(sin(2*pi*t))','Compute x_a(t) with a user-defined function'};
cback = {[xstr plotstr],...
         [xstr plotstr],...
         [xstr plotstr],...
         [xstr plotstr],...
         [ustr plotstr]};
[hc_type,userinput] = f_typebuttons (pos(3,:),nt,xm,labels,colors(1,:),white,cback,userinput,tipstrs,nt,fsize);

% Select view

nv = 4;
labels = {'Time signals','Magnitude spectra','Magnitude response','ADC characteristic'};
fcolors = {colors(1,:),colors(1,:),colors(2,:),colors(3,:)};
tipstrs = {'Plot x_a(t),x_b(t),x(k)','Plot |X_a(f)|,|X_b(f)|,|X(f)|','Plot |H_a(f)|=|X_b(f)|/|X_a(f)|',...
           'Plot ADC quantization curve'};
cback ={plotstr,plotstr,plotstr,plotstr};
hc_view = f_viewbuttons (pos(4,:),nv,pv,labels,fcolors,white,cback,tipstrs,nv,fsize);

% Sampling frequency slider             

dv = 0;
tipstr = 'Adjust sampling frequency';
cback = [barstr plotstr];
hc_fs = f_slider (fs,fs_min,fs_max,pos(5,:),colors(2,:),'y',cback,tipstr,dv,'Hz',fsize);

% Create plot

eval (plotstr)
 