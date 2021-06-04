
% advanced_example.m This script shows a more involved case of
% ternary_plots, where the three axes are not space 0->1 & do not sum to 1.
% Additional options are added to show how various elements can be
% customized. 

clear all; close all; clc

%% (1) Add paths 
    % This function can be run automatically if copied into "userpath/sartup.m
    add_ternary_paths
    
%% (2) Create Figure with two subplots
    ffig = figure('Name','Advanced Example','Position',[100 100 1000 400]);
    ax1 = subplot(1,2,1);
    ax2 = subplot(1,2,2);
    
%% (3) Create 2 subplots, fill first with the basic example (without colorbar)
    axes(ax1);
    basic_example
    
%% (4) Determine ternary axis limits
    % Set sum of each point on the ternary to 100, and select 3 weights
    % To select a "sub-region" of the ternary, instead of having each be
    % 0->100. You can also just pass "100" for the full 0-100 range.
    % Returns wlimits which stores the plot bounds, and is required if
    % the data to be plotted has A/B/C triplets that exeed the [0-1] range
    wlimits = ternary_axes_limits( 100,'l',20,'low',...
                                       'l',80,'high',...
                                       'r',10,'low', true ); % turn on example plot
                               
%% (5) Create the Axes using customized settings; 
    
    % "vgen" is a cell array of custom settings specific to Ternary_Plots.
    %    All options are listed in ternary_axis.m ->  initialize_ternary_handle(). 
    %    This is an example of extreme customization.
    vgen  = { 'wlimits',       wlimits ,... % Axes will match wlimits ranges
              'gridspaceunit', 13,      ... % Number of grid lines
              'ticklinelength', [3.25,3.25,4],    ... % length of tick-lines in ABC coord.
              'tick_fmt',      '%2.0f', ... % tick label formatting
              'titlelabels', {'Apples','Oranges','Bananas'}, ... % custom labels
              'titlerotation', [0,0,0], ... % Set all titles to horizontal
              'link_color', {'tick','title'},... % Link all axes colors
              'titleshift',[ -0.18, 0, 0.18; 0.085, -0.11, 0.085 ]... % shift titles
              'tickshift', [-0.02, -0.02, 0.0; -0.01,-0.00,0]
            };
    
	% Ternary Axes Outline   - Passed directly to plot3() 
    vout  = { 'LineWidth', 3, 'LineStyle', '-','Color','k'};
        
    % Ternary gridlines  - Passed directly to plot3()
    vgrid = { 'LineStyle','-','LineWidth',0.5, 'Color',[0 0 0 0.2] };
        
    % Ternary Tick Line - Passed directly to plot3()
    vtick_line = { 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[0 0 0 1.0] };
    
    % Ternary Tick Labels - Passed directly to text()
    vtick_label = { 'FontWeight','Bold', 'FontSize', 8 };
       
    % Ternary Axes Label  - Passed directly to text()
    vlab  = { 'FontWeight','normal', 'FontSize', 14 };
    
    % Select second subplot
    axes( ax2 ); 
    
    % Create Ternary Axes & return Handle
    handle = ternary_axes( vgen, vout, vgrid, vtick_line, vtick_label, vlab );
    
%% (6) Get a set of A,B,C Test points
    % Rows of A,B,C triplets for uniformly-spaced data, assuming 31 grid
	% points along each of the three axes, bounded by wlimits defined earlier
    [A,B,C] = ternary_arrays( 31, wlimits );
    
%% (7) Create example data
    
    % Get x/y data
    [xp,yp] = tern2cart(1, A, 2, B, wlimits );
    
    % Create Z Data from Peaks
    Z = peaks(xp.*6.0-3.0,yp.*6.0-2.0);
    
%% (8) Plot the surface Z defiend on rows of ABC points in xmat
    
    % Define a customized color bar
    Cbar = {'FontWeight','bold','Position',[0.90 0.17 0.02 0.68] };
    
    % Create Surface Plot + colorbar
    dataplots(1).obj = ternary_surf( wlimits, 'l', A, 'b', B, Z , Cbar );
    
    % Set shading (e.g. flat or interp)
    shading(ax2, 'interp')
    
    % Set Colormap to B/W
    colormap(ax2, gray)
    
    % Reset Range of Surface Colors
    caxis([-3 5])
    
    % Add custom Data tip
    set(datacursormode(gcf),'UpdateFcn',{@ternary_datatip,dataplots(1).obj.ZData,wlimits})
    
    % Add Title
    title('A Fruity Example','FontSize',18)
    
%% (9) Add labels at Max
    [val,idx] = max(Z(:));
    str = ['Max=',num2str(val,'%4.1f')];
    var = {'MarkerFaceColor','b','MarkerEdgeColor','b'};
    dataplots(2).obj = ternary_scatter3(wlimits, 1, A(idx), 2, B(idx), [], 'none', var{:});
    var = {'Color','b'};
    dataplots(3).obj = ternary_text(wlimits, 1, A(idx), 2, B(idx),str, [] , var{:} );
    dataplots(3).obj.HorizontalAlignment ='center';
    dataplots(3).obj.VerticalAlignment   ='top';

%% (10) Add labels at Min
    [val,idx] = min(Z(:));
    str = ['Min=',num2str(val,'%4.1f')];
    var = {'MarkerFaceColor','c','MarkerEdgeColor','c'};
    dataplots(4).obj = ternary_scatter3(wlimits, 1, A(idx), 2, B(idx), [], 'none', var{:});
    var = {'Color','c'};
    dataplots(5).obj = ternary_text(wlimits, 1, A(idx), 2, B(idx),str, [] , var{:} );
    dataplots(5).obj.HorizontalAlignment ='center';
    dataplots(5).obj.VerticalAlignment   ='bottom';
    
%% (9) Adjust Colors of axes
    
    % Change the Apples title, tick label, tick lines color
    handle.link_color = {'tick','title'};
    handle = adjust_axis_color(handle,'left',[0.6353, 0.0784, 0.1843, 0.6]);
    
    % Change LineStyle of grid lines
    handle.grid.lines(1,1).LineWidth = 1.5;
    handle.grid.lines(1,2).LineWidth = 1.0;
    handle.grid.lines(1,3).LineStyle = '--';
    
    % Change color of Oranges grid lines and tick labels
    handle.link_color = {'grid','tick_label'};
    handle = adjust_axis_color(handle,'bot',[0.85, 0.33, 0.098, 0.7 ] );
    
    % Change color of Banana title
    handle.link_color = {'title'};
    handle = adjust_axis_color(handle,'r',[0.58, 0.54, 0.0] );
    
    % Restack Final Plots
	handle = restack_dataplots(handle, dataplots);
    
    