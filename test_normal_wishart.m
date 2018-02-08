obj = normal_wishart_density(3, 2, 0.5*5, 5)
%obj = normal_wishart_density(3, 2, 0, 0);

if 1
  norm = normal_density(4.3, 1.4, 3);
  norm = set_prior(norm, obj);
  post = get_posterior(norm);
  if 0
    % new mean
    (5*3 + 2*3)/5
    % new scatter
    0 + 3 + 3*2/5*(5-3)^2
    disp(post)
    return
  end
  data = sample(post, 2000);
  if 1
    e = logProb(obj, data);
  else
    e = zeros(1, cols(data));
  end
  x = 4;
  for i = 1:cols(data)
    mi = data(1,i);
    vi = data(2,i);
    norm = normal_density(mi, vi);
    e(i) = e(i) + logProb(norm, x);
  end
  sum(e)/length(e)

  d = 1;
  e2 = logdet(get_s(post)/2) - digamma(get_n(post)/2);
  if 1
    e2 = e2*(get_n(obj)+d+3);
  else
    e2 = e2*(get_n(obj)+d+2);
  end
  if 1
    diff = (x - get_mean(post));
    e2 = e2 + get_n(post)*diff'*inv(get_s(post))*diff + d/get_k(post);
    e2 = e2 + d*log(2*pi);
  end
  if 1
    diff = get_mean(post) - get_mean(obj);
    e2 = e2 + get_n(post)*get_k(obj)*diff'*inv(get_s(post))*diff;
    e2 = e2 + d*get_k(obj)/get_k(post);
    e2 = e2 + get_n(post)*trace(inv(get_s(post))*get_s(obj));
  end
  if 1
    e2 = e2 + d*log(2*pi) - d*log(get_k(obj));
    e2 = e2 - get_n(obj)*logdet(get_s(obj));
    e2 = e2 + 2*wishart_z(get_n(obj), d) + d*get_n(obj)*log(2);
  end
  -e2/2
end

if 0
  data = sample(obj, 500);
  figure(1);
  plot(data(1, :), data(2, :), '.');
  axis([1 5 0 2]);
  draw(obj, 'contour');
  
  figure(2);
  axis([1 5 0 2]);
  plot(obj);
end

if 0
  md = m_marginal(obj);
  figure(3);
  axis([1 5 0 1]);
  plot(md);

  vd = v_marginal(obj);
  figure(4);
  axis([0 2 0 1]);
  plot(vd);
end

if 0
  % check the conditionals
  inc = 0.1;
  x = 1:inc:5;
  p = exp(logProb(obj, [x; ones(1, length(x))]));
  p = p ./ sum(p) / inc;

  mc = m_conditional(obj, 1);
  figure(3);
  plot(x, p);
  draw(mc);

  inc = 0.1;
  x = 0.1:inc:15;
  p = exp(logProb(obj, [ones(1, length(x)); x]));
  p = p ./ sum(p) / inc;
  
  vc = v_conditional(obj, 1);
  figure(4);
  plot(x, p);
  draw(vc);
end

