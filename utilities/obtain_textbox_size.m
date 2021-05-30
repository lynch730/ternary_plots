function [dx,dy] = obtain_textbox_size( font_size, str )
% obtain_textbox_size determine the size of the 
%   
%   

% Create Fake textbox with string
h = text(0, 0, str, 'FontSize',font_size, 'visible','off','units');

% Get sizes
dx = h.Extent(3);
dy = h.Extent(4);

delete(h);

end

    