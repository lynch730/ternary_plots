function [ A,B,C ] = ternary_arrays( nsim, wlimits )
%ternary_arrays build arrays for ternary calculations, equally spaced
%
%   ABC is Nx3 matrix of equally-spaced ternary coordinates, with each row
%   being an A,B,C triplet set. N=nsim*(nsim+1)/2, sum of 1:nism. nsim is
%   the number of grid points along each of the three axes. 
%
%   wlimits is the 2x3 matrix of lower and upper weights on eahc
%   coordinate
%
    
    % If wlimits not given, use default
    if (nargin<2)
       wlimits =  ternary_axes_limits;
    end
    
    %% Get basic x1,x2,x3 arrays for 0-1 Ternary basis
    
    % Set Bounds
    % First Species - base array
    A_base(:,1) = linspace( 0.00, 1, nsim );
    B_base(:,1) = linspace( 0.00, 1, nsim );
    
    % Construct
    % First+Second Species - concatenate x1(1:i-1) 
    A = A_base;
    B( 1:nsim, 1 ) = B_base(1);
    for i=nsim-1:-1:1
        new_array = A(1:i,1);
        A = [A; new_array]; 
        B = [B; repmat( B_base(nsim-i+1), [length(new_array) , 1 ] ) ];
    end
    
    % Third Species fraction
    C = 1.0 - A -B;
    
    % Prevent Rounding errors from causing very small negatives
    C( C<0 & C>-1e-6 ) = 0;
    
    % Check Third Species fraction
    if ( min(C)<0 )
       error('Third Species has <0 fraction, check limits on Species 1 and 2') 
    end
    if ( max(C)>1 )
        error('Third Species has >1 fraction, check limits on Species 1 and 2')
    end
    
     %% Determine Weights in Non-Plot Units (not 0->1)
    
    % Create  Limits [0-100] from [0-1] ranges
    A = A*( wlimits(2,1) - wlimits(1,1) ) + wlimits(1,1);
    B = B*( wlimits(2,2) - wlimits(1,2) ) + wlimits(1,2);
    C = C*( wlimits(2,3) - wlimits(1,3) ) + wlimits(1,3);
    
end

