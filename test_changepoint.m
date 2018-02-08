% Example of determining the location of a changepoint.
% Written by Tom Minka

if ~exist('draw_line_clip')
	error('lightspeed/graphics (https://github.com/tminka/lightspeed/) is not in the MATLAB path');
end

n = 20;
v = 0.001;
if 1
x = 2*rand(1,n)-1;
x = sort(x);
if 1
  m = 9;
  fprintf('truth: changepoint at %d\n',m);
  a1 = 1;
  a2 = 2;
  y = [a1*x(1:(m-1)) a2*x(m:n)] + sqrt(v)*randn(1,n);
else
  fprintf('truth: no changepoint\n');
  a = 0.5;
  y = a*x + sqrt(v)*randn(1,n);
end
x1 = [ones(1,n);x];
end

figure(1)
clf
plot(x, y, 'o')
xlabel('x')
ylabel('y')
drawnow

lls = lls_density(zeros(1,2), v);
%lls = set_cov_type(lls, 'fixed');
lls = train(lls, [x1; y]);
ev_nocp = evidence(lls);
a = get_prediction_matrix(lls);
draw_line_clip(a(2),a(1),1,'g')
%print -dps2 change2_data.ps

ms = 3:(n-1);
e = [];
for i = 1:length(ms)
  m = ms(i);
  r1 = 1:(m-1);
  r2 = m:n;
  lls1 = lls_density(zeros(1,2), v);
  %lls1 = set_cov_type(lls1, 'fixed');
  lls1 = train(lls1, [x1(:,r1); y(r1)]);
  lls2 = lls_density(zeros(1,2), v);
  %lls2 = set_cov_type(lls2, 'fixed');
  lls2 = train(lls2, [x1(:,r2); y(r2)]);
  e(i) = evidence(lls1) + evidence(lls2);
  
  if 0 & m == 9
    figure(1)
    clf
    plot(x, y, 'o')
    xlabel('x')
    ylabel('y')
    
    ax = axis;
    r1 = ax(1):(x(m-1)-ax(1)+1)/50:x(m-1);
    r2 = x(m):(ax(2)-x(m)+1)/50:ax(2);
    a1 = get_prediction_matrix(lls1);
    %b1 = get_offset(lls1);
    b1 = a1(1);
    a1 = a1(2);
    a2 = get_prediction_matrix(lls2);
    %b2 = get_offset(lls2);
    b2 = a2(1);
    a2 = a2(2);
    hold on
    plot(r1, a1*r1 + b1, 'g', r2, a2*r2 + b2, 'g');
    hold off
  end
  figure(2)
  plot(e)
  drawnow
end
% multiply by prior
e = e - log(length(ms));
ev_cp = logsumexp(e,2);
%e = e - ev_cp;

figure(2)
plot(ms, e, 'o', ms, e, '-');
axis tight
xlabel('changepoint t')
ylabel('log p(t | D)')
% print -dps2 change2_posterior.ps

fprintf('log-evidence-ratio for a changepoint: %g\n', ev_cp - ev_nocp);
m_best = ms(argmax(e));
fprintf('highest-evidence changepoint location is %g\n', m_best)
