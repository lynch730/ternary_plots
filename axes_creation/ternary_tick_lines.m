function handle = ternary_tick_lines( handle, varargin )
% ternary_tick_lines create axes tick lines
%   
%   Inputs 
%

    %% Check Inputs
    
    % Check if handle is given
    if (nargin==0)
       error('Too few inputs') 
    end
    
    % Create defaul settings if no extra arguments supplied
    if ( nargin < 2 || isempty( varargin ) )
        varargin = {'LineStyle','-','LineWidth',1.5,'Color',[0 0 0 0.4]};
    end
    
    %% Loop Axes and Set grid lines
    
    % Extract a copy of grid points from handle
    try
        grid_pnts = handle.grid.grid_pnts;
    catch
       error('Spacing array, handle.grid.grid_pnts, not defined'); 
    end
    
    % Local copy of wlimits 
    wlimits = handle.grid.wlimits;
    
    % Loop each axis
    for iaxis = 1:3
        
        % Loop grid lines
        for i = 1:numel( grid_pnts(iaxis).values )    

            % First point at the base, second on the far side, both stored in A/B
            [E1,F1,~] = tern2base( iaxis, grid_pnts(iaxis).values(i), ...
                                       wlimits, handle.tick.ticklinelength(iaxis) );
            
            % First point at the base, second on the far side, both stored in A/B
            [E2,F2,~] = tern2base( iaxis, grid_pnts(iaxis).values(i), ...
                                       wlimits, 0.0);
            
            % Reconstruct 
            E = [ E1(1), E2(1) ];
            F = [ F1(1), F2(1) ];
            
            % Plot3 based on two points in A/B, pass varargin elements
            handle.tick.lines(i,iaxis) = ternary_plot3( wlimits, 1, E, 2, F, [], varargin{:} );
            
        end
        
        % Link properties related to formatting to each axes
        props = {'LineStyle','LineWidth','Visible','Marker',...
           'MarkerEdgeColor','MarkerFaceColor','MarkerIndices',...
           'Selected','MarkerSize'};
            
        % Link these proprties to all Gridlines on an axis
        handle.tick.link_lines(iaxis) = linkprop(handle.tick.lines(:,iaxis),props);
        
    end
    
    % Link All gridlines to Z position for each of changing later
    handle.tick.link_axes_tick = linkprop(handle.tick.lines(:),'ZData');
    
end
