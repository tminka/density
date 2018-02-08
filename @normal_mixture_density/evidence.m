function p = evidence(obj, data, alg)
% Returns the local evidence about the current parameter values,
% which are assumed to maximize the likelihood.

if nargin < 3
  alg = 'hessian';
end

[mbr, likelihood] = classify(obj, data);
N = col_sum(mbr);
d = rows(obj.means);
j = length(obj.weights);
p = sum(likelihood) + d*j/2*log(2*pi);
if strcmp(alg, 'EM')
  % EM's approximate Hessian
  p = p - d/2*log(prod(N)) + length(obj.weights)/2*log(det(obj.cov));
elseif strcmp(alg, 'hessian')
  p = p - 1/2*log(det(-likelihood_hessian(obj, data)));
elseif strcmp(alg, 'sampling')
  % compute the evidence by importance sampling
  sampler = get_posterior(obj, data, 'normal');
  x = sample(sampler, 10000);
  px = logProb(sampler, x);
  post = get_posterior(obj, data);
  x = map(num2cell(x, 1), 'vtrans', 2);
  p = logProb(post, x);
  p = p - px;

  if 1
    % use this to check convergence
    z = cumsum(exp(p)) ./ (1:cols(p));
    figure(5);
    plot(z);
  end

  p = logSum(p') - log(cols(x));
end
