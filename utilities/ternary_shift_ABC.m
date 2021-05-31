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
    
    % Get dx/dy
    for i=1:numel(object)
        
        % Location of object
        x1 = object(i).Position(1);
        y1 = object(i).Position(2);
        
        % Apply A/B/C Shift in order
        for j = 1:3
            
            % Current ABC Location from Position
            [A,B,C] = cart2tern( x1, y1 );
            
            % Fork Type of Shift
            if ( j == 1 )
                A = A + shift(j);
                C = C - shift(j);
                [x1,y1] = tern2cart( 1, A, 3, C );   
            elseif ( j == 2 )
                B = B + shift(j);
                A = A - shift(j);
                [x1,y1] = tern2cart( 1, A, 2, B );
            elseif ( j == 3 )
                C = C + shift(j);
                B = B - shift(j);
                [x1,y1] = tern2cart( 2, B, 3, C );
            else
                error('Bad Index of selection')
            end
            
       % end
        
        % Apply Final Shift
        object(i).Position(1) = x1;
        object(i).Position(2) = y1;
        
    end
            
    end
    
end

