function obj = kernel_density(width)
% KERNEL_DENSITY   Nonparametric Parzen window density with Gaussian kernels.
%   KERNEL_DENSITY(width)
%   returns a kernel density with fixed kernel width.
%   Omitting width causes it to be chosen by the leave-one-out method.

s = struct('centers', [], 'weights', [], ...
    'temp_centers', [], 'temp_weights', [], ...
    'width', 1, 'width_type', 'flexible', ...
    'prior', -10);
obj = class(s, 'kernel_density');

if nargin > 0
  obj.width = width;
  obj.width_type = 'fixed';
end
