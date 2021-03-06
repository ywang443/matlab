function [x,y,N,fs,user,xm,xm_old] = getspec (xm,xm_old,N,N_max,fs,fa,a,b,c,d,h_noise,h_clip,x,user,hc_type);

%F_GETSPEC: Compute input for GUI module G_SPECTRA
%
% Usage: [x,y,N,fs,user,xm,xm_old] = getspec (xm,xm_old,N,N_max,fs,fa,a,b,c,d,hc_noise,h_clip,x,user,hc_type);
%
% Inputs: 
%         xm    = type of input (1 to 5)
%
%                 1 = white noise
%                 2 = cosine 
%                 3 = pulse 
%                 4 = recorded sound
%                 5 = user input 
%
%         xm      = previous value of xm
%         N       = number of samples
%         N_max   = maximum number of samples
%         fs      = sampling frequency
%         fa      = frequency of cosine input
%         a       = filter denominator coefficients
%         b       = filter numerator coefficients
%         c       = bound on uniform white noise [-c,d]
%         d       = clipping threshold
%         h_noise = additive noise checkbox handle.  If noise <> 0, add noise
%         h_clip  = clipping mode checkbox handle.  If clp <> 0, clip input to [-c,c]
%         x       = an array of length n containing original samples
%         user    = string containing name of default MAT-file for 
%                   user input
%         hc_type = array of handles for input type radio buttons
% Outputs: 
%          x      = N by 1 array of input samples
%          y      = N by 1 array of output samples
%          N      = number of samples
%          fs     = sampling frequency
%          user   = string containing name of MAT-file for user-defined
%                   input
%          xm     = input type
%          xm_old = previous value of xm  

% Initialize

noise = get (h_noise,'Value');
clip = get (h_clip,'Value');
k = [0 : N-1]';
T = 1/fs;

switch (xm)
   
case 1,                                           % white noise
    
   x = f_randu (N,1,-1,1);
   
case 2,                                           % cosine
   
   x =  cos(2*pi*fa*k*T);
   
case 3,                                          % exponential
   
   x = exp(-4*k/N);
      
case 4,                                          % record sound
   
  tau = 8192/8000; 
  [x,N,xm,fs] = f_record (x,N,tau,fs,xm,xm_old,hc_type);
    
case 5,                                          % user defined

   caption = 'Select MAT-file containing x,fs';
   [user1,path] = f_getmatfile (caption,user);
   if user1 ~= 0
       user = user1;
       old_path = pwd;
       cd (path);
       load (user,'x','fs')
       cd (old_path)
   else
       set (hc_type(xm),'Value',0)
       set (hc_type(xm_old),'Value',1)
       xm = xm_old;
   end

end

% Check x

x = f_tocol(x);
N = length(x);
if N > N_max
    x(N_max+1:N) = [];
    N = N_max;
end

% Add noise

if noise  
   x = x - c + 2*c*rand(N,1);        % white noise
end

% Perform clipping

if clip
   x = f_clip(x,-d,d);
end

% Update xm and compute output (for Save)

xm_old = xm;
y = filter (b,a,x); 