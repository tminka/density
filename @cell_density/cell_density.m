function obj = cell_density(components)
% CELL_DENSITY   Density over cell arrays with independent components.
%    The shape of COMPONENTS determines the shape of the data.

s = struct('components', {components});
obj = class(s, 'cell_density');
