% basic_example.m This script shows a bare-bones example of creating and
% plotting ternary data

clear all; close all; clc

% (1) Add paths 
    add_ternary_paths

% (2) Create Basic Ternary Axes (Sides Ranging from 0-100)
    wlimits = ternary_axes_limits( 100 ) ;
    handle  = ternary_axes( { 'wlimits',  wlimits } ); 

% (3) Get a set of A,B,C Test points, assuming 20 along each side
    [A,B,C] = ternary_arrays( 20, wlimits );
 
% (5) Create example data
    Z = (A+10)*2.0 + 10*B.^1.2 - 5*sqrt(C*5);
    
% (6) Plot the surface Z defiend on rows of ABC points in xmat
    
    % Create Surface Plot
    handle = ternary_surf( handle, 'l', A, 'b', B, Z ,'none');
    
    % Add Title
    title('Example Ternary Plot','FontSize',18)

 