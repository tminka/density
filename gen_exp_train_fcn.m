function p = gen_exp_train_fcn(this, x, weights, other, flag)

if flag == 'm'
  m = this;
  b = other;
  x = x - m;
  p = abs(x).^b * weights';
  return
end

% x already has m subtracted
b = this;

n = sum(weights);
c = b/n * (abs(x).^b * weights');
p = n*log(b/2) - n*gammaln(1/b) - n/b*log(c) - n/b;
p = -p;
