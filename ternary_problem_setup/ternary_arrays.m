function [ xmat ] = ternary_arrays( nsim, wt_limits )
%ternary_arrays build arrays for ternary calculations, equally spaced
%
%   xmat is Nx3 matrix of equally-spaced ternary coordinates, with each row
%   being an A,B,C triplet set. N=nsim*(nsim+1)/2, sum of 1:nism. nsim is
%   the number of grid points along each of the three axes. 
%
%   wt_limits is the 2x3 matrix of lower and upper weights on eahc
%   coordinate
%
    %% Get basic x1,x2,x3 arrays for 0-1 Ternary basis
    
    % Set Bounds
    % First Species - base array
    x1_base(:,1) = linspace( 0.00, 1, nsim);
    x2_base(:,1) = linspace( 0.00, 1, nsim);
    
    % Construct
    % First+Second Species - concatenate x1(1:i-1) 
    x1 = x1_base;
    x2( 1:nsim, 1 ) = x2_base(1);
    for i=nsim-1:-1:1
        new_array = x1(1:i,1);
        x1 = [x1; new_array]; 
        x2 = [x2; repmat( x2_base(nsim-i+1), [length(new_array) , 1 ] ) ];
    end
    
    % Third Species fraction
    x3 = 1.0 - x1 -x2;
    
    % Prevent Rounding errors from causing very small negatives
    x3( x3<0 & x3>-1e-6 ) = 0;
    
    % Check Third Species fraction
    if ( min(x3)<0 )
       error('Third Species has <0 fraction, check limits on Species 1 and 2') 
    end
    if ( max(x3)>1 )
        error('Third Species has >1 fraction, check limits on Species 1 and 2')
    end
    
     %% Determine CEA Weights
    
    % Create CEA Limits [0-100] from [0-1] ranges
    x1_wt = x1*( wt_limits(2,1)-wt_limits(1,1) ) + wt_limits(1,1);
    x2_wt = x2*( wt_limits(2,2)-wt_limits(1,2) ) + wt_limits(1,2);
    x3_wt = x3*( wt_limits(2,3)-wt_limits(1,3) ) + wt_limits(1,3);
    
    % Add weights together
    xmat = [ x1_wt, x2_wt, x3_wt ];
    
end

