% basic_example.m This script shows a bare-bones example of creating and
% plotting ternary data

% (1) Add paths 
    add_ternary_paths
    
% (2) Create Basic Ternary Axes (Sides Ranging from 0-1)
    handle_base  = ternary_axes; 
    
% (3) Get a set of A,B,C Test points, assuming 20 points along each side
    [A,B,C] = ternary_arrays( 20 );
    
% (5) Create example data
    Z = (A+10)*2.0 + 10*B.^1.2 - 5*sqrt(C*5);
    
% (6) Plot the surface Z defiend on rows of ABC points in xmat
    
    % Create Surface Plot
    dataplots(1).obj = ternary_surf( [], 'l', A, 'b', B, Z ,'none');
    
    % Add Title
    title('A Basic Example','FontSize',18)
    
% (7) Restack Data Plots
    handle_base = restack_dataplots(handle_base, dataplots);