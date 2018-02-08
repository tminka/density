function obj = fourier_density(width)
% FOURIER_DENSITY   Nonparametric Parzen window density with Gaussian
%                   kernels, represented by Fourier coefficients.
%    FOURIER_DENSITY(width) returns a kernel density with fixed kernel
%    width.  Omitting width causes it to be chosen by leave-one-out.
%    The density starts uniform on [0,1].

% All non-DC coeffs have symmetric partners, so we only store coefficients
% at positive frequencies, with twice the value they would normally have.
% In d dimensions, there are 2^d symmetric partners so we multiply by 2^d.

s = struct('coeffs', 1, 'freqs', 0, 'width', 1, 'a', 0, 'b', 1);
obj = class(s, 'fourier_density');

if nargin > 0
  obj.width = width;
  obj.width_type = 'fixed';
end
