function handle = ternary_tick_labels( handle, varargin )
% ternary_tick_labels create axes tick labels
%   
%   Inputs 
%

    %% Input Checking
    if (nargin < 1)
        error('Too few inputs')
    end
    
    % Check var_tick
    if ( nargin<2 || isempty(varargin) )
        varargin = {'FontWeight','Bold', 'FontSize', 11};
    end
    
    %% Prepare data
    
    % Extract a copy of grid points from handle
    try
        grid_pnts = handle.grid.grid_pnts;
    catch
       error('Spacing array, handle.grid.grid_pnts, not defined'); 
    end
    
    % Extract a copy of grid points from handle
    try
       wlimits = handle.grid.wlimits;
    catch
       error('wlimits, handle.grid.wlimits, not defined'); 
    end
    
    % Alignment Storage
    hz = {'right', 'right',   'left'};
    vz = {'bottom',  'top', 'bottom'};

    %% Create gridlines along each axis
    for iaxis=1:3
        
        % Obtain Plot Points
        plt_pnts = grid_pnts(iaxis).values.*( wlimits(2,iaxis) ...
                                   - wlimits(1,iaxis) ) + wlimits(1,iaxis);
        
        % Loop Grid
        for i=1:numel(grid_pnts(iaxis).values)
            
            % Get local coordinate
            [A,B,~] = tern2base( iaxis, grid_pnts(iaxis).values(i), 1.0, 0.0);
            
            % Convert to X/Y coordinates
            [xp,yp] = tern2cart(1,A,2,B);
            
            % String Tick Label, place with upper-right corner at end of line end
            str = num2str( plt_pnts(i), handle.tick.tick_fmt );
            
            % Place text vertically halfway from end point to axis edge
            handle.tick.text(i,iaxis) = text( xp(1), yp(1), str, ...
                                         'horizontalalignment',hz{iaxis},...
                                         'verticalalignment',  vz{iaxis},...
                                         'units','data', varargin{:} );
            
        end

        % Link properties related to formatting all together
        props = {'BackgroundColor','FontAngle','FontName','FontSize',...
                'FontSmoothing','FontUnits','FontWeight','Interpreter',...
                'LineStyle','LineWidth','Visible','Selected','Color'};

        
        % Link Tick Labels
        handle.tick.link_text(iaxis) = linkprop(handle.tick.text(:,iaxis),props);
       
    end
    
end
