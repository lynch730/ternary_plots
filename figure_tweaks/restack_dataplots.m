function handle = restack_dataplots( handle, dataplots )
% restack_last_plot Ternary plot restacking
%
%   This function accepts a ternary axes "handle" and another scalar or
%   vector structure "dataplots" which contains a field "object" or "obj"
%   which is the specific handle of the plot to stack (e.g.
%   dataplots(1).object is a "patch" object, the primitive plot type
%   produced by surf(). One could then have dataplots(2).object filled with
%   a "scatter" type for scatter3() handle). 
%   
%   restack_dataplots shifts zdata of all plots to ensure data is stacked
%   in the order of the inidicies given by dataplots. 
% 
%   The user may optionally include a hardcoded entry for
%   dataplots(i).object='grid', which indicates gridlines should be plotted
%   as the "ith" position of the plots. If no "grid" is given, gridlines
%   are placed above the first "patch" object found, and the rest of the
%   plots are placed above the gridlines. This works well for typical cases
%   of a single surf() plot, but may lead to problems if there are multiple
%   "patch" type plots. The user is encourage to use the "grid" option in
%   these cases. 
    
    % To support v1.0-v1.1, restack can accept dataplots either as a
    % seperate struct array, or as a field within handle. 
    if (nargin < 2)
        if ( isfield(handle,'dataplots') )
            dataplots = handle.dataplots;
        else
            error(['If only one argument is passed, it must be handle',...
                   ' and include handle.dataplots as a field'])
        end
    end
    
    % Get number of data plots
    n = numel(dataplots);
    
    % Check if dataplots contains a field named obj or object, otherwise
    % throw error. Convert to "object" if "obj" is used.
    if ( isfield(dataplots,'obj') )
        for i=1:n
            dataplots(i).object = dataplots(i).obj;
        end
    elseif ( ~isfield(dataplots,'obj') )
        error('Dataplots must contain plot handles under field obj or object')
    end
    
    % Check if there is a "grid" argument, otherwise it will be inserted
    grid_insert_flag = true; % default to insertion, grid not given
    for i=1:n
        if strcmp( dataplots(i).object,'grid' )==1
            grid_insert_flag = false;
        end
    end
    
    % Find any surface plots
    z = 0;
    for i=1:n
        
        % Advance z
        z = z + 1.0;
        
        % Advance
        if ( strcmp( dataplots(i).object,'grid' )==1 )
            handle.grid.lines(1,1).ZData(:) = z;
            handle.outline.lines(1,1).ZData(:) = z+0.01;
        elseif ( strcmp( dataplots(i).object.Type , 'patch'  )==1 )
            z = z + max( dataplots(i).object.ZData(:) );
            if grid_insert_flag
                grid_insert_flag = false;
                z = max( dataplots(i).object.ZData(:) ) + 1.0;
                handle.grid.lines(1,1).ZData(:) = z;
                handle.outline.lines(1,1).ZData(:) = z+0.01;
            end
        elseif ( strcmp( dataplots(i).object.Type , 'text'  )==1 )
            dataplots(i).object.Position(3) = z;
        else
            dataplots(i).object.ZData(:) = z;
        end
        
    end
    
end

