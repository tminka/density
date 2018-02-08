function e = kernel_width_cv(width, centers, weights)
% Returns a function to be minimized for finding the best kernel width.

e = 0;
if cols(centers) < 2
  return
end

if 0
  
  % slow way
  % break up the centers all possible ways
  for i = 1:cols(centers)
    x = centers(:, i);
    c = centers;
    c(:, i) = [];
    w = weights;
    w(i) = [];
    w = w / sum(w);
    
    e = e - kernel_logProb(x, c, width, w);
  end

else
  
  % fast way
  % use only n test points
  n = 20;
  step = floor(cols(centers)/n);
  if step == 0
    step = 1;
  end
  test = centers(:, 1:step:cols(centers));
  p = kernel_logProb(test, centers, width, weights);
  k = -rows(centers)*(1/2*log(2*pi) + log(width));
  warning off
  for i = 1:n
    w = weights((i-1)*step+1);
    if w > 0
      % removing center i changes sum by -weights(i)/sqrt(2*pi)/width
      % and changes weights by 1/(1 - weights(i))
      %d = log( (exp(p(i)) - w*exp(k)) / (1 - w) );
      d = logSub(p(i), k + log(w)) - log(1 - w);
      e = e - d;
    end
  end
  warning on
end
