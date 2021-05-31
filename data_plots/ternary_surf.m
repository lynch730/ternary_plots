function handle = ternary_surf(handle, name_E, E, name_F, F, ZData, Cbar, varargin)
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
    
    
    %% Select ternary axes, if handle was given
    if (~isempty(handle))
        axes(handle.ax);
    end
    
    %% Obtain X/Y Coordinates
    
    % Indicies from name
    idx_E = identify_ternary_axis( name_E );
    idx_F = identify_ternary_axis( name_F );
    
    % Local copy of wlimits 
    wlimits = handle.grid.wlimits;
    
    % Convert to 0->1 units
    E = (E - wlimits(1,idx_E))./ ( wlimits(2,idx_E) - wlimits(1,idx_E) );
    F = (F - wlimits(1,idx_F))./ ( wlimits(2,idx_F) - wlimits(1,idx_F) );
    
    % Cartesian conversion
    [xp,yp] = tern2cart( idx_E, E, idx_F, F);
    
    %% Create Tri-Surface Data
    phandle = trisurf( delaunay(xp,yp), xp, yp, ZData, varargin{:} );
    
    % Set Edgecolor to none
    phandle.EdgeColor = 'none';
%     
%     % Set
%     caxis([min(ZData) max(ZData)]);
%     
    
    %% Plot Surface Plot
    if isempty(handle)
        handle = phandle;
        
    else % Assume plot3 is called on an existing plot
        
        % Add to the list
        handle.dataplots(end+1).object = phandle;
        
        % Get Zmax from surface data
        handle = restack_ternary_dataplots( handle );
        
        % Add Colorbar 
        if (cbar_flag)
            handle.dataplots(end).colorbar = colorbar( Cbar{:} );
        end

    end
    
    
    %% Add custom Data tip
    wlimits = handle.grid.wlimits;
    set(datacursormode(gcf),'UpdateFcn',{@ternary_datatip,phandle.ZData,wlimits})
    
end