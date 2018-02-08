function obj = trainEnd(obj)

obj.weights = obj.temp_weights;

% Normalize weights
if sum(obj.weights) > 0
  obj.weights = obj.weights / sum(obj.weights);
end

obj.a = min(obj.temp_data')';
obj.b = max(obj.temp_data')';
% add a reasonable margin, to avoid edge effects
d = rows(obj.a);
margin = 4*obj.width;
margin = max(margin, max(obj.b-obj.a));
margin = repmat(margin, d, 1);
obj.a = obj.a - margin;
obj.b = obj.b + margin;
r = obj.b - obj.a;
% map data into [0,1]
obj.temp_data = (obj.temp_data - obj.a) ./ repmat(obj.b - obj.a, 1, cols(obj.temp_data));

% compute range of frequencies to evaluate
m = 100;
if rows(obj.a) == 1
  obj.freqs = 2*pi*(0:(m-1));
else
  error('unsupported dimensionality');
end

obj.coeffs = ft(obj.freqs, obj.temp_data, obj.weights);
% scale the non-DC coeffs to account for symmetries
obj.coeffs(2:m) = 2^d*obj.coeffs(2:m);

% loop in case we need to add more coefficients
while(1)
  
if ~hasfield(obj, 'width_type') | ~strcmp(obj.width_type, 'fixed')
  % Find the optimal width %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % use n test points
  n = 20;
  step = floor(length(obj.weights)/n);
  if step == 0
    step = 1;
  end
  i = 1:step:length(obj.weights);
  n = length(i);
  weights = obj.weights(i);
  test = obj.temp_data(:,i);
  p = real(repmat(obj.coeffs, 1, n) .* conj(ft_each(obj, test)));
  
  % the maximum width is limited by the margin
  if 0
    widths = 0.1:0.1:margin/4;
    for i = 1:length(widths)
      e(i) = fourier_width_cv(widths(i), obj, r, p, weights);
    end
    figure(3);
    plot(widths, e);
    axis tight;
    [y,i] = min(e);
    obj.width = widths(i);
  else
    obj.width = fmin('fourier_width_cv', 1e-2, margin/4, [0 1e-1], ...
	obj, r, p, weights);
  end
end

w = window(obj, obj.width, obj.freqs(m));
c = obj.coeffs(m)*w;
if abs(c) > 1e-5
  %disp(['overflow detected: need more than ' num2str(m) ' coefficients'])
  new_m = 2*m;
  if d == 1
    new_freqs = 2*pi*(m:(new_m-1));
  end
  m = new_m;
  c = 2^d*ft(new_freqs, obj.temp_data, obj.weights);
  obj.coeffs = [obj.coeffs; c];
  obj.freqs = [obj.freqs new_freqs];
  % continue the loop
else
  % we have enough coefficients, so exit the loop
  break
end
end

w = window(obj);
% use .' to prevent conjugation
obj.coeffs = obj.coeffs.' .* w;

if 0
% prune irrelevant coefficients
i = find(abs(obj.coeffs) > 1e-5);
figure(2)
plot(log(abs(obj.coeffs)))
if ~isempty(i)
  obj.coeffs = obj.coeffs(i);
  obj.freqs = obj.freqs(:,i);
end
size(obj.coeffs)
end
