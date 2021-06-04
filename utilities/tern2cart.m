function [X,Y] = tern2cart(name_E, E, name_F, F , wlimits )
%tern2cart coverts ternary to cartesian units
%
%   Converts ternary coordinates (A,B,C) along any two axes (E/F) and to
%   X/Y plotting coordinates. E/F can be any dimension of real numbers of
%   the same size. E/F values outside the wlimits range are allowed. The
%   plotting origin (0,0) is always the SW corner of the ternary, and side
%   order is left, bottom, right for 1,2,3
    
    % First check if length is specified
    if (nargin<4)
        error('Too few Arguments')
    elseif (nargin<5) % default to 0->1
        wlimits = ternary_axes_limits;
    end
    
    %% Get integer indices from names, in form idx_E < idx_F

    % Determine indicies from names
    idx_E = identify_ternary_axis( name_E );
    idx_F = identify_ternary_axis( name_F );
    
    % Throw error if they are the same
    if ( idx_E == idx_F )
       error('Names for E and F must point to different Ternary Axes') 
    end
    
    % Make sure A/B are in the correct order (small to large). If not, swap
    % This is done to simplify index swapping
    if (idx_E > idx_F)
       C = E; idx_C = idx_E; % Save A
       E = F; idx_E = idx_F; % overwrite A with B
       F = C; idx_F = idx_C; % make B the original A
    end
    
    % Convert to 0->1 units
    E = (E - wlimits(1,idx_E))./ ( wlimits(2,idx_E) - wlimits(1,idx_E) );
    F = (F - wlimits(1,idx_F))./ ( wlimits(2,idx_F) - wlimits(1,idx_F) );
    
    %% Change to index 1/2 form, because that only requires one equation set
    
    % Get Index 1/2 in correct order, if 3 is involved, else A=1, and B=2.
    if (idx_F == 3)
        
        % If A is correct, just change 3 to 2 (right to bottom)
        if ( idx_E == 1 ) 
            F = 1.0 - E - F; % Get 2 from left and right (1/3)
            
        % Else, have to save bottom before writting
        elseif ( idx_E == 2 ) % Get left from bot/right
            C = 1.0 - E - F; % the real A
            F = E; % Side 2 from side A
            E = C; % Side 1 from C
        end
        
    end
    
    %% Final Calculation of X/Y
    
    % edge length sin/cos based on equalateral triangle
    dcos = cos(pi/3.0);
    dsin = sin(pi/3.0);
    
    % Add Factors  
    E = 1.0 - E;  % Right edge length from left
    F = 0.5 .* F; % half left edge
    
    % X is left edge, X-component of hypotensus straight from origin,
    % plus the contribution from B, moving along y=0 line;
    X = E.*dcos + F;
    
    % Y Component, Start at Y from sin of origin to A, then subtracts
    % the Y distance from A to B ("drop down"). This comes from a
    % parallelogram with base being B (along y=0), carried up to above
    % the plotted point, half of B is one edge of the triangle with
    % angles pi/6 and pi/3. The other base is the hieght up to A, so
    % tan is used
    Y = E.*dsin - F.*dsin/dcos;

end