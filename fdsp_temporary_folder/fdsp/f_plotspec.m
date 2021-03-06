function plotspec (pv,han,hc_N,fs,win,hc_dB,hc_clip,hc_noise,x,xm,user,fsize);

%F_PLOTSPEC: Plot selected view for GUI module G_SPECTRA
%
% Usage: pos = plotspec (pv,han,hc_N,fs,win,hc_dB,hc_clip,noise,x,xm,user,fsize)
%
% Inputs: 
%         pv       = view selection (1 to 6)
%         han      = array of axes handles
%         hc_N     = number of samples slider handle
%         fs       = sampling frequency edit box handle
%         win      = data window (0 to 3)
%         hc_dB    = decibel plot checkbox handle (0 = linear, 1 = dB)
%         hc_clip  = clipping checkbox handle (0 = no clipping, 1 = clipping)
%         hc_noise = additive noise checkbox handle (0 = no noise, 1 = noise)
%         x        = 1 by N vector of samples
%         xm       = input type (1 to 5)
%         user     = string containing name of MAT-file for user-
%                    defined input
%         fsize    = font size

% Initialize

dB = get (hc_dB,'Value');
clip = get (hc_clip,'Value');
noise = get (hc_noise,'Value');
N = get (hc_N(1),'Value');
f_ploterase (han)
axes (han(6))
axis on

eps = 1.e-10;
colors = get(gca,'ColorOrder');
T = 1/fs;
[A,phi,S,f] = f_spec (x,N,fs);
    
% Construct title

switch pv
    
    case 1, s1 = 'Time signal: ';
    case 2, s1 = 'Magnitude spectrum: ';
    case 3, s1 = 'Phase spectrum: ';
    case 4, s1 = 'Power density spectrum: ';
    case 5, s1 = 'Data window: ';
    case 6, s1 = 'Spectrogram: ';
        
end
 
switch xm
    
    case 1, s2 = 'uniform white noise input';
    case 2, s2 = 'cosine input';
    case 3, s2 = 'damped exponential input';
    case 4, s2 = 'recorded sound input';
    case 5,
        user1 = f_cleanstring (user);
        s2 = sprintf ('user-defined input from file %s',user1);
end

% Create title

if noise
    s2 = ['noise-corrupted ' s2];
end
if clip
    s2 = ['clipped ' s2];
end
title = [s1 s2];
if (pv == 4) | (pv == 6)
   switch (win)
       case 0, title = [title ' (Rectangular window)'];
       case 1, title = [title ' (Hanning window)'];
       case 2, title = [title ' (Hamming window)'];
       case 3, title = [title ' (Blackman window)'];
   end
end

% Compute and plot result   

switch (pv)
      
case 1,					% time signal
   
   t = linspace(0,(N-1)*T,N);
   plot (t,x(1:N),'Color',colors(1,:));
   y = get(gca,'Ylim');
   axis([0 N*T y(1) y(2)])
   f_labels (title,'t (sec)','x(t)','',fsize);
   
case 2,              % magnitude spectrum
   
   if dB
      A = 20*log10(max(A,eps));
   end
   plot (f(1:ceil(N/2)),A(1:ceil(N/2)),'Color',colors(3,:))
   if dB
      f_labels (title,'f (Hz)','A(f) (dB)','',fsize)
   else
      f_labels (title,'f (Hz)','A(f)','',fsize)
   end   
      
case 3,              % phase spectrum
   
   plot (f(1:N/2),phi(1:N/2),'Color',colors(3,:))
   f_labels (title,'f (Hz)','\phi(f)','',fsize)
   
case 4,              % power density spectrum
   
   L = min(floor(N/4),1024);
   N = 4*L;
   [S_W,f,Px] = f_pds (x,N,L,fs,win,1);
   if dB
      S_W = 10*log10(max(S_W,eps));
   end
   plot (f(1:ceil(L/2)),S_W(1:ceil(L/2)),'Color',colors(3,:))
   if dB
      f_labels (title,'f (Hz)','S_W(f) (dB)','',fsize)
   else
      f_labels (title,'f (Hz)','S_W(f)','',fsize)
   end
   
case 5,                   % data window
   
   L = N/8; 
   w = f_window(win,L);
   plot (0:L,w)
   switch win
       case 0, f_labels ('Rectangular window','k','w(k)','',fsize)
       case 1, f_labels ('Hanning window','k','w(k)','',fsize)
       case 2, f_labels ('Hamming window','k','w(k)','',fsize)
       case 3, f_labels ('Blackman window','k','w(k)','',fsize)
   end  
   
case 6,                  % spectrogram
   
   L = N/8;
   levels = 12;
   [G,f,t] = f_specgram (x(1:N),L,fs,win); 
   contour(f(1:L/2),t,G(:,1:L/2),levels)
   f_labels (title,'f (Hz)','t (sec)','',fsize)
   
end
