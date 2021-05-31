function idx = identify_ternary_axis( name )
%identify_ternary_axis ternary axis interpreter
%   
%   returns the correct axis index for different names. Ternary axis numbers
%   1,2,3 correspond to string inputs left/bottom/right or l/b/r. bottom=bot. 

    % Determine if name is a string
    if ( ischar(name) )
        
        % If string, determine if it matches a known input
        switch name
            case 'left'
                idx = 1;
            case 'l'
                idx = 1;
            case 'bottom'
                idx = 2;
            case 'bot'
                idx = 2;
            case 'b'
                idx = 2;
            case 'right'
                idx = 3;
            case 'r'
                idx = 3;
            otherwise
                error(['Name "',name,'" does not match a correct input string']) 
        end
        
    % Given a numeric value
    elseif ( isnumeric( name ) )
        
        % If integer
        if ( name == floor(name) )
            
            % If integer in correct range
            if (name <= 3 && name > 0)
                idx = name;
            else
                error(['Name "',name,'" is not 1, 2, or 3']) 
            end
            
        else
            error(['Name "',name,'" is not an integer']) 
        
        end
        
    else 
        error(['Name "',name,'" is not a number or string']) 
    
    end
    
end