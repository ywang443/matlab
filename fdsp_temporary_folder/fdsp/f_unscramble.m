function y = f_unscrambe (x)

%F_UNSCRAMBLE: Reorder FFT output to freqency range [-fs/2,fs/2]
%
% Usage: y = f_unscramble(x)
%
% Inputs: 
%         x  = output from FFT 
% Outputs: 
%          y = reordered output 

y = zeros(size(x));
n = length(x)/2;
y(1:n) = x(n+1:2*n);
y(n+1:2*n) = x(1:n);
