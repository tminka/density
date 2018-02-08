function obj = simplicial_mixture_density(prototype, corners, weight_density)
% PROTOTYPE is a prototype object.
% CORNERS is a cell array of structures.  Each structure specifies 
% (key, value) pairs to change in the prototype.  The change is effected by 
% calling set_key(PROTOTYPE, value).
% WEIGHT_DENSITY is a Dirichlet density.

s = struct('prototype', prototype, 'corners', {corners}, ...
    'weight_density', weight_density);
obj = class(s, 'simplicial_mixture_density');
