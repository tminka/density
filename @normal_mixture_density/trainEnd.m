function obj = trainEnd(obj)

% compute the match matrix
mbr = classify(obj, obj.data)';
N = diag(col_sum(mbr));

if obj.train_means
  % compute the means
  obj.means = obj.data * mbr * inv(N);
end

% this code should also work for HMM
if isfield(obj, 'L')
  % project means onto the constraint surface
  P = pinv(obj.L' * kron(N, obj.icov) * obj.L + obj.lambda * eye(cols(obj.L)));
  P = P * obj.L' * kron(D, obj.icov);
  obj.means = vtrans(obj.L * P * vec(obj.means), rows(obj.means));
end

if ~obj.train_means | (obj.phase > 20)
  % update the common covariance matrix
  N = diag(inv(N));
  mbrN = mbr*N;
  d = rows(obj.data);
  t = zeros(size(obj.cov));
  for j = 1:cols(obj.means)
    for i = 1:cols(obj.data)
      diff = obj.data(:, i) - obj.means(:, j);
      s = mbr(i, j) * diff * diff';
      t = t + s;
      % correction for Hessian
      %t = t - d/2*(N(j) - mbrN(i))*s;
    end
  end
  obj.cov = t/cols(obj.data);
  % correction for Hessian
  %obj.cov = t/(cols(obj.data) - cols(obj.means));
  % force it to be spherical
  %obj.cov = trace(obj.cov)/d*eye(size(obj.cov));
  obj.icov = inv(obj.cov);
end

if 1
  % animate
  figure(1)
  delete(findobj('Tag', 'normal_mixture_density', 'Color', [1 0 0]));
  draw(obj, 'r');
end
if 0
  figure(2)
  colormap('bone')
  imagesc(mbr);
end
