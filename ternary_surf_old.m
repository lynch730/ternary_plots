function handle = ternary_surf(xmat, Z, wlimits, axes_names)
% ternary_surf  basic ternary plot (axes, gridlines, labels + Surface)
% 
%   This creates a ternary surface plot from two or three columns of
%   ternary coordinates in xmat, and in the column vector Z. Each row is a
%   coordinate A,B,C, which are assumed to range between 0-1 if no other
%   inputs are supplied.
%
%   Optional inputs include wt_limits, which is the 2x3 matrix that stores
%   the axes limits (this is required if xmat contains rows which do not
%   sum to one!). Axes_names may also be supplied as a cell array of
%   strings (default labels are Variable A, Variable B, ... )
% 
%   For each of the sub-functions (axes creation, grid lines, etc) default
%   settings are used, and can be edited using the returned handles.
%   Otherwise, ternary_surf can be customized by invidualzed function calls
%   in the main script.
    
    %% Process Input matrix

    % Check argument count
    if nargin < 2
        error('Error: Not enough input arguments.');
    end
    
    % Give axes name
    if nargin < 4
        axes_names = {'Variable A','Variable B','Variable C'};
    end
    
    % If not given, default wlimits to 0->1
    if nargin < 3
        wlimits(1,1:3) = 0.0; 
        wlimits(2,1:3) = 1.0;
    end
    
    % Compute wsum from wlimits
    wsum = wlimits(1,1) + wlimits(2,3) + wlimits(1,3);
    
    %  Get Third Column if not given
    if ( size(xmat,2) < 2 )
       error('Need to provide at least two columns')
    elseif ( size(xmat,2) < 3 ) 
        xmat = [ xmat, wsum-xmat(:,1)-xmat(:,2) ];
    end
    
    
    
    % Obtain axis limits in 0->1 range by conversion
    A = ( xmat(:,1) - wlimits(1,1) ) ./ ( wlimits(2,1) - wlimits(1,1) );
    B = ( xmat(:,2) - wlimits(1,2) ) ./ ( wlimits(2,2) - wlimits(1,2) );
    C = ( xmat(:,3) - wlimits(1,3) ) ./ ( wlimits(2,3) - wlimits(1,3) );
    
%% Plot the surface

fig = figure('name','Ternary Plot','DeleteFcn','doc datacursormode');
fig.Position = [ 100 100 750 750];

% Edit axes Specs
ax = gca;
ax.Position(1) = 0.10;
ax.Position(2) = 0.05;

% Turn hold on
hold on

% Convert to cartesian
[x,y] = tern_to_cart( 1, A, 2, B );

% Create the trisurf plot
tri = delaunay(x,y);
handle.patch = trisurf( tri, x, y, Z );

% Set the shading type
font_weight = 'bold';
% shading interp; 
shading flat

% Set the colormap
colormap parula

%% Add custom Data tip
dcm_obj = datacursormode(fig);
set(dcm_obj,'UpdateFcn',{@update_data_cursor,handle.patch.ZData,wt_limits,spec_names})

%% minor-axes lines

% Set the number of fin axes lines to overlay
n_axes_grid_count = 6;

% linespec
line_style = '-';
line_width = 1.25;
line_color = [0 0 0 0.3];

% Set an arbitarty Location above surf plot in Z
zloc(1:2,1) = max(Z)*1.02;

% Cos/Sin of equalateral, or the x/y of the unit hypotenuse/edge length
unit_cos = cos(pi/3);
unit_sin = sin(pi/3);

% Starting positions from [0-1] along each axis, ignoring ends (+2)
fraction_limits = linspace( 0, 1, n_axes_grid_count+2);

% grid line off-axis
% grid_line_overshoot = 0.05; % relative to 1

% Set Format identifier
fmt = '%4.1f';

% Calculate Tick Values fromm the user-supplier limits
x_cea = zeros( length(fraction_limits), 1);
for i=1:3
    x_cea(:,i) = linspace( wt_limits(1,i), wt_limits(2,i), length(fraction_limits) );
end    

% Loop Starting Conditions
 dx = 1e9;

% Font size starting conditions
tick_label_size = 60;

% Spacing in plot units from each grid line
dx_grid = 1.0./(n_axes_grid_count+1.0);

% Decrease font size until the 2nd edge can contain and not overlap
while dx > 0.5*dx_grid && tick_label_size> 4 
    tick_label_size = tick_label_size-1;
    str = num2str( x_cea(3,2), fmt );
    h = text(0, 0, str, 'FontSize',tick_label_size, 'visible','off','units','data');

    % Get sizes
    dx = h.Extent(3);
    dy = h.Extent(4);

    delete(h);

%     [dx, ~ ] = obtain_textbox_size( tick_label_size,  ) ;
end

% Now do all 3 once more
dx = zeros(3,1); dy = dx;
for i=1:3
    str = num2str( x_cea(3,i), fmt );
    h = text(0, 0, str, 'FontSize',tick_label_size, 'visible','off','units','data');
    
    % Get sizes
    dx(i) = h.Extent(3);
    dy(i) = h.Extent(4);

    delete(h);
    
%    [dx(i,1),dy(i,1)] = obtain_textbox_size( tick_label_size, num2str( x_cea(3,i), fmt ) ) ;
end
    
% Loop each interior axis position (left to right on each axis edge)
for i=1:length(fraction_limits)
    
    % Distance along edge or ternary axis from left (looking from outside
    % toward plot). Ticks are always form RHS acute angles with axis. 
    edge_left  = fraction_limits(i);
    
    % Offsets are obtained by the size of the font box in dx/dy
    % for left, hieght of text drives the size, with margin (x2)
    grid_line_overshoot = dy(1)*1.5;
    
    % Plot lines from axis 1 - looking from NW to SE
    [xp(1),yp(1)] = tern_to_cart( 1, edge_left, 2, - grid_line_overshoot );
    [xp(2),yp(2)] = tern_to_cart( 1, edge_left, 3, 0 );
    handle.grid(i,1) = plot3( xp, yp, zloc, ...
                              'Linestyle', line_style, ...
                              'LineWidth', line_width, ...
                              'color'    , line_color );
   
    % String Tick Label, place with upper-right corner at end of line end
    str = num2str( x_cea(i,1), fmt );

    % Place text vertically halfway from end point to axis edge
    [~,yavg] =  tern_to_cart( 1, edge_left, 2, 0 );
    handle.tick_label(i,1) = text( xp(1), yavg, str, ...
                                   'fontweight', font_weight,...
                                   'horizontalalignment','right',...
                                   'verticalalignment','bottom',...
                                   'units','data');
                               
    % Offsets are obtained by the size of the font box in dx/dy
    % for left, hieght of text drives the size, with margin (x2)
    grid_line_overshoot = dy(2)*1.75;
       
    % Plot lines from axis 2
    [xp(1),yp(1)] = tern_to_cart( 2, edge_left, 3, - grid_line_overshoot );
    [xp(2),yp(2)] = tern_to_cart( 2, edge_left, 1, 0 );
    handle.grid(i,2) = plot3( xp, yp, zloc, ...
                              'Linestyle', line_style, ...
                              'LineWidth', line_width, ...
                              'color', line_color );
                  
    % String Tick Label, place to the lower-left of line extension end
    str = num2str( x_cea(i,2), fmt );
    handle.tick_label(i,2) = text( xp(1)+0.03,yp(1), str, ...
                                  'fontweight', font_weight,...
                                  'horizontalalignment','left', ...
                                   'verticalalignment','bottom',...
                                   'units','data');
 
                               
    % Offsets are obtained by the size of the font box in dx/dy
    % for left, hieght of text drives the size, with some margin
    grid_line_overshoot = dx(3)*1.2;
    
    % Plot lines emenating from axis 1 
    [xp(1),yp(1)] = tern_to_cart( 3, edge_left, 1, - grid_line_overshoot );
    [xp(2),yp(2)] = tern_to_cart( 3, edge_left, 2, 0 );
    handle.grid(i,3) = plot3( xp, yp, zloc, ...
                              'Linestyle', line_style, ...
                              'LineWidth', line_width, ...
                              'color', line_color );
                          
    % String Tick Label, place to the lower-left of line extension end
    str = num2str( x_cea(i,3), fmt );
    handle.tick_label(i,3) = text( xp(1),yp(1), str, ...
                                  'fontweight', font_weight,...
                                  'horizontalalignment','right', ...
                                  'verticalalignment','bottom',...
                                  'units','data');   
   
end

% Plot Boundaries along verticies
handle.border = plot( [0 1 0.5 0], [0 0 sqrt(3)/2 0], 'k-','linewidth',2);


%% Add Labels
% Note, the x/y coordinates have to be compted from the relative position
% along the axis edge.

% Approx. middle index for getting extent
idx = round(0.5*length(fraction_limits));

% Normalized Distance from back of text
offset = 0.04;

% Second Species (left)                
x = cos(pi/3)*0.5 - offset*cos(pi/3) - handle.tick_label(idx,2).Extent(3);
y = sin(pi/3)*0.5 + offset*sin(pi/3) + handle.tick_label(idx,2).Extent(4);
handle.spec_label(2) = text( x, y, spec_names{1}, ...
                            'horizontalalignment','center',...
                            'verticalalignment','bottom',...
                            'rotation', 60, ...
                            'fontweight', font_weight, ...
                            'fontsize', 12 );
                        
% First Species
x = 0.5;
y = -offset - handle.tick_label(idx,1).Extent(4);
handle.spec_label(1) = text( x, y, spec_names{2}, ...
                            'horizontalalignment','center',...
                            'verticalalignment','top',...
                            'fontweight', font_weight, ...
                            'fontsize', 12 );

% Third Species            
x = 1.0 - cos(pi/3)*0.5 + offset*0.8*cos(pi/3) + handle.tick_label(idx,3).Extent(3);
y =       sin(pi/3)*0.5 + offset*0.8*sin(pi/3) + handle.tick_label(idx,3).Extent(4);
handle.spec_label(3) = text( x, y, spec_names{3}, ...
                            'horizontalalignment','center',...
                            'verticalalignment','bottom',...
                            'rotation', -60, ...
                            'fontweight', font_weight, ...
                            'fontsize', 12 );

%% Finalize Ternary Plot

% Make axes equal and add a nice surrounding
axis image;

% Turn off normal x/y axes
axis off;

% Set Color Axis Range
caxis([min(Z) max(Z)]);

% Default 2D view
view(2);

% Add colorbar
handle.colorbar = colorbar;
z
% Make it equal to fontweight
handle.colorbar.FontWeight = font_weight;
handle.colorbar.Position(1:4) = [0.88, 0.3, 0.03, 0.6];

% Add Title
handle.title = title({'CEA Ternary Plot';z_name});
handle.title.Position(2) = 0.97;
handle.title.FontWeight = font_weight;
handle.title.FontSize = 14;

end

% This function gets a custom data tip that returns WT fractions, not X/Y
% coordinates. 
function txt = update_data_cursor(~,event_obj,Z,wt_limits,spec_names)

% Get the Index of the point
I = get(event_obj, 'DataIndex');

% Max length of Species
% spec_names = pad(spec_names);

% Get Coordinates
pos = get(event_obj,'Position');
[A,B,C] = cart_to_tern( pos(1),pos(2) );

% Get In CEA Terms
A = A*( wt_limits(2,1) - wt_limits(1,1) ) + wt_limits(1,1);
B = B*( wt_limits(2,2) - wt_limits(1,2) ) + wt_limits(1,2);
C = C*( wt_limits(2,3) - wt_limits(1,3) ) + wt_limits(1,3);

% Get a new text array
txt = { ['Spec #1 wt%=', num2str(A,'%4.1f')],...
        ['Spec #2 wt%=', num2str(B,'%4.1f')],...
        ['Spec #3 wt%=', num2str(C,'%4.1f')],...
        ['Value:  ', num2str( Z(I) )   ] };
 
end
