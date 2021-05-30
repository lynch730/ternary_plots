function [X,Y] = tern2cart(name_A, A, name_B, B )
%tern2cart coverts ternary to cartesian units
%
%   Converts ternary coordinates (A,B,C) along any two axes and to X/Y
%   plotting coordinates. A,B,C can be any dimension of real numbers of the
%   same size. A,B,C must be defined relative to 0-1 range. Values outside
%   range are allowed, but user is warned if they exceed [-0.5-1.5], as
%   this indicates a likely mistake in inputs. The plotting origin (0,0) is
%   always the SW corner of the ternary, and side order is
%   left, bottom, right for 1,2,3
    
    % First check if length is specified
    if (nargin<4)
        error('Too few Arguments')
    end
    
    %% Get integer indices from names, in form idx_A < idx_B

    % Determine indicies from names
    idx_A = ternary_axis_name( name_A );
    idx_B = ternary_axis_name( name_B );
    
    % Throw error if they are the same
    if ( idx_A == idx_B )
       error('Names for A and B must point to different Ternary Axes') 
    end
    
    % Make sure A/B are in the correct order (small to large). If not, swap
    if (idx_A > idx_B)
       C = A; idx_C = idx_A; % Save A
       A = B; idx_A = idx_B; % overwrite A with B
       B = C; idx_B = idx_C; % make B the original A
    end
    
    % Check that A/B are normalized (cannot normalize because third vector
    % is not given).
    if ( max( A(:) + B(:) ) > 1.5 || min( A(:) + B(:) ) < -0.5  )
       warning( [ 'A and B coordinates may not be given ',...
                  'with respect to [0-1] range!' ] ) 
    end
    
    %% Change to index 1/2 form, because that only requires one equation set

    % Get Index 1/2 in correct order, if 3 is involved, else A=1, and B=2.
    if (idx_B == 3)
        
        % If A is correct, just change 3 to 2 (right to bottom)
        if ( idx_A == 1 ) 
            B = 1.0 - A - B; % Get 2 from left and right (1/3)
            
        % Else, have to save bottom before writting
        elseif ( idx_A == 2 ) % Get left from bot/right
            C = 1.0 - A - B; % the real A
            B = A; % Side 2 from side A
            A = C; % Side 1 from C
        end
        
    end
    
    %% Final Calculation of X/Y
    
    % edge length sin/cos based on equalateral triangle
    dcos = cos(pi/3.0);
    dsin = sin(pi/3.0);
    
    % Add Factors  
    A = 1.0 - A;  % Right edge length from left
    B = 0.5 .* B; % half left edge
    
    % X is left edge, X-component of hypotensus straight from origin,
    % plus the contribution from B, moving along y=0 line;
    X = A.*dcos + B;

    % Y Component, Start at Y from sin of origin to A, then subtracts
    % the Y distance from A to B ("drop down"). This comes from a
    % parallelogram with base being B (along y=0), carried up to above
    % the plotted point, half of B is one edge of the triangle with
    % angles pi/6 and pi/3. The other base is the hieght up to A, so
    % tan is used
    Y = A.*dsin - B.*dsin/dcos;

end