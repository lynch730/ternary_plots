function ternary_shift_ABC(handle,name,object,shift)
% ternary_shift_ABC Shift  ternary objects in groups along ternary
% coordinates
%   
%   Ternary handle is used to find objects to shift along "name" axis.
%   Object is a string that identifies the object set (i.e."outline" "grid"
%   "tick" "name") to be moved. Shift is a 3-element float array,
%   containing [deltaA, deltaB, deltaC] shifts. One of the elements can be
%   empty, otherwise A/B are used. 

    % Check Inputs
    if (nargin<4)
       error('Too Few inputs') 
    end
    
    % Process name
    iaxis = ternary_axis_name(name);
    
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
    
    % Get index of shift axis to ignore
    if any(shift==0)
        idx = 3;
    else
        idx = find(shift==0,1);
    end
    
    % Get dx/dy
    for i=1:numel(object)
        
        % Location of object
        x1 = object(i).Position(1);
        y1 = object(i).Position(2);
        
        % Current ABC Location from Position
        [A,B,C] = cart2tern( x1, y1 );
        
        % Get New ABC Location
        A = A + shift(1);
        B = B + shift(2);
        C = C + shift(3);
        
        % Fork Type
        if ( idx == 3 )
            [x1,y1] = tern2cart( 1, A, 2, B );   
        elseif ( idx == 2 )
            [x1,y1] = tern2cart( 1, A, 3, C );
        elseif ( idx == 1 )
            [x1,y1] = tern2cart( 2, B, 3, C );
        else
            error('Bad Index of selection')
        end
        
        % Apply
        object(i).Position(1) = x1;
        object(i).Position(2) = y1;
        
    end
    
end

