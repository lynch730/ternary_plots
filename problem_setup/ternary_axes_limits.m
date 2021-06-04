function [ wlimits ] = ternary_axes_limits( varargin )
%ternary_axes_limits  support function for obtaining ternary axes limits
%   
%   Determines the lower and upper bound limits for axes 1-3 in a 2x3
%   matrix "wlimits" consistent with the specifications. The first and
%   second rows of weight_limits correspond with lower and upper bounds
%   respectively for axes 1,2,3. (e.g. Axes 3 spans wlimits(1:2,3) )
%    
%   User inputs:
%     
%       If no inputs are specified, wlimits returns the default ternary
%       range 0->1 along each axis. This corresponds to the limits used in
%       the plotting functions. 
%
%       If 1 input is supplied, it must be a real scalar "wsum" which
%       provids the upper-bound that A+B+C must equal. Axes range from
%       0->sum. This returns a ternary plot with the largest possible range
%       in A,B,C.
%
%       If more than 1 input is given, the first must be wsum, followed by
%       three sets of weight limits that select a sub-region of the larger
%       ternary with A,B,C ranging from 0->wsum. Three weight limits are
%       specified by pairs of axes identifiers (see identify_ternary_axis) and
%       weights (e.g.
%       ternary_axes_limits(100,'left',10,'left',90,'right',30). Axes
%       identifiers can be strings ('left'/'right'/bottom' or 'l','b','r')
%       or integers (1,2,3 for left, bottom, right convention).
%
%       If 7 arguments are given, the user can pass an eigth variable
%       "plot_flag" which is a boolean indicator that, if true, creates an
%       example figure to show the region of the ternary specified by the
%       axes limits
    
    %% Determine Wsum
    if (nargin==0)
        wsum = 1.0;
    else 
        
        % Check first entry is numeric scalar
        if isnumeric(varargin{1}) && numel(varargin{1})==1
            wsum = varargin{1};
        else
           error('Wsum input not scalar real number') 
        end
        
    end
    
    % Finish if wsum is the only input
    if (nargin<=1)
        wlimits(1,1:3) = 0.0; % Lower Bound
        wlimits(2,1:3) = wsum; % Upper Bound
        return
    end
    
    %% Process weight limit inputs
    
    % Check if in range
    if ( nargin ~= 10 && nargin ~= 11 )
       error('Incorrect number of limits inputted') 
    end
    
    % Create input limit vector
    inp_limit = zeros(3,3);
    
    % Process Each Case
    for i=1:3
        
        % Extract axes index from cell array
        inp_limit(1,i) = identify_ternary_axis( varargin{ (i-1)*3 + 2 } );
        
        % Get value from 
        value = varargin{ (i-1)*3 + 3 };
        
        % Check if it is the correct type and size
        if (isnumeric(value) && numel(value)==1)
            
            % Check that it does not exceed the ternary maximum
            if ( value <= wsum )
                inp_limit(2,i) = value;
            else
                error(['Input Value: ',num2str(value), ...
                      ' exceeds provided WSUM']);
            end
        else
            error(['Invalid number for axes limit: ', num2str(value) ]);
        end
       
        % Determine type of bound
        str = varargin{ (i-1)*3 + 4 };
        if ( isnumeric(str) )
            if (str==0)
                inp_limit(3,i) = 0;
            elseif (str==1)
                inp_limit(3,i) = 1;
            else
               error(['Integer input ',num2str(str),' is not zero or one']) 
            end

        else
            if ( strcmp( str, 'low' ) == 1 )
                inp_limit(3,i) = 0;
            elseif (strcmp( str, 'high' ) ==1 )
                inp_limit(3,i) = 1;
            else 
                error(['Bad input for bound type: ',str])
            end            
        end
        
    end
    
    % Check that axes provided are not all the same
    if ( max( inp_limit(:,1) ) - min( inp_limit(:,1) ) ) == 0
       error('All three limits cannot be along the same axis')
    end
    
    % Check that tenrary size is not zero, which happens if any two inputs
    % are repeated
    if numel( unique( inp_limit ,'rows') ) < 6
        error('Cannot have identical limits, or ternary would be a point')
    end
    
    %% Determine wlimits based on processed inp_limits
    % This is done by solving system of equations for A+B+C = wsum for
    % three points on the sub-region. Form: A*x=W, x=[A1;A2;B1;B2;C1;C2]
    
    % A Matrix, first three rows are the summation criterioa for top, left,
    % right points respectivley. Last three are for the known variables
    A = zeros(6,6);
    A(1,1:6) = [1,0,1,0,0,1];
    A(2,1:6) = [0,1,1,0,1,0];
    A(3,1:6) = [1,0,0,1,1,0];
    
    % B Column Vector
    B = zeros(6,1);
    B(1:3,1) = wsum;
    
    % Create combined X vector
    x_vec = NaN(6,1);
    for i=1:3
        
        % axes type
        iax = inp_limit(1,i);
        
        % Indicies of the axes locations in x_vec
        idx = (iax-1)*2 + 1 + inp_limit(3,i);
        
        % Try the first of the two spots for the inp_limit axes
        x_vec( idx ) = inp_limit(2,i);
        
    end
    
    % indicies of X with non-NaN values
    idx_x = find( ~isnan( x_vec ) );
    
    % Check if idx_x is not long enouhg
    if (numel(idx_x)~=3)
       error('Number of unique values supplied is not 3') 
    end
    
    % Fill the last three rows
    for i=1:3
        
        % Fill A
        A( i+3, idx_x(i) ) = 1;
        
        % Fill RHS
        B( i+3 ) = x_vec( idx_x(i) );
        
    end
    
    % Solve Equation
    try
        X = A\B;
    catch
        error('Failure in Matrix Solution')
    end
    
    % Reshape
    wlimits(1:2,1) = X(1:2);
    wlimits(1:2,2) = X(3:4);
    wlimits(1:2,3) = X(5:6);
    
    %% Test plot argument
    if (nargin==11)
        
        % Test boolean
        if (varargin{11})
           
            % Create Figure
            ffig = figure('Name','Plot Shape','Position',[100 100 500 400]);
            
            % Wlimits range actual
             wlimits2 = ternary_axes_limits( wsum );
            
            % Plot AXes of full range
            vgen  = { 'wlimits', wlimits2, ...
                      'ternaryshift',[ 0.01, 0.02 ] };
            handle = ternary_axes( vgen );

            % plot sub-region
            var = {'Color','r','LineWidth',2.0};
            A = [wlimits(1,1),wlimits(2,1)] ; B = [wlimits(1,2),wlimits(1,2)];
            ternary_plot3( wlimits2, 1, A, 2, B, [10,10], var{:} )
            A = [wlimits(2,1),wlimits(1,1)] ; B = [wlimits(1,2),wlimits(2,2)];
            ternary_plot3( wlimits2, 1, A, 2, B, [10,10], var{:} )
            A = [wlimits(1,1),wlimits(1,1)] ; B = [wlimits(2,2),wlimits(1,2)];
            ternary_plot3( wlimits2, 1, A, 2, B, [10,10], var{:} )
            
        end
        
    end
    
end

