function handle = adjust_axis_color(handle,name,color)
%adjust_axis_color updates all the elements on one axis with the same
%color, including transparency. This is needed because linking color
%proprties prevents transperency from being updated
    
    % Check inputs
    if (nargin<3)
        error('Three Arguments Required')
    end
    
    % Interpret Name
    iaxis = identify_ternary_axis( name );
    
    % Adjust Title
    for j=1:numel( handle.link_color )
        switch handle.link_color{j}
            case 'title'
                 handle.title.text(iaxis).Color = color;
            case 'tick'
                for i=1:numel(handle.tick.lines(:,iaxis))
                    handle.tick.lines(i,iaxis).Color = color;
                    handle.tick.text(i,iaxis).Color = color;
                end
            case 'tick_line'
                for i=1:numel(handle.tick.lines(:,iaxis))
                    handle.tick.lines(i,iaxis).Color = color;
                end
            case 'tick_label'
                for i=1:numel(handle.tick.text(:,iaxis))
                    handle.tick.text(i,iaxis).Color = color;
                end
            case 'grid'
                for i=1:numel(handle.grid.lines(:,iaxis))
                    handle.grid.lines(i,iaxis).Color = color;
                end
            case 'outline'
                handle.outline.lines(iaxis).Color = color;
            otherwise
                error(['Bad color link field name: ',handle.link_color{j}] )
        end
    end
    
    
end

