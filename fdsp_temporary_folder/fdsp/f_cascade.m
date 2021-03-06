function [B,A,b_0] = f_cascade (b,a)

%F_CASCADE: Find cascade form digital filter realization
%
%              H(z) = b_0*H_1(z)*H_2(z)*...*H_N(z)
%
% Usage:       [B,A,b_0] = f_cascade (b,a)
%
%
% Inputs: 
%         b = vector of length m+1 containing coefficients 
%             of numerator polynomial.
%         a = an optional vector of length n+1 containing 
%             coefficients of denominator polynomial.  
%             Default a = 1;
% Outputs: 
%          B   = N by 3 matrix containing coefficients of 
%                numerators of second-order blocks.
%          A   = N by 3 matrix containing coefficients of 
%                denominators of second-order blocks.
%          b_0 = numerator gain
%
% Notes: 
%        1. It is required that b(1)<>0.  Otherwise factor 
%           out a z^-1 and then find the cascade form
%        2. To evaluate cascade form realization use 
%           f_filtcas
%        3. For FIR filters, the argument a is optional. 
%
% See also: F_FILTCAS, F_PARALLEL, F_FILTPAR, F_LATTICE, 
%           F_FILTLAT, FILTER

% Initialize

m = length(b) - 1;
if nargin < 2
    a = 1;
end
n = length(a) - 1;
if m < n
    b = [f_torow(b),zeros(1,n-m)];
    m = length(b)-1;
elseif n < m
    a = [f_torow(a),zeros(1,m-n)];
    n = length(a)-1;
end
N = floor((n+1)/2);
B = zeros(N,3);
A = ones(N,3);
b_0 = 0;

% Check for bad calling arguments

if abs(b(1)) < eps^2
    fprintf ('\nf_cascade requires that b(1) <> 0.  You can factor z^(-1)\n')
    fprintf ('from the numerator until b(1) <> 0.\n\n')
    return;
end

% Compute numerator gain

[q,r] = deconv(b,poly(roots(b)));
b_0 = q(length(q));

% Sort poles and zeros

[p,z] = f_sortpoles (b,a);
if mod(n,2)
    p = [p ; 0];
    z = [z ; 0];
end

% Compute second-order blocks

k = 1;
for i = 1 : N
      B(i,1:3) = [1, -(z(k)+z(k+1)), z(k)*z(k+1)];
      A(i,1:3) = [1, -(p(k)+p(k+1)), p(k)*p(k+1)];
      k = k + 2;
end
 
function [p,z] = f_sortpoles (b,a);

%F_SORTPOLES: Sort poles and zeros of transfer function
%
% Usage:       [p,z] = f_sortpoles (b,a)
%
% Inputs: b = vector of length m+1 containing numerator polynomial 
%             coefficients
%         a = vector of length n+1 containing denominator polynomial 
%             coefficients
%
% Outputs: p = n by 1 vector containing sorted poles 
%          z = n by 1 vector containing sorted zeros
%
% Note: This function is used by F_CASCADE

% Initialize

n = length(a) - 1; 
m = length(b) - 1;
p = zeros(n,1);
z = zeros(m,1);
tol = sqrt(eps);

% Sort poles 

P = sort(roots(a));
i = 1;
c = 0;
d = n;
while (i <= n)
   if (i < n) & (abs(imag(P(i) + P(i+1))) < tol)
      p(c+1) = P(i);
      p(c+2) = P(i+1);
      c = c + 2;
      i = i + 2;
   else
      p(d) = P(i);
      d = d - 1;
      i = i + 1;
   end
end

% Sort zeros

if (length(b) > 1)
   Z = sort(roots(b));
   i = 1;
   c = 0;
   d = m;
   while (i <= m)
      if (i < m) & (abs(imag(Z(i) + Z(i+1))) < tol)
         z(c+1) = Z(i);
         z(c+2) = Z(i+1);
         c = c + 2;      
         i = i + 2;
      else
         z(d) = Z(i);
         d = d - 1;
         i = i + 1;
      end
   end
   
end   
