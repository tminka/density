function obj = scale(obj, z)
% Return the density from scaling the output and input variables by z.

obj.offset = z * obj.offset;
obj.prediction_matrix = z * obj.prediction_matrix / z;
obj.cov = z * obj.cov * z';
