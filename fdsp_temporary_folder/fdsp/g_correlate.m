% G_CORRELATE: GUI module for convolution and correlation
%
% Usage: g_correlate
%
% Version: 1.0
%
% Description:
%              This graphical user interface module is used
%              to interactively investigate convolution, 
%              cross-correlation, and auto-correlation.  
%              Both linear and circular convolutions and 
%              correlations can be performed.
% Edit window:
%              L = length of input x
%              M = length of input y
%              c = scale factor for y in white noise x
% Pushbuttons:
%              Play x as sound
%              Play y as sound
% Checkboxes:
%              Circular convolution or correlation
%              Normalized correlation
% Type window:
%              White noise inputs
%              Periodic inputs
%              Impulse train input y
%              Record x and y
%              User-defined inputs
% View window:
%              Inputs x and y
%              Convolution
%              Cross-correlation
%              Auto-correlation of x
%              Power density spectrum
% Slider bar:
%              Delay d of y in white noise x
% Menu bar:
%              Save option: x,y,a,b,fs 
%              Caliper option
%              Print option
%              Help option
%              Exit option
% See also: 
%              F_DSP G_SAMPLE G_RECONSTRUCT G_SYSTEM 
%              G_SPECTRA G_FILTERS G_FIR G_MULTIRATE 
%              G_IIR G_ADAPT

% Programming notes:

% 1. Put in a Settings menu option?
% 2. Add and editing feature (with mouse) so parts of $x$ can be played on speaker.
% 3. Extract periodic input (enter period?)

% Check MATLAB Version

if (f_oldmat)
   return
end

% Initialize

clc
clear all
xm = 1;                   % input signal selection
xm_old = xm;              % previous value of xm 
pv = 3;                   % plot view
L = 4096;                 % length of x
M = 2048;                 % length of y
c = 0.5;                  % attentuation of y in x
d = L/4;                  % delay of y in x
circ = 0;                 % 1 = circular correlation or convolution
norm = 1;                 % 1 = normalized correlation
L_min = 8;                % mininum length of x
L_max = 16384;            % maximum length of x
M_min = 2;                % minimum length of y
d_min = 0;                % minimum delay of y as component of x
d_max = L;                % maximum delay of y as component of x
c_min = -10;              % minimum scale factor for y
c_max = 10;               % maximum scale factor for y
fs = 8192;                % sampling frequency
fs_min = 1;
fs_max = 16000;
T = 1/fs;
rand ('state',1000);      % seed random number generator
white = [1 1 1];
b = 1 ./ [1 : 10];
a = 1;

% Strings                          
                          
userinput = 'u_correlate1.mat';       % default MAT file containing user-defined x,y,fs
plotstr   = 'f_plotcorr (pv,han,x,y,hc_circ,hc_norm,xm,userinput,fs,fsize); ';
inputstr  = '[x,y,L,M,userinput,fs,xm,xm_old] = f_getcorr (xm,xm_old,L,M,L_max,c,d,x,y,userinput,fs,hc_type); ';
barstr    = 'f_showslider (hc_d,han,d,'''',1); ';
drawstr   = 'f_drawcorr (han(1),colors,circ,norm,pv,fsize); ';
g_module  = 'g_correlate';

% Create figure window with tiled axes
 
[hf_1,han,pos,colors,fsize] = f_guifigure (g_module);

% Add menu options

hm_save = f_savemenu (userinput,'','Save data');
f_calmenu (plotstr)
f_printmenu (han,drawstr) 
f_helpmenu ('f_tipscorr',g_module)
f_exitmenu

% Draw block diagram

eval(drawstr)

% Edit boxes

axes (han(2))
cback =  [inputstr plotstr];
  
hc_L  = f_editbox (L,L_min,L_max,pos(2,:),3,1,1,colors(1,:),white,cback,'Length of x',fsize);
hc_M  = f_editbox (M,M_min,L,pos(2,:),3,2,1,colors(2,:),white,cback,'Length of y',fsize);
hc_c  = f_editbox (c,c_min,c_max,pos(2,:),3,3,1,colors(3,:),white,cback,'Scale factor',fsize);
hc_fs = f_editbox (fs,fs_min,fs_max,pos(2,:),3,1,2,colors(1,:),white,cback,'Sampling frequency',fsize);

% Push buttons

axes (han(2))
pushxstr = ['soundsc(x(1:L),fs);'...
           'tau = L/fs + .5;'...
           'tic; while toc < tau end;'];
hc_pushx = f_pushbutton (pos(2,:),3,2,2,2,'Play x as sound',colors(1,:),white,pushxstr,'Play x on PC speaker',fsize);
pushystr = ['soundsc(y(1:M),fs);'...
           'tau = M/fs + .5;'...
           'tic; while toc < tau end;'];
hc_pushy = f_pushbutton (pos(2,:),3,2,3,2,'Play y as sound',colors(2,:),white,pushystr,'Play y on PC speaker',fsize);

% Select input type

nt = 5;
labels = {'White noise','Periodic','Impulse train','Record x and y','User-defined'};
estr = ['str_L = [''L = '' mat2str(L) '';''];'...
        'set(hc_L,''String'',str_L);'...
        'str_M = [''M = '' mat2str(M) '';''];'...
        'set(hc_M,''String'',str_M); '...
        'str_fs = [''fs = '' mat2str(fs) '';''];'...
        'set(hc_fs,''String'',str_fs); '...
        'f_showslider (hc_d,han,d,'''',0); '];
fstr = ['if xm <= 3, '...
            barstr ...
        'else, ' ...
            estr ...
        'end; '];
tipstrs = {'x(k) = v(k) + c*y(k-d)','x(k) and y(k) periodic','x(k) periodic, y(k) impulse train',...
           'Record 2 seconds of x(k)','Record 0.5 seconds of y(k)','Load x,y,fs'};
cback = {[inputstr fstr plotstr],...
         [inputstr fstr plotstr],...
         [inputstr fstr plotstr],...
         [inputstr fstr plotstr],...
         [inputstr fstr plotstr]};       
[hc_type,userinput] = f_typebuttons (pos(3,:),nt,xm,labels,colors(1,:),white,cback,userinput,tipstrs,nt+1,fsize);

% Select view

nv = 5;
labels = {'Inputs x and y','Convolution','Cross-correlation','Auto-correlation','Power density spectrum'};
cback1 = [drawstr plotstr];
cback = {plotstr,cback1,cback1,cback1,cback1};
fcolors = {colors(1,:),colors(3,:),colors(3,:),colors(3,:),colors(3,:)};
tipstrs = {'Plot x(k) and y(k)','Plot convolution of x(k) with y(k)',...
           'Plot correlation of x(k) with y(k)','Plot auto-correlation of x(k)',...
           'Plot power density spectrum of x(k)'};
hc_view = f_viewbuttons (pos(4,:),nv,pv,labels,fcolors,white,cback,tipstrs,nv+1,fsize);


% Check boxes

hc_circ  = f_checkbox (circ,pos(3,:),nt+1,1,nt+1,1,'Circular',colors(2,:),...
                       white,[drawstr plotstr],'Toggle circular-linear',fsize);
hc_norm  = f_checkbox (norm,pos(4,:),nv+1,1,nv+1,1,'Normalized',colors(2,:),...
                       white,[drawstr plotstr],'Toggle normalized',fsize);

% Number of samples of delay slider             

dv = 0;
tipstr = 'Adjust delay of y in x';
cback = [inputstr barstr plotstr];
hc_d = f_slider (d,d_min,d_max,pos(5,:),colors(2,:),'y',cback,tipstr,dv,'',fsize);

% Create plot

x = zeros(L,1);
y = zeros(M,1);
eval (inputstr)
eval (plotstr)
 