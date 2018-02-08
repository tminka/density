function w = window(obj, width, freqs)
% Returns the Fourier series for the kernel.

if nargin < 3
  freqs = obj.freqs;
  if nargin < 2
    width = obj.width;
  end
end
r = obj.b - obj.a;

% Gaussian kernel
% Multiply and divide by r to account for coordinate change.
w = exp(-col_sum(freqs*width).^2/2/r^2)/r;
