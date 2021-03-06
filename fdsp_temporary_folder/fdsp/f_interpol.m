function [y,b] = f_interpol (x,fs,L,m,f_type,alpha)

%F_INTERPOL: Increase sampling rate by factor L.
%
% Usage: [y,b] = f_interpol (x,fs,L,m,f_type,alpha)
%
% Inputs: 
%         x     =  a vector of length P containing the input
%                  samples
%         fs     = sampling frequency of x
%         L      = an integer specifying the conversion 
%                  factor (L >= 1).
%         m      = the order of the lowpass FIR anti-
%                  aliasing anti-imaging filter. 
%         f_type = the FIR filer type to be used:
%
%                  0 = windowed (rectangular)
%                  1 = windowed (Hanning)
%                  2 = windowed (Hamming)
%                  3 = windowed (Blackman)
%                  4 = frequency-sampled
%                  5 = least-squares
%                  6 = equiripple
%
%          alpha = an optional scaling factor for the cutoff
%                  frequency of the FIR filter.  Default:
%                  alpha = 1.  If present, the cutoff 
%                  frequency used for the anti-imaging 
%                  filter H_0(z) is
%
%                  F_c = alpha*fs/(2L)
% Outputs: 
%          y   = a 1 by N vector containing the output 
%                samples. Here N = L*P.
%          b   = a 1 by (m+1) vector containing FIR filter
%                coefficients 
%
% Notes: If L is relatively large (e.g. 10 or higher),
%        then it is the responsibilty of the user to 
%        perform the rate conversion in stages using 
%        multiple calls to f_interpol.  Otherwise, 
%        the required value for m can be very large.
%
% See also: F_DECIMATE, F_RATECONV

% Initialize

L = f_clip (L,1,L);
M = 1;
m = f_clip (m,2,m);
m = 2*floor(m/2);
f_type = f_clip (f_type,0,6);
P = length (x);
T = 1/fs;

% Design lowpass FIR filter

if nargin < 6
    alpha = 1;
end
F_0 = alpha*fs/(2*L);
p = [0,F_0,F_0,0];
sym = 0;
switch f_type
    
    case {0,1,2,3},
        sym = 0;
        win = f_type;
        b = f_firideal (0,F_0,m,fs,win);        
    case 4,
        q = floor(m/2)+1;
        F = linspace (0,fs/2,q);
        A = f_firamp (F,fs,p);
        b = f_firsamp (A,m,fs,sym);
    case 5,
        q = 2*m;
        F = linspace (0,fs/2,q);
        A = f_firamp (F,fs,p);
        b = f_firls (F,A,m,fs);
    case 6,
        F_p = F_0;
        F_s = F_0+fs/m;
        b = f_firparks (m,F_p,F_s,1,1,0,fs); 
end
b = L*b;        

% Perform sampling rate conversion

N = floor(L*P);
y = zeros(1,N);
hstr = sprintf ('Performing rate conversion by %.4f',L);
h = waitbar (0,hstr);
for k = 0 : N-1
   waitbar (k/(N-1),h)
   for i = 0 : min(m,M*k)
      k0 = M*k-i;
      if mod(k0,L) == 0
         i0 = floor(k0/L);
         if i0 < P;
            y(k+1) = y(k+1) + b(i+1)*x(i0+1);
         end
      end
   end
end
close (h);

