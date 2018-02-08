function obj = trainEnd(obj)

if obj.n == 0
  return
end

mean = obj.temp_sum / obj.n;
s = obj.n * log(mean) - obj.temp_log_sum;

% approximate ML estimate
obj.a = (obj.n + 2)/2/s;
obj.b = mean/obj.a;
