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
    
    % Local copy of wlimits 
    wlimits = handle.grid.wlimits;
    wsum    = handle.grid.wsum;
    
    %% Create gridlines along each axis
    for iaxis=1:3
        
        % Loop Grid
        for i=1:numel(grid_pnts(iaxis).values)
            
            % Get local coordinate
            [E,F,~] = tern2base( iaxis, grid_pnts(iaxis).values(i), wlimits, 0.0);
            
            % String Tick Label, place with upper-right corner at end of line end
            str = num2str( grid_pnts(iaxis).values(i), handle.tick.tick_fmt );

            % Add customized alignement to varargin
            var = [ varargin(:)', 'horizontalalignment', hz{iaxis}, ...
                                'verticalalignment',  vz{iaxis}, ...
                                'units','data', varargin{:} ];
                    
            % Place text vertically halfway from end point to axis edge
            handle.tick.text(i,iaxis) = ternary_text( wlimits, 1, ...
                                                     E(1), 2, F(1), str, ...
                                                     [], var{:} );
           
        end

        % Link properties related to formatting all together
        props = {'BackgroundColor','FontAngle','FontName','FontSize',...
                'FontSmoothing','FontUnits','FontWeight','Interpreter',...
                'LineStyle','LineWidth','Visible','Selected','Color'};

        
        % Link Tick Labels
        handle.tick.link_text(iaxis) = linkprop(handle.tick.text(:,iaxis),props);
       
    end
    
end
