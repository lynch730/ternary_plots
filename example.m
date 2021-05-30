% Example.m. This script shows an example of how to create and manipulate
% tenary plots.

clear all; close all; clc

%% (0) Add paths 
%      - This function can be run automatically if copied into "userpath/sartup.m
add_ternary_paths

%% (1) Determine ternary axis limits
%      - Set sum of each point to 100, set three values to specify the
%        triangle
wlimits = ternary_axes_limits( 100,'l',23,'low',...
                                   'l',54,'high',...
                                   'r',15,'low', true );
                               

%% (2) Get axis arrays
%      - Rows of A,B,C triplets for uniformly-spaced data, assuming 10 grid
%        points along each of the three axes
 xmat = ternary_arrays( 10, wlimits );
 
%% (3) Create example data
 Z = xmat(:,1)*2.0 + xmat(:,2).^2.0 - sqrt(xmat(:,3));
  
%% (4) Generate base axes to plot on
%     
%    4A - Specify Settings
     vgen  = { 'wlimits', wlimits, 'usegridspace', false, 'gridspaceunit',6 };
     vout  = { 'LineWidth', 2, 'Color','k'};
     vgrid = { 'LineStyle','-','Color',[0 0 0 0.4] };
     vtick = { 'FontWeight','Bold', 'FontSize', 12 };
     vlab  = { 'FontWeight','Bold', 'FontSize', 14 };
    
%    4B -  Create Ternary Axes
     ax = ternary_axes( vgen, vout, vgrid, vtick, vlab );
      
%% (5) Add ternary data to the plot
%     ax = ternary_surf(ax, Z, wlimits );
 
 