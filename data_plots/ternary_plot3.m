function handle = ternary_plot3( handle, name_E, E, name_F, F, ZData, varargin)
%ternary_plot3 plot3 with Ternary Coordinate Inputs (ABC)
%   
%   
    %% Process inputs
    
    % Check input count
    if ( nargin < 5 )
        error('Too few Inputs')
    end
    
    % If user does not specify ZData, plot at zero
    if ( nargin<6 || isempty(ZData) ) % if Zdata not specified
        ZData = zeros( size(E) );
    end
    
    % Check size of E/F
    if ~isequal( size(E), size(F) )
        error('E/F inputs must be the same size')
    end
    
    % Check E/Z
    if ~isequal( size(E), size(ZData) )
        error('E/F and Z inputs must be the same size')
    end
    
    % Check varargin
    if ( nargin < 7 )
        varargin = {};
    end
    
    %% Select ternary axes, if handle was given
    if (~isempty(handle))
        axes(handle.ax);
    end
    
    %% Obtain X/Y Coordinates
    
    % Indicies from name
    idx_E = identify_ternary_axis( name_E );
    idx_F = identify_ternary_axis( name_F );
    
    % Cartesian conversion
    [xp,yp] = tern2cart( idx_E, E, idx_F, F);
    
    %% If No Ternary Handle Was Given, just output plot3 handle
    %   This is used for initialization of ternary axes, see
    %   gridlines/outlines
    if isempty(handle)
        handle = plot3( xp, yp, ZData, varargin{:} );
    
    else % Assume plot3 is called on an existing plot
        
        % Add to the list
        handle.dataplots(end+1) = plot3( xp, yp, ZData, varargin{:} );
        
        % Check plot is on top, push it to the top
        handle = restack_ternary_dataplots( handle );
        
    end
    
end

