function handle = ternary_grid_lines( handle, varargin )
%ternary_grid_lines plots a set of grid lines for all three axes
%   
%   Input grid_pnts is structure array grid_pnts(1:3).values(1:N), where N
%   can vary for each axis. Ticklinelength gives any extra length on the
%   base axis used for ticks
%   
    
    %% Check Inputs
    
    % Check if handle is given
    if (nargin==0)
       error('Too few inputs') 
    end
    
    % Create defaul settings if no extra arguments supplied
    if ( nargin < 2 || isempty( varargin ) )
        varargin = {'LineStyle','-','LineWidth',1.25,'Color',[0 0 0 0.3]};
    end
    
    %% Loop Axes and Set grid lines
    
    % Extract a copy of grid points from handle
    try
        grid_pnts = handle.grid.grid_pnts;
    catch
       error('Spacing array, handle.grid.grid_pnts, not defined'); 
    end
    
    % Loop each axis
    for iaxis = 1:3
        
        % Loop grid lines
        for i = 1:numel( grid_pnts(iaxis).values )    
            
            % First point at the base
            [A,B,~] = tern2base( iaxis, grid_pnts(iaxis).values(i), ...
                                       1.0, handle.tick.ticklinelength);
           
            % Plot3
            handle.grid.lines(i,iaxis) = ternary_plot3( [], 1, A, 2, B, [], varargin{:} );
            
        end
        
        % Link properties related to formatting to each axes
        props = {'LineStyle','LineWidth','Color','Visible','Marker',...
           'MarkerEdgeColor','MarkerFaceColor','MarkerIndices',...
           'Selected','MarkerSize'};
            
        % Link Gridlines
        handle.grid.link_lines(iaxis) = linkprop(handle.grid.lines(:,iaxis),props);
        
    end
    
    % Link All gridlines to Z position for each of changing later
     handle.grid.link_axes = linkprop(handle.grid.lines(:),'ZData');
    
end
