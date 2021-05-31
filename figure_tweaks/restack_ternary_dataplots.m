function handle = restack_ternary_dataplots(handle)
% restack_last_plot ensures the last plot in handle.dataplots array is on
% top. If there is one or more surface (aka patch) plots, take the first,
% make that the base with gridlines above it, followed by other plots on
% the list in order. Warn user of undefined behavior.
%
%   NOTE: any plots with CDATA (surf, scatter3) are ignored to avoid
%   altering ZData values

    % Get number of data plots
    n = numel(handle.dataplots);

    % Find any surface plots
    patch_idx = 0;
    for i=1:n
        
       % look for object with path type (surf plot)
       if ( strcmp( handle.dataplots(i).object.Type , 'patch'  )==1 || ...
            strcmp( handle.dataplots(i).object.Type , 'scatter')==1 )

           % If none have been encountered, save the index in dataplots
           if (patch_idx == 0)
                patch_idx = i;
           else % throw warning
              warning('Multiple surface plots detected, undefined behavior! ')
              break
           end
           
       end
    end

    % Now stack based on detected type
    if (patch_idx>0) % there is a surface plot

        % Get the level just above max of the surface plot
        zmax = max( handle.dataplots(patch_idx).object.ZData, [], 'all' )+1.0;

        % Set ZData of gridlines to zmax
        handle.grid.lines(1).ZData(:) = zmax;

        % Now go back through and stack in order
        for i=1:n

           % If index is not patch_idx, and there is Zdata to access...
           if (i~=patch_idx && isfield(handle.dataplots(i).object, 'ZData') ...
               && strcmp( handle.dataplots(i).object.Type , 'path '  )==0  ...
               && strcmp( handle.dataplots(i).object.Type , 'scatter')==0       )

               % Advance zmax
               zmax = zmax+1;

               % Set handle to that Zdata
               handle.dataplots(i).object.ZData = zmax;
            
           end

        end

    else % No surface, set last plot to just above the previous

        % Get level just above N-1
        zmax = max( handle.dataplots(n-1).object.ZData, [], 'all' )+1.0;

         % If it has Zdata, push most recent plot to top
        if (isfield(handle.dataplots(n).object, 'ZData'))
            handle.dataplots(end).object.ZData = zmax;
        end
        
    end

end

