function handle = ternary_axes( var_general, var_outline, var_grid, ...
                                var_tick_line, var_tick_label, var_label )
% ternary_axes create basic outline, gridlines, and labels for a ternary plot
%
%   handle contains children handle groups for the outline, grid lines, tick
%   marks, tick labels, and axes labels (e.g. ax.Children.outline,
%   ax.Children.grid, etc ). 
%
%   INPUTS: (All must be in order, filled with [] if not provided, unless
%   none are provided, in which case defaults are used. initialize_ternary_handle()
%   contains the defaults and the procedure for overwritting them with user inputs
% 
%   (1) var_general: cell array containing options specific to ternary
%   plots, identified in pairs of identifier strings and values: 
%
%     Default Ternary Settings
%     "wlimits"        - (2x3 float ), Axis limits                
%     "usegridspace"   - (true/false), attempt increment-spacing of 
%                                      "gridspaceunit", not linspace
%     "gridspaceunit"  - (int/float ), Grid unit                 
%     "ticklinelength" - (float     ), Adds ticks to gridlines   
%     "tick_fmt"       - (string    ), Tick text format 
%     "axeslabels"     - (cell array), Names of Axes            
%      
%      Default Custom Shifts (in X/Y): 
%     "ternaryshift"   - (2x1 float ), Whole Ternary 
%     "titleshift"     - (2x3 float ), Axes Titles
%     "tickshift"      - (2x3 float ), Tick Labels
%       
%   (2) var_outline  - Triangle "box,"  inherited by "plot()" as varargin
%   (3) var_grid     - Grid lines,      inherited by "plot()" as varargin
%   (4) var_tick     - Tick labels,     inherited by "text()" as varargin
%   (5) var_label    - Axes Text Label, inherited by "text()" as varargin
%  

    %% Check inputs
    if nargin == 0
        var_general = {}; 
    end
    if nargin < 2
        var_outline = {}; 
    end
    if nargin < 3
        var_grid = {}; 
    end    
    if nargin < 4
        var_tick_line = {}; 
    end   
    if nargin < 5
        var_tick_label = {}; 
    end   
    if nargin < 6
        var_label = {}; 
    end  
    
    
    %% Initalize Ternary Handle
    handle = initialize_ternary_handle( var_general );
    
    
    %% Create grid spacing data for ternary
    handle.grid.grid_pnts = axes_grid_spacing( handle.grid );
    
    
    %% Call creation of each element
    
    % Turn on hold
    hold on
    
    % Call creation of outline frame
    handle = ternary_outlines(    handle, var_outline{:} );
    
    % Call creation of grid lines
    handle = ternary_grid_lines(  handle, var_grid{:}    );

    % Call Tick Lines
    handle = ternary_tick_lines(  handle, var_tick_line{:}    );
    
    % Call Tick Labels
    handle = ternary_tick_labels( handle, var_tick_label{:}    );
    
    % Call Axis Lab  
    handle = ternary_axes_titles( handle, var_label{:}   );
    
    
    %% Apply Custom Shifts 
    handle = ternary_shift_XY( handle, 1, 'ternary', handle.ternaryshift );
    for i=1:3
        handle = ternary_shift_XY( handle, i, 'title', handle.title.shift(:,i) );
        handle = ternary_shift_XY( handle, i, 'tick',  handle.tick.shift( :,i) );
    end
    
    
    %% Finalize Axes Appearance (may need to repeat after subsequent plots)
    
    % Correct Axes framing
    axis image;
    
    % Turn off axes framing
    axis off;
    
    % Default view
    view(2);
    
    
end

%% Interpret Var_General Input
function handle = initialize_ternary_handle( var_general )
    
    %% Basic Setup of Handle
    
    % Store current MATLAB axes handle to ternary handle
    handle.ax = gca;
    
    % Empty Dataplots
    handle.dataplots = [];
    
    %% Setup Default Settings
    
    % Default Ternary Settings
    tern_set.wlimits        = ternary_axes_limits; % 0->1
    tern_set.usegridspace   = false; 
    tern_set.gridspaceunit  = 6;
    tern_set.ticklinelength = 0.08; 
    tern_set.tick_fmt       = '%2.1f';
    tern_set.titlelabels     = {'Variable 1','Variable 2','Variable 3'}; 
    tern_set.titlerotation  = [60.0, 0.0, -60.0]; 
    tern_set.ternaryshift    = [-0.02, -0.01]; 
    tern_set.link_color     = {'tick','title','outline'}; % excludes grid
    
    % Default Shifts (in X/Y)
    tern_set.titleshift(1:2,1) = [-0.15,  0.075 ];
    tern_set.titleshift(1:2,2) = [ 0.0, -0.11 ];
    tern_set.titleshift(1:2,3) = [ 0.15,  0.075 ];
    tern_set.tickshift(1:2,1)  = [-0.03,  0.0  ]; 
    tern_set.tickshift(1:2,2)  = [-0.03,  0.0  ];
    tern_set.tickshift(1:2,3)  = [ 0.0,   0.0  ];
    
    %% Overwrite Default Settings with User Supplied Settings 
    if ~isempty( var_general )
        
        % Number of entries
        n = numel( var_general );
        
        % Check that gridspaceunit is given if usedgridspace is on
        if ( any(contains(var_general(1:2:n),'usegridspace' )) && ...
            ~any(contains(var_general(1:2:n),'gridspaceunit')) )
            warning([ 'Must specify a grid spacing increment with',...
                      ' "usegridspace" activated!' ])
        end
        
        % Loop through pairs of inputs in var_general
        for i=1:2:n
            
            % Copy string identifier to field
            field = var_general{i};
            
            % Test if it matches one of the defauls
            if ( isfield( tern_set, field ) )
                tern_set.( field ) = var_general{i+1};
            else % throw error
                warning( ['Field ', field, ...
                          ' was not valid. Entry ignored!' ] )
            end
            
        end
        
    end
    
    %% Store Settings in local elements of handle
    
    % Figure shift
    handle.ternaryshift        = tern_set.ternaryshift;
    handle.link_color          = tern_set.link_color;
    
    % Title Handle
    handle.title.titlelabels   = tern_set.titlelabels;
    handle.title.shift         = tern_set.titleshift;
    handle.title.rotation      = tern_set.titlerotation;
    
    % Tick Data
    if ( numel( tern_set.ticklinelength ) )
        tern_set.ticklinelength(1:3) = tern_set.ticklinelength;
    end
    handle.tick.ticklinelength = tern_set.ticklinelength;
    handle.tick.tick_fmt       = tern_set.tick_fmt;
    handle.tick.shift          = tern_set.tickshift;
    
    % Grid Data
    handle.grid.usegridspace  = tern_set.usegridspace;
    handle.grid.gridspaceunit = tern_set.gridspaceunit;
    handle.grid.wlimits       = tern_set.wlimits;
    handle.grid.wsum          = sum( tern_set.wlimits(1,1) + ...
                                     tern_set.wlimits(2,2) + ...
                                     tern_set.wlimits(1,3) );
    
end


%% Axes grid spacing
function grid_pnts = axes_grid_spacing( grid )
    
    % default grid spacing applied to all three axes
    grid_flag(1:3) = grid.usegridspace;
    
    % Try to create grid with increment on each axis, if activated
    if (grid.usegridspace)
        
        % Loop Each Axis
        for i=1:3
            
            % Convert to plot units (0->1)
            gridspace = ( grid.gridspaceunit  ) ./ ...
                         ( grid.wlimits(2,i) - grid.wlimits(1,i) ) ;
           
            % Make array based on increment
            grid_pnts(i).values(:) = [0:gridspace:1.0];
            
            % Check for failure and reset/clear to linspace
            if (numel(grid_pnts(i).values)<=1)
                warning('gridspaceunit failed as increment, reverting to linspace');
                grid.gridspaceunit = 6;
                grid_flag(i)  = false;
            end
            
        end
        
    end
    
    % On each axis, if not spacing on increment, space on linspace
    for i=1:3
        if (~grid_flag(i))
            grid_pnts(i).values = linspace( 0, 1, grid.gridspaceunit );
        end
    end    
    
    % Convert to user-supplied ABC Limits
    for i=1:3
        delta = grid.wlimits(2,i) - grid.wlimits(1,i);
        grid_pnts(i).values = grid_pnts(i).values*delta + grid.wlimits(1,i);
    end    
    
end
