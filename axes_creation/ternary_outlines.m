function handle = ternary_outlines(handle, varargin)
%ternary_outlines creates a standard triangle-plot to add to an axes
%   
%   Accepts VARARGIN as forward to customized plot settings. This function
%   uses the convention of 0->1 plotting range
    
    %% Check Inputs
    
    % Check if handle is given
    if (nargin==0)
       error('Too few inputs') 
    end
    
    % Create defaul settings if no extra arguments supplied
    if ( nargin < 2 || isempty( varargin ) )
        varargin =  {'Color','k','LineWidth',2};
    end
    
    % Local copy of wlimits 
    wlimits = handle.grid.wlimits;
    wsum    = handle.grid.wsum;
    
    %% Plot the 3 Main Outlines
    for i=1:3      
        
        % Get axis of plot adjacent
        iaxis = i - 1;
        if (iaxis==0)
            iaxis = 3;
        end
        
        % Get other ABC Coordinates
        [A,B,~] = tern2base( i, wlimits(1,i), wlimits, 0.0);
                
        % Create line
        handle.outline.lines(iaxis) = ternary_plot3( wlimits, 1, A, 2, B, [], varargin{:} );
        
    end
    
    % Link Gridlines
    handle.outline.link_lines = linkprop(handle.outline.lines,'ZData');
    
end

