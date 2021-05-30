function line_handle = plot_ternary_line( name, value, wsum, ticklinelength, varargin )
% plot_ternary_line basic form of plotting a line on the tenrary plot
%
%   Requires the axis name and value. Obtains the base values (allowing for
%   a negative value in ticklinelength, converts those to x and y
%   coordinates.

    %% Process Inputs 
    
    % Check minimum and wsum
    if (nargin<2)
        error('Too few arguments')
    elseif (nargin<3)
        wsum = 1.0;
    end
    
    % Check tick length, default to zero
    if (nargin<4)
        ticklinelength = 0.0;
    end
    
    % Set default varargin if empty
    if (isempty(varargin))
        varargin = {};
    else
        varargin = varargin{:};
    end
    
    % process axis name
    iaxis = ternary_axis_name( name );
    
    %% Build line Plot
    
    % Get local coordinate
    [A,B,~] = tern2base( iaxis, value, wsum, ticklinelength);
    
    % Convert to X/Y coordinates
    [xp,yp] = tern2cart(1,A,2,B);
    
    % Plot the grid
    line_handle = plot3( xp, yp, [0.0 0.0], varargin{:} );
    
end

