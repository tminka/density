% Probability and Bayesian statistics Toolbox.
% Version 1.0  1-Jan-97
% by Tom Minka
%
% Density objects
%   normal	- Multivariate Gaussian.
%   gamma       - Univariate Gamma.
%   t           - Student's T.
%   wishart     - Multivariate Chi-square.
%   mixture     - Finite weighted sum of densities.
%   hmm         - Finite-state hidden Markov model.
%   lds         - Continuous-state linear dynamical system.
%   lls         - Linear least-squares regression.
%   ar          - Linear autoregression.
%   logit       - Linear classification aka logistic regression.
%   uniform     - Uniform density.
%   multinomial - Multinomial distribution.
%   dirichlet   - Dirichlet density.
%   
% Density object methods
%   disp        - Display parameter values.
%   sample	- Return a sample from the density.
%   logProb	- Return the log-probability of a datum.
%   train       - Batch training of the model parameters.
%   trainBegin	- Begin incremental training.
%   trainAdd    - Add a datum for training the model.
%   trainEnd	- End incremental training.
%   evidence    - Returns the log-probability of data given the model.
%   x_posterior - Returns a parameter's posterior density.
%   sample_posterior - Returns a density sampled from the parameter posterior.
%   posterior_predict - Returns the posterior predictive density.
%   logProb_indata - Returns the posterior predictive probability for
%                    samples in the training data, conditional on the rest
%                    of the data.  Generally faster than posterior_predict.
%   output_density - Returns the output density for a conditional model,
%                    given conditioning values.
%   gradient    - Returns the gradient of the likelihood wrt all parameters.
%   hessian     - Returns the Hessian of the likelihood wrt all parameters.
%   gradient_x  - Returns the gradient of the likelihood wrt a parameter.
%   hessian_x   - Returns the Hessian of the likelihood wrt a parameter.
