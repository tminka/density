function obj = trainBegin(obj)

obj.temp_mean = zeros(size(obj.mean));
obj.temp_cov = zeros(size(obj.cov));
obj.n = 0;
