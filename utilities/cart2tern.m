function [A,B,C] = cart2tern( X, Y )
%cart2tern return ternary coordinates A,B,C from X-Y coordinates
%   
%   This assumes, X-Y are defined for A,B,C with wlimits from 0->1 (the
%   plotting coordinate convention).
   
    % First check if length is specified
    if (nargin<2)
        error('Too few Arguments')
    end
    
    % edge length sin/cos based on equalateral triangle
    dcos = cos(pi/3.0);
    dsin = sin(pi/3.0);
    
    % Compute B
    B = 0.5.*X - 0.5*(dcos/dsin).*Y;
    A = 1.0 - (X-B)./dcos;
    C = 1.0 - A - B;
    
end