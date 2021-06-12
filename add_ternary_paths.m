function add_ternary_paths
%add_ternary_paths makes ternary_plots functions available to user
%   
%   This function adds sub-directories of ternary_plots to the path. This
%   means ternary_plots functions are normally unavailable until
%   "add_ternary_paths" is called in a script. This is done to avoid any
%   conflicts in filenames when not using ternary_plots (for
%   example, "basic_example.m" could exist in some other location).
    
    % Path to ternary_plots directory, wherever it resides
%% Find Root Directory
    [tpath,~,~] = fileparts(which('add_ternary_paths.m'));
    addpath( tpath );
    
    % Add subfolders to path
    addpath( [ tpath filesep 'axes_creation' filesep ] );
    addpath( [ tpath filesep 'data_plots'    filesep ] );
    addpath( [ tpath filesep 'problem_setup' filesep ] );
    addpath( [ tpath filesep 'figure_tweaks' filesep ] );
    addpath( [ tpath filesep 'utilities'     filesep ] );
    addpath( [ tpath filesep 'examples'      filesep ] );
    
end

