function [A,B,C] = cart2tern( X, Y, wlimits )
%cart2tern return ternary coordinates A,B,C from X-Y coordinates
%   
%   This assumes, X-Y are defined for A,B,C with wlimits.
   
    % First check if length is specified
    if (nargin<2)
        error('Too few Arguments')
    elseif (nargin<3) 
        wlimits = ternary_axes_limits;
    end
    
    % edge length sin/cos based on equalateral triangle
    dcos = cos(pi/3.0);
    dsin = sin(pi/3.0);
    
    % Get Wsum
    wsum = wlimits(1,1) + wlimits(2,2) + wlimits(1,3);
    
    % Compute Coordinates in ABC
    B = 0.5.*X - 0.5*(dcos/dsin).*Y;
    A = 1.0 - (X-B)./dcos;
    C = 1.0 - A - B;
    
    % Convert to User-Supplied Limits
    A = A .* ( wlimits(2,1) - wlimits(1,1) ) + wlimits(1,1);
    B = B .* ( wlimits(2,2) - wlimits(1,2) ) + wlimits(1,2);
    C = C .* ( wlimits(2,3) - wlimits(1,3) ) + wlimits(1,3); 
    
end