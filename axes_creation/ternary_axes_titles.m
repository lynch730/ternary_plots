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
   for iaxis=1:3
        
        % Get the axis to the right
        iright = iaxis + 1;
        if ( iright == 4 )
            iright = 1;
        end
        
        % Add customized alignement to varargin
        var = [ varargin(:)', 'horizontalalignment', 'center', ...
                              'verticalalignment',  'middle', ...
                              'rotation', handle.title.rotation(iaxis) ];
        
        % Title String
        str = handle.title.titlelabels{iaxis};
        
        % Local copy of wlimits 
        wlimits = handle.grid.wlimits;
        
        % Get Halfway point
        delta = ( wlimits(2,iaxis)-wlimits(1,iaxis) );
        E_half = 0.5*delta + wlimits(1,iaxis);
        
        % Plot Text
        handle.title.text(iaxis) = ternary_text( wlimits, iaxis, E_half, iright, wlimits(1,iright), ...
                                                str, [], var{:} );
        
   end
    
end
