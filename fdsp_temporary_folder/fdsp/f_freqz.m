function [H,f] = f_freqz (b,a,N,fs,bits,realize)

%F_FREQZ: Compute frequency response of discrete-time system using DFT
%
%                b(1) + b(2)z^(-1) + ...+ b(M+1)z^(-m)
%         H(z) = --------------------------------------
%                a(1) + a(2)z^(-1) + ... + a(N+1)z^(-n)  
%
% Usage: [H,f] =f_freqz (b,a,N,fs,bits,realize);
%
% Inputs: 
%         b       = numerator polynomial coefficient vector 
%         a       = denominator polynomial coefficient vector
%         N       = number of discrete frequencies 
%         fs      = sampling frequency (default = 1)
%         bits    = optional integer specifyiing the number 
%                   of fixed-point bits used for the 
%                   realization. Default: double precision 
%                   floating-point   
%         realize = optional integer specifying the 
%                   realization structure to use. Default: 
%                   direct form of MATLAB function filter.   
%
%                   0 = direct form
%                   1 = cascade form
%                   2 = lattice form (FIR) or parallel 
%                       form (IIR)
% Outputs: 
%          H = 1 by N complex vector containing discrete
%               frequency response
%          f = 1 by N vector containing discrete 
%              frequencies at which H is evaluated
% Notes: 
%        1. The frequency response is evaluated  along the
%           top half of the unit circle.  Thus f ranges 
%           from 0 to (N-1)fs/(2N).
%
%        2. H(z) must be stable.  Thus the roots of a(z) must
%           lie inside the unit circle. 
%
%        3. For the parallel form, the poles of H(z) must be
%           distinct
%
% See also: F_FREQS, F_FREQ

% Initialize

if (nargin < 4) | (isempty(fs) == 1)
    fs = 1;
end
if (nargin < 3) | (isempty(N) == 1)
    N = 100;
end

    
H = zeros(1,N);
f = linspace(0,(N-1)*fs/(2*N),N);
r = max(abs(roots(a)));
if r >= 1
   fprintf ('\nThe filter in f_freqz is not stable.\n')
   return
end

% Compute frequency response

M = 2*N;
if (nargin <= 4)
    h = f_impulse (b,a,M);
elseif (nargin <= 5)
    h = f_impulse (b,a,M,bits);
else
    h = f_impulse (b,a,M,bits,realize);
end
temp = fft(h);
H = f_torow(temp(1:N));
    