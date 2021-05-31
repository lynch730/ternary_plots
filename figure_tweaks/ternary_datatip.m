function txt = ternary_datatip(~,event_obj,Zdata,wlimits)
%surf_data_cursor CustomDataTip for Surf Ternary Plot
% 

    % Get the Index of the point
    I = get(event_obj, 'DataIndex');

    % Get Coordinates
    pos = get(event_obj,'Position');
    [A,B,C] = cart2tern( pos(1),pos(2) );

    % Get In non-plot units
    A = A*( wlimits(2,1) - wlimits(1,1) ) + wlimits(1,1);
    B = B*( wlimits(2,2) - wlimits(1,2) ) + wlimits(1,2);
    C = C*( wlimits(2,3) - wlimits(1,3) ) + wlimits(1,3);

    % Get a new text array
    txt = { ['V1 = ', num2str(A)],...
            ['V2 = ', num2str(B)],...
            ['V3 = ', num2str(C)],...
            ['Z   = ', num2str( Zdata(I) )   ] };

end