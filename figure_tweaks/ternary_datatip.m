function txt = ternary_datatip( h, A, B, C, Z )
%surf_data_cursor CustomDataTip 
    
    % Create a temporary datatip if DataTipTemplate doesn't exist yet
    tip  = [];
    if ~isfield(h,'DataTipTemplate')
        tip = datatip( h, 1, 1, 'Visible', 'off' );
    end
    
    % Try to get the data tip handle
    try
        dtt = h.DataTipTemplate;
    catch
        warning('Unable to create customized datatip')
        return 
    end
    
%     % Edit the Row Labels in the Data Tip
%     dtt.DataTipRows(2:end) = []; 
%     dtt.DataTipRows(1).Label = '';
%     dtt.DataTipRows(1).Value = '';
    dtt.DataTipRows(end+1) = dataTipTextRow('A',A,'%g');
    dtt.DataTipRows(end+1) = dataTipTextRow('B',B,'%g');
    dtt.DataTipRows(end+1) = dataTipTextRow('C',C,'%g');
    dtt.DataTipRows(end+1) = dataTipTextRow('Z',Z,'%g');
%     
    % Clear tip if created
    if ~isempty(tip)
        delete( tip );
    end
    
end