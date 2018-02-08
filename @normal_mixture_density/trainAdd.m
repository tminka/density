function [obj, likelihood] = trainAdd(obj, data)

obj.data = [obj.data data];
if nargout > 1
  [mbr, likelihood] = classify(obj, data);
  likelihood = sum(likelihood);
end
