function add_ternary_paths
%add_ternary_paths makes ternary_plots functions available to user
%   
%   This function adds sub-directories of ternary_plots to the path. This
%   means ternary_plots functions are normally unavailable until
%   "add_ternary_paths" is called in a script. This is done to avoid any
%   conflicts in filenames when not using ternary_plots (for
%   example, "basic_example.m" could exist in some other location).
    
    % Path to ternary_plots directory, wherever it resides
    tpath = matlab.desktop.editor.getActiveFilename;
    tpath = erase(tpath,'add_ternary_paths.m');
    
    % Add subfolders to path
    addpath( [ tpath, 'axes_creation/' ] );
    addpath( [ tpath, 'data_plots/'    ] );
    addpath( [ tpath, 'problem_setup/' ] );
    addpath( [ tpath, 'figure_tweaks/' ] );
    addpath( [ tpath, 'utilities/'     ] );
    addpath( [ tpath, 'examples/'      ] );
    
end

