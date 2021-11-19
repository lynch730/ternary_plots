function idx = identify_ternary_axis( keyword )
%identify_ternary_axis ternary axis interpreter
%   
%   Returns the correct axis index for a given keyword. Ternary axis index
%   numbers 1,2,3 correspond to ABC, with key letters a/b/c or l/b/r
%   (left/bottom/right). 
%
%   NOTE: Keyword cannot contain mixed key letters (e.g. keyword='leftb'
%   would throw an error because l and b are different axes
    
    % Check Argument
    arguments
       keyword {mustBeNonempty}
    end
    
    % Ensure working with char... may not be needed
    if isstring(keyword)
        keyword = char( keyword );
    end
    
    % Determine if name is a string
    if ( ischar(keyword) )
        
        % Test which, if any of the three cases have a key letter contained
        % inside "name". These are Left: a/l, Bottom: b, Right: r/c
        irow = any( cellfun( @(x)contains(keyword,x,'IgnoreCase',true), ...
                    {'a','l';'b','b';'r','c'} ), 2);
        
        % Fork Result
        if nnz( irow )>1 % given key matches more than one axis
            error(['Keyword "',keyword,...
                 '" contains letters pointing to more than 1 axis']);
        elseif nnz( irow )  == 0
            error(['Keyword "',keyword,...
                 '" does not contain any letters pointing to an axis']);
        else % Valid
            idx = find(irow);
        end
        
    % Given a numeric value
    elseif ( isnumeric( keyword ) )
        
        % Set string
        str_key = sprintf('%g',keyword);
        
        % If integer
        if ( keyword == floor(keyword) )
            
            % If integer in correct range
            if (keyword <= 3 && keyword > 0)
                idx = keyword;
            else
                error(['Keyword "',str_key,'" is not 1, 2, or 3']) 
            end
            
        else
            error(['Keyword "',str_key,'" is not an integer']) 
        end
        
    else 
        error('Given keyword is not a number or string') 
    
    end
    
end