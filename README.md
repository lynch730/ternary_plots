# Ternary Plots

![advanced_example.png](https://github.com/lynch4815/ternary_plots/blob/main/advanced_example.png)

MATLAB package for creating ternary plots. It is a major overhaul of the [Ternary software](https://www.mathworks.com/matlabcentral/fileexchange/7210-ternary-plots) written by Ulrich Theune. It provides a host of new features to improve plotting capabilities.

## Features
  1. **Ternary Grid Support** - Support functions are provided to help generate ternary data prior to plotting. This includes support for generating consistent axes ranges and A, B, C coordinate vectors that are uniformly spaced (e.g. for generating surface plots).
  2. **Custom Data Tip** - A custom Datatip is provided that outputs ternary coordinates rather than the typical X/Y coordinates.
  3. **Flexible Axes Limits** - Ternary axes can accept customized ranges, rather than simply 0 to 1. A/B/C coordinates need only sum to a constant value
  4. **Customized Axes** - Spacing of ticks and grid lines can be customized for each variable.
  5. **Wrapped Functions** - Ternary equivalents of MATLAB plot functions (e.g. surf, plot3, text, etc) pass the same optional arguments, enabling easy customization.
  6. **Object Organization & Property Linking** - Ternary plot objects are organized in a single ternary plot handle, and have linked properties, making edits by hand more efficient.
  7. **Plot Layering** - Ternary plots can include multiple layers of plot elements, including combinations of surfaces, points, lines, and text.

## Getting Started
  1. It is recommended to clone the repo to your MATLAB *userpath* folder, then add *ternary_plots/*  to your *startup.m* file (e.g. *addpath([userpath,'/ternary_plots/'])* ). This will enable running ternary plotting routines from any working directory, after the command *add_ternary_paths* is issued.
  2. *basic_example.m* shows a minimalist example. *advanced_example.m* includes numerous customized axes.
  3. To make changes or to investigate the code, it is recommended to start by exploring the *ternary_axes.m* file, which does most of the heavy lifting. *ternary_surf.m* then shows how the data is used to generate a surface plot. The *problem_setup/* folder is also useful as it shows how the axes limits are obtained and A,B,C coordinates generated.

## File Tree
File tree for Ternary Plots, organized roughly by order of use:
```bash
Ternary_Plots/
│
├── README.md
├── add_ternary_paths.m          Adds sub-folders to the MATLAB path
│
├── examples/                    Example scripts for generating ternary plots
│   ├── basic_example.m
│   └── advanced_example.m
│
├── problem_setup/               Tools for creating ternary data
│   ├── ternary_axes_limits.m      - Determines the 6 limits the A/B/C axis given
│   │                                any 3, selecting a ternary sub-region or "zooming in".
│   │                                Allows for non-zero sum of A+B+C.
│   └── ternary_arrays.m           - Creates uniformly-spaced A,B,C ternary coordinates.
│                                    (Not required, but provides uniformly spaced plot data)
│
├── axes_creation/               Functions for creating the empty ternary figure
│   ├── ternary_axes.m             - Driver for creating ternary axes
│   ├── ternary_outlines.m         - Plots frame of the ternary triangle
│   ├── ternary_grid_lines.m       - Plots A/B/C grid lines
│   ├── ternary_tick_labels.m      - Plots text labels on the grid lines ternary_tick_lines
│   ├── ternary_tick_lines.m       - Plots tick lines outside axes
│   └── ternary_axes_titles.m      - Plots A/B/C Titles
│
├── utilities/                   Misc. helper functions
│   ├── cart2tern.m                - Converts Cartesian X/Y to Ternary A/B/C
│   ├── identify_ternary_axis.m    - Map 'left'/'bottom'/'center' to 1/2/3 axis indices
│   ├── tern2base.m                - Determines coordinates for the edges given an interior A/B/C
│   └── tern2cart.m                - Convert A/B/C coordinates to X/Y plotting coordinates
│
├── data_plots/                  Basic commands for plotting ternary data
│   ├── ternary_text.m
│   ├── ternary_plot3.m
│   ├── ternary_surf.m
│   └── ternary_scatter3.m
│
└── figure_tweaks/               Helper functions for adjusting ternary plots
    ├── adjust_axis_color.m        - Changes the color of an entire axis
    ├── restack_dataplots.m        - Reorders plots in handle.dataplots to ensure proper order
    ├── ternary_datatip.m          - Custom datatip to show A/B/C coordinates
    └── ternary_shift_XY.m         - Shift plot elements by a custom dX/dY
```
## Ternary Plot Handle
The ternary handle contains all the plot objects and data used to generate the ternary figure. It is organized in the hierarchy below. See *ternary_axes.m* and *ternary_surf.m* for typical usage. Currently, only modifications to fields containing primitive plot handles (lines, patch, etc) will automatically update the figure, but future versions will enable automatic updates when any field is altered.
```bash
handle
│
├── ax                        - Parent axes
├── ternaryshift(1:2)         - X/Y shifts applied to the ternary axis as a whole (in X/Y)
├── link_color{1:N}           - Cell Array of N strings. Elements that are linked for each A/B/C axis
├── axes_color_links          - Link Objects for each A/B/C axes;
│
├── title                     - A/B/C title text
│   ├── text(1:3)                - Array of text() objects
│   ├── titlelabels{1:3}         - Cell array of A/B/C title strings
│   ├── shift(1:2,1:3)           - Matrix of dX/dY shifts for A/B/C title
│   └── rotation(1:3)            - Vector of degrees rotation for each A/B/C title
│
├── grid                      - A/B/C grid lines
│   ├── lines(:,3)               - Array of line() objects
│   ├── usegridspace             - Boolean for using "gridspaceunit" as an increment rather than count
│   ├── gridspaceunit            - Number of grid lines per A/B/C axis, unless gridspaceunit=true
│   ├── wlimits(1:2,1:3)         - Lower and upper bounds for A/B/C coordinates
│   ├── grid_pnts(1:3).values(:) - Locations(0->1) of grid lines/labels along A/B/C axes
│   ├── link_lines(1:3)          - Linkprop object linking properties in each A/B/C axis (e.g. color) 
│   └── link_axes                - Linkprop object linking properties in all lines (ZData)
│
├── tick                      - A/B/C tick labels
│   ├── text(:,3)                - Array of text() objects
│   ├── lines(:,3)               - Array of line() objects
│   ├── tick_fmt                 - String for formatting tick labels
│   ├── shift(1:2,1:3)           - Matrix of dX/dY shifts for each tick label
│   ├── ticklinelength           - length of gridline extending past frame, creating tick marks
│   └── link_text(1:3)           - Linkprop object linking tick labels together
│
├── outline                   - A/B/C triangular outline
│   ├── lines(:,3)               - Array of line() objects
│   └── link_lines(1:3)          - Linkprop object linking outline lines together
│
└── dataplots(1:n_plots)      - Array of structures containing data plot information (e.g. plot3/surf)
    ├── object                - graphical objects (e.g. 'patch' or 'scatter' objects)
    └── colorbar              - If using scatter3 or surf, colorbar is created with handle in dataplots
```

## Features In Development
  1. Custom Datatip that plots lines of constant A/B/C at the specified point. 
  2. Automatic updates of ternary figure when handle fields are changed.
