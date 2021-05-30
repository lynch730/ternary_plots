function handle = ternary_axes_names( handle, offset, axes_labels, var_label )
%ternary_axes_names plot axes titles
%
%   axes_labels is 3-element cell array
%
   
   %% Check inputs
   if ( nargin < 1 )
       error('Too few inputs')
   elseif ( nargin < 3 )
       axes_labels = {'Variable 1','Variable 2','Variable 3'}; 
   end
   
   % Fork offset
   if (nargin < 2)
      offset = 0.0;
   end
    
   % Rotation of variables
   rot = [60.0, 0.0, -60.0];
   
   % Offset distances in X/Y Coordinates
   offmat(1:2,1) = [-offset, offset].*sqrt(2);
   offmat(1:2,2) = [0, -offset];
   offmat(1:2,3) = [offset, offset].*sqrt(2);
   
   % Custom Y displacement on Left/Right
   offmat(2,1) = offmat(2,1) - 0.05;
   offmat(2,3) = offmat(2,3) - 0.05;

   %% Loop Axes
   for i=1:3
       
        % Get the axis to the right
        ip=i+1;
        if (ip==4)
            ip=1;
        end
        
        % Get Cartesian for middle-placed title
        [xp,yp] = tern2cart( i, 0.5 , ip, 0.0 );
        
        % Add offset distance
        xp = xp + offmat(1,i);
        yp = yp + offmat(2,i);
        
        % Calculate 
        handle.names.text(i) = text( xp(1), yp(1), axes_labels{i}, ...
                                   'horizontalalignment','center', ...
                                   'verticalalignment',  'middle', ...
                                   'rotation', rot(i), ....
                                   var_label{:} );
      
   end
   

end
