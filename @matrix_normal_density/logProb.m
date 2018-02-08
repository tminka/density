function p = logProb(obj, data)

[d,n] = size(data);
p = d/2*logdet(obj.c) -n/2*logdet(2*pi*obj.v);
if cols(obj.m) == 1
  diff = data - repmat(obj.m, 1, n);
else
  diff = data - obj.m;
end
p = p -1/2*trace(diff'*inv(obj.v)*diff*obj.c);
