% Example.m. This script shows an example of how to create and manipulate
% tenary plots.

clear all; close all; clc

%% (1) Add paths 
%      - This function can be run automatically if copied into "userpath/sartup.m
add_ternary_paths


%% (2) Determine ternary axis limits
%      - Set sum of each point to 100, set three values to specify the
%        triangle
    wlimits = ternary_axes_limits( 100,'l',0,'low',...
                                       'l',100,'high',...
                                       'r',0,'low' );
                               
                                   
%% (3) Create the Axes
    
    % Custom settings specific to Ternary_Plots, wlimits allows for axes to
    % have labels that correctly match the data
    vgen  = { 'wlimits', wlimits };
    
	% Ternary Axes Box   - plot3() settings
    %     vout  = { 'LineWidth', 2, 'Color','k'};
    %     
        % Ternary gridlines  - plot3() settings
    %     vgrid = { 'LineStyle','-','Color',[0 0 0 0.4] };
    %     
        % Ternary Tick Labels - text() settings
    %     vtick = { 'FontWeight','Bold', 'FontSize', 12 };
    %     
        % Ternary Axes Label  - text() settings
    %     vlab  = { 'FontWeight','Bold', 'FontSize', 14 };
    %     
        % Create Ternary Axes & return Handle
    %     handle = ternary_axes( vgen, vout, vgrid, vtick, vlab );
    handle = ternary_axes(vgen);

%% (4) Get a set of A,B,C Test points
%      - Rows of A,B,C triplets for uniformly-spaced data, assuming 10 grid
%        points along each of the three axes
     [A,B,C] = ternary_arrays( 20, wlimits );
 
 
%% (5) Create example data
     Z = A.*2.0 + 1.5.*B.^1.2 - 5.0*sqrt(C);
    
 
%% (6) Plot the surface Z defiend on rows of ABC points in xmat
    
    % Create Surface Plot
%     handle = ternary_surf( handle, 'l', A, 'b', B, Z );
    handle = ternary_scatter3( handle, 'l', A, 'b', B, Z );

    % Set shading (e.g. flat or interp)
    shading interp
    
    % Set colormap
    colormap pink
    
    % Add Title
    title('Example Ternary Plot','FontSize',18)

 