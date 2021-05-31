function handle = ternary_axes_titles( handle, varargin )
%ternary_axes_names plot axes titles
%
%
    % Check if handle is given
    if (nargin==0)
       error('Too few inputs') 
    end
    
    % Create defaul settings if no extra arguments supplied
    if ( nargin < 2 || isempty( varargin ) )
        varargin = { 'FontWeight','Bold', 'FontSize', 14 };
    end
    
   %% Loop Axes
   for i=1:3
        
        % Get the axis to the right
        ip=i+1;
        if (ip==4)
            ip=1;
        end
        
        % Get Cartesian for middle-placed title
        [xp,yp] = tern2cart( i, 0.5 , ip, 0.0 );
        
        % Calculate 
        handle.title.text(i) = text( xp(1), yp(1), handle.title.titlelabels{i}, ...
                                   'horizontalalignment','center', ...
                                   'verticalalignment',  'middle', ...
                                   'rotation', handle.title.rotation(i), ....
                                   varargin{:} );

   end
    
end
