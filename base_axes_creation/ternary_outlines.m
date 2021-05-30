function handle = ternary_outlines(handle, varargin)
%ternary_outlines creates a standard triangle-plot to add to an axes
%   
%   Accepts VARARGIN as forward to customized plot settings. This function
%   uses the convention of 0->1 plotting range
    
    % Create defaul settings if no extra arguments supplied
    if isempty(varargin)
       varargin = {'Color','k','LineWidth',2};
    else
       varargin = varargin{:};
    end
    
    % Loop grid lines
    for i=1:3      
        
        % Get axis of plot
        iaxis = i - 1;
        if (iaxis==0)
            iaxis = 3;
        end
        
        % Create line
        handle.outline.lines(iaxis) = plot_ternary_line( i, 0, 1.0, 0, varargin );
        
        % Set above default gridlines
        handle.outline.lines(iaxis).ZData=[0.1,0.1];
        
    end
    
    % Link Gridlines
    handle.outline.link_lines = linkprop(handle.outline.lines,'ZData');
    
end

