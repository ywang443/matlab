function [index,Vert] = f_neighbors (theta,a,b,m,n,d)

% F_NEIGHBORS: Find scalar indeces of vertices of grid element
%
% Usage: [index,Vert] = f_neighbors (theta,a,b,m,n,d)
%
% Inputs: 
%         theta = p by 1 vector specifiying the evaluation
%                 point where p = m+n+1
%         a     = 2 by 1 vector of bounds on the input
%         b     = 2 by 1 vector of bounds on the output
%         m     = number of past inputs (m >= 0)
%         n     = number of past ouputs (n >= 0)
%         d     = number of grid points per dimension 
%                 (d >= 2) 
% Outputs: 
%          index = 2^p by 1 vector of scaler indices of 
%                  the vertices of the grid element 
%                  containing theta
%          Vert  = p by 2^p array whose columns contain
%                  the vertices of the grid element 
%                  containing theta
% Notes: 
%        1. If theta is not in the domain of f, then the
%           vertices of the grid element closest to theta
%           will be found
%        2. This function is used by f_rbf0 and f_rbf1

% Initialize

m = f_clip (m,0,m);
n = f_clip (n,0,n);
d = f_clip (d,2,d);
p = m+n+1;
M = 2^p;

% Compute vector index of base vertex

Delta_x = (a(2) - a(1))/(d-1);
Delta_y = (b(2) - b(1))/(d-1);
v = zeros(p,1);
for j = 1 : p
    if j <= m+1
        v(j) = floor ((theta(j) - a(1))/Delta_x);
        v(j) = f_clip(v(j),0,d-2);
    else
        v(j) = floor ((theta(j) - b(1))/Delta_y);
        v(j) = f_clip(v(j),0,d-2);
    end
end

% Compute scalar indices and vertices

for j = 0 : M-1
    c = f_dec2base (j,2,p);
    q = v + c;
    index(j+1) = f_base2dec (q,d);
    Vert(:,j+1) = f_gridpoint (index(j+1),a,b,m,n,d);
end
 