function obj = generic_posterior_density(likelihood_obj, likelihood_args, ...
    set_func)

s = struct('likelihood_obj', likelihood_obj, ...
           'likelihood_args', {likelihood_args}, ...
	   'set_func', set_func);
obj = class(s, 'generic_posterior_density');   
