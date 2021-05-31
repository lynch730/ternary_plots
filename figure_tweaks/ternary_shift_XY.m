function ternary_shift_XY(handle,name,object,shift)
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
    
    % Process name
    iaxis = identify_ternary_axis(name);
    
    % Test object string
    switch object
        case 'outline'
            object = handle.outline.lines(iaxis);
        case {'grid','gridlines'}
            object = handle.grid.lines(:,iaxis);
        case 'tick'
            object = handle.tick.text(:,iaxis);
        case {'name','titles'}
            object = handle.names.text(iaxis);
        otherwise
            error('Invalid Object Matching')
    end
    
    % Get dx/dy
    for i=1:numel(object)
        object(i).Position(1:2) = object(i).Position(1:2) + shift(1:2);
    end
    
end

