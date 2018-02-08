function f = ft_each(obj, x)
% Returns the Fourier expansion of each column of x (interpreted as a single
% impulse).

e = obj.freqs'*x;
f = exp(-j*e);
