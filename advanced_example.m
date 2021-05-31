% advanced_example.m This script shows a more involved case of
% ternary_plots, where the three axes are not space 0->1 & do not sum to 1.
% Additional options are added to show how various elements can be
% customized. 

clear all; close all; clc

%% (1) Add paths 
%      - This function can be run automatically if copied into "userpath/sartup.m
add_ternary_paths

%% (2) Create Figure with two subplots
    ffig = figure('Name','Advanced Example','Position',[100 100 1000 400]);
    ax1 = subplot(1,2,1);
    ax2 = subplot(1,2,2);

    
%% (3) Create 2 subplots, fill first with the basic example (without colorbar)
    axes(ax1);
    handle = ternary_axes; % Assumes default wlimits 0->1 for all sides
    [A,B,C] = ternary_arrays( 20 ); % Create 20 test points to plot
    Z = (A+10)*2.0 + 10*B.^1.2 - 5*sqrt(C*5);
    ternary_surf( handle, 'l', A, 'b', B, Z ,'none'); % turn of colorbar
    title('A Basic Example','FontSize',18)
    
    
%% (4) Determine ternary axis limits
%       Set sum of each point on the ternary to 100, and select 3 weights
%       to select a "sub-region" of the ternary, instead of having each be
%       0->100. You can also just pass "100" for the full 0-100 range.
%       wlimits stores the plot bounds, and is required if the data to be
%       plotted has A/B/C triplets that exeed [0-1]
    wlimits = ternary_axes_limits( 100,'l',10,'low',...
                                       'l',60,'high',...
                                       'r',30,'low' );
                               
                                   
%% (5) Create the Axes using customized settings; 
    
    % "vgen" is a cell array of custom settings specific to Ternary_Plots.
    %    All options are listed in ternary_axis.m ->  initialize_ternary_handle(). 
    %    This is an example of extreme customization.
    vgen  = { 'wlimits',       wlimits ,... % Axes will match wlimits ranges
              'gridspaceunit', 10,      ... % Number of grid lines
              'ticklinelength', 0.09,    ... % length of tick-lines
              'tick_fmt',      '%2.1f', ... % tick label formatting
              'titlelabels', {'Apples','Oranges','Bananas'}, ... % custom labels
              'titlerotation', [0,0,0], ... % Set all titles to horizontal
              'link_color', {'tick','title','outline','grid'},... % Link all axes colors
              'titleshift',[ -0.22, 0, 0.22; 0.085, -0.11, 0.085 ]... % shift titles
              'tickshift', [-0.03, -0.03, 0.0; 0.01,-0.03,0]
            };
    
	% Ternary Axes Outline   - Passed directly to plot3() 
    vout  = { 'LineWidth', 5, 'LineStyle', ':'};
        
    % Ternary gridlines  - Passed directly to plot3()
    vgrid = { 'LineStyle','-','LineWidth',0.5,'Color',[0 0 0 0.2] };
        
    % Ternary Tick Labels - Passed directly to text()
    vtick = { 'FontWeight','Bold', 'FontSize', 8 };
       
    % Ternary Axes Label  - Passed directly to text()
    vlab  = { 'FontWeight','normal', 'FontSize', 14 };
        
    % Create Ternary Axes & return Handle
    axes( ax2 ); % Select second subplot
    handle = ternary_axes( vgen, vout, vgrid, vtick, vlab );

%% (6) Get a set of A,B,C Test points
%      - Rows of A,B,C triplets for uniformly-spaced data, assuming 20 grid
%        points along each of the three axes, bounded by wlimits defined
%        earlier
     [A,B,C] = ternary_arrays( 20, wlimits );
 
 
%% (7) Create example data
     Z = A.*2.0 + 1.5.*B.^1.2 - 5.0*sqrt(C);
    
 
%% (8) Plot the surface Z defiend on rows of ABC points in xmat
    
    % Define a customized color bar
    Cbar = {'FontWeight','bold','Position',[0.90 0.17 0.02 0.68] };
    
    % Create Surface Plot + colorbar
    handle = ternary_surf( handle, 'l', A, 'b', B, Z , Cbar );
    
    % Set shading (e.g. flat or interp)
    shading(ax2, 'flat')
    
    % Set colormap
    colormap(ax2, bone)
    
    % Add Title
    title('A Fruity Example','FontSize',18)

%% (9) Adjust Colors of axes

    % Using helper function to get the right axis index
    iaxis = identify_ternary_axis( 'left' ); 
    
    % Change color by changing one element ("link_color" determines
    % linking)
    handle.title.text(iaxis).Color = [0.6353    0.0784    0.1843];
    

 