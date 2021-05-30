function handle = ternary_grid_lines( handle, grid_pnts, ticklinelength, ...
                                     varargin )
%ternary_grid_lines plots a set of grid lines for all three axes
%   
%   Input grid_pnts is structure array grid_pnts(1:3).values(1:N), where N
%   can vary for each axis. Ticklinelength gives any extra length on the
%   base axis used for ticks
%   
    
    %% Check Inputs
    
    % Check ticklines
    if (nargin < 3)
        ticklinelength = 0.0;
    end
    
    % Check grid pnts
    if (nargin < 2)
        grid_pnts = linspace(0,1,6);
    end
    
    % Check if handle is given
    if (nargin==0)
       error('Too few inputs') 
    end
    
    % Create defaul settings if no extra arguments supplied
    if isempty(varargin)
        varargin = {'LineStyle','-','LineWidth',1.25,'Color',[0 0 0 0.3]};
    else %flatten
        varargin = varargin{:};
    end
    
    %% Loop Axes and Set grid lines
    
    % Loop each grid point
    for iaxis=1:3
        
        % Loop grid lines
        for i=1:numel(grid_pnts(iaxis).values)    
            handle.grid.lines(i,iaxis) = plot_ternary_line( iaxis, grid_pnts(iaxis).values(i), ...
                                        1.0, ticklinelength, varargin );
        end
        
        % Link properties related to formatting to each axes
        props = {'LineStyle','LineWidth','Color','Visible'};
        
        % Link Gridlines
        handle.grid.link_lines(iaxis) = linkprop(handle.grid.lines(:,iaxis),props);
        
    end
    
    % Link All gridlines to Z position for each of changing later
     handle.grid.link_axes = linkprop(handle.grid.lines,'ZData');
    
end
