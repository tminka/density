function [g,h,c1,c3] = s_derivatives(a, data, sdata, weight)
% Returns derivatives of the log-likelihood bound:
%   sum_i w_i log p(x_i | s, m)
% Outputs are scalars.
% DATA is a matrix of histograms, which must be rows.
% SDATA is a vector of histogram totals.
% WEIGHT is a vector of numbers in [0,1] (default all ones),
%   oriented opposite the histograms.

s = sum(a);
m = a/s;

if 1
  N = rows(data);
  
  if nargin < 4
    weight = ones(N,1);
  end

  g = -sum(di_pochhammer(s, sdata).*weight);
  h = -sum(tri_pochhammer(s, sdata).*weight);
  c1 = sum(row_sum(data > 0).*weight) - sum((sdata > 0).*weight);
  c3 = sum(sdata.*(sdata-1).*(2*sdata-1).*weight)/6;
  for k = 1:length(a)
    dk = data(:,k);
    g = g + m(k)*sum(di_pochhammer(a(k), dk).*weight);
    h = h + m(k)^2*sum(tri_pochhammer(a(k), dk).*weight);
    c3k = sum(dk.*(dk-1).*(2*dk-1).*weight)/6;
    c3 = c3 - c3k/m(k)^2;
  end
    
else
  N = cols(data);

  sm = repmat(s*m, 1, N);
  g = row_sum(digamma(sm + data) - digamma(sm));
  g = sum(m.*g) - sum(di_pochhammer(s, sdata));
  h = row_sum(trigamma(sm + data) - trigamma(sm));
  h = sum((m.^2).*h) + sum(trigamma(s) - trigamma(s+sdata));
  
  c1 = sum(sum(data > 0)) - sum(sdata > 0);
  %c2 = sum(row_sum(data.*(data-1))/2./m) - sum(sdata.*(sdata-1))/2;
  c3 = -sum(row_sum(data.*(data-1).*(2*data-1))/6./m./m) ...
      + sum(sdata.*(sdata-1).*(2*sdata-1))/6;
end
