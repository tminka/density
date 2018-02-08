function p = evidence(obj, data)
% Returns the log-probability of data under the prior,
% ignoring the current parameter values (the parameters are integrated out).
% If data is not given, the data used to train the parameters is used.
%
% For this density only the local evidence about the ML solution is computed.

h = hessian(obj, data);
%isposdef(-h)
p = sum(logProb(obj, data)) - 0.5*log(pdet(-h));
j = length(obj.weights);
if 0
  % noninformative Dirichlet prior for the weights
  p = p + gammaln(j);
  % determinant of weight Hessian (much simpler than computing the Hessian)
  p = p - 0.5*log(cols(data)/prod(obj.weights));
end
if 0
  % The same mode occurs at every permutation of the parameters, so
  % we multiply by j!
  p = p + gammaln(j+1);
end
if 0
  % ICOMP criterion
  d = 1;
  p = p - d*j/2*log(trace(-h)/d/j);
else
  % prior
  for i = 1:length(obj.weights)
    c = obj.components{i};
    p = p + prior_logProb(c);
  end
end
