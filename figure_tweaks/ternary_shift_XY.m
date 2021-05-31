function handle = ternary_shift_XY( handle, axis_name, object, shift )
% ternary_shift_XY Shift ternary objects in groups along cartesian coord.
%   
%   Ternary handle is used to find objects to shift along "name" axis.
%   Object is a string that identifies the object set (i.e."outline" "grid"
%   "tick" "name") to be moved. Shift is a 2-element float array,
%   containing [deltaX, deltaY ] shifts.

    % Check Inputs
    if (nargin<4)
       error('Too Few inputs') 
    end
    
    % Reshape to match Position Array
    shift = reshape( shift, [1,2] );
    
    % Process name
    iaxis = identify_ternary_axis(axis_name);
    
    % Test object string
    switch object
        case 'outline'
           handle.outline.lines(iaxis).Position(1:2) =  ...
           handle.outline.lines(iaxis).Position(1:2) + shift(1:2);
            
        case {'grid','gridlines'}
            for i=1:numel(handle.grid.lines(:,iaxis))
               handle.grid.lines(i,iaxis).Position(1:2) =  ...
               handle.grid.lines(i,iaxis).Position(1:2) + shift(1:2);
            end
            
        case {'tick','ticks'}
            for i=1:numel(handle.tick.text(:,iaxis))
               handle.tick.text(i,iaxis).Position(1:2) =  ...
               handle.tick.text(i,iaxis).Position(1:2) + shift(1:2);
            end
            
        case {'titles','title'}
            handle.title.text(iaxis).Position(1:2) =  ...
            handle.title.text(iaxis).Position(1:2) + shift(1:2);
            
        case {'ternary','tern'}
            ax = gca; % get current "axes" handle 
            ax.Position(1:2) = ax.Position(1:2) + shift(1:2);
            
        otherwise
            error('Invalid Object Matching')
    end
    
end

