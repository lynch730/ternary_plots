function handle = ternary_tick_labels( handle, grid_pnts, wlimits, tick_fmt, ... 
                                       customshift, var_tick )
% ternary_tick_labels create axes tick labels
%   
%   Inputs 
%

    %% Input Checking
    if (nargin < 2)
        error('Too few inputs')
    elseif (nargin < 3)
      wlimits(1,1:3) = 0; wlimits(2,1:3) = 1;
    end
    
    % Check tick formatting
    if (nargin < 4)
        tick_fmt = '%4.1f';
    end

    % Check customshift
    if (nargin < 5)
        customshift(1:2,1) = [-0.03, 0.0]; %dx/dy
        customshift(1:2,2) = [-0.03, 0.0];
        customshift(1:2,3) = [  0.0, 0.0];
    end 
    
    % Alter grid points to be in data units (not 0->1)
    
    % Alignment Storage
    hz = {'right', 'right',   'left'};
    vz = {'bottom',  'top', 'bottom'};

    %% Loop Axes
    for iaxis=1:3
        
        % Obtain Plot Points
        plt_pnts = grid_pnts(iaxis).values.*( wlimits(2,iaxis) ...
                                   - wlimits(1,iaxis) ) + wlimits(1,iaxis);
        
        % Loop Grid
        for i=1:numel(grid_pnts(iaxis).values)
            
            % Get local coordinate
            [A,B,~] = tern2base( iaxis, grid_pnts(iaxis).values(i), 1.0, 0.0);
            
            % Convert to X/Y coordinates
            [xp,yp] = tern2cart(1,A,2,B);
            
            % Apply shifts
            xp = xp + customshift(1,iaxis);
            yp = yp + customshift(2,iaxis);
            
            % String Tick Label, place with upper-right corner at end of line end
            str = num2str( plt_pnts(i), tick_fmt );
            
            % Place text vertically halfway from end point to axis edge
            handle.tick.text(i,iaxis) = text( xp(1), yp(1), str, ...
                                         'horizontalalignment',hz{iaxis},...
                                         'verticalalignment',  vz{iaxis},...
                                         'units','data',var_tick{:} );
            
       end
       
   end
   
end
