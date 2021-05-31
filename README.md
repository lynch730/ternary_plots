# Ternary Plots
MATLAB package for creating ternary plots. It is a major overhaul of the [Ternary software](https://www.mathworks.com/matlabcentral/fileexchange/7210-ternary-plots) written by Ulrich Theune. It provides a host of new features to improve plotting capabilites.

## Features
  1. **Ternary Building Support** - Support functions are provided to help generate ternary data prior to plotting. This includes support for generating consistent axes ranges and A,B,C triplet vectors.
  2. **Custom Data Tip** - Datatip function outputs ternary coordinates rather than the typical X/Y coordinates
  3. **Flexible Axes Limits** - Ternary axes can accept customized weight ranges, rather than simply 0 to 1.
  4. **Flexible Axes Ticks** - Spacing of ticks and grid lines can be customized for each species, and can be generate automatically along "pretty" spacing intervals. Tick lables are automatically sized to fit grid lines
  5. **Object Propery Linking** - Ternary plot objects have linked properties, making edits by hand more efficient.
  5. **Improved Property Input** - Ternary plot functions use conventional MATLAB inputs for things like line specifications, colors, etc.
  6. **Plot Layering** - Ternary plots can include multiple layersor stacks of plot elements, including combinations of surfaces, points, lines, text, and shapes

## Conventions
  1. Ternary axes are indexed 1/2/3 for left/bottom/right
  2. Axes range from left to right, with lines of constant value from SW to NE

## File Tree

## Worklist
  1. Add 
  6. Folder with plot helper functions (data tip, data tip II, create point from data tip, find max)
  7. Add sub-region plot in setup folder
  5. Finish Readme with file tree, features, and example plots
  8. 
  4. Fix the ABC shift function

