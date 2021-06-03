function [phandle, chandle] = ternary_surf(wlimits, name_E, E, name_F, F, ZData, Cbar, varargin)
%ternary_surf Plot surface on axes defined by handle.
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
    
    % Check cbar
    cbar_flag = true;
    if ( nargin < 7 )
        Cbar = {'FontWeight','bold','Position',[0.83, 0.12, 0.04, 0.7]};
    elseif strcmp(Cbar,'none')==1
        cbar_flag = false;
    end
    
    % Check varargin
    if ( nargin < 8 )
        varargin = {};
    end
    
    % Check wlimit input
    if (isempty(wlimits))
        wlimits = ternary_axes_limits;
    end
    
    %% Obtain X/Y Coordinates
    
    % Indicies from name
    idx_E = identify_ternary_axis( name_E );
    idx_F = identify_ternary_axis( name_F );
    
    % Cartesian conversion
    [xp,yp] = tern2cart( idx_E, E, idx_F, F, wlimits);
    
    %% Create Tri-Surface Data
    phandle = trisurf( delaunay(xp,yp), xp, yp, ZData, varargin{:} );
    
    % Set Edgecolor to none
    phandle.EdgeColor = 'none';
    
    % Add Colorbar 
    if (cbar_flag)
        chandle = colorbar( Cbar{:} );
    end    
    
end