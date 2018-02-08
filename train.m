function [obj, likelihood, activity] = train(obj, data, varargin)

obj = trainBegin(obj);

if nargout > 1
  [obj, likelihood] = trainAdd(obj, data, varargin{:});
else
  obj = trainAdd(obj, data, varargin{:});
end

if nargout > 2
  [obj, activity] = trainEnd(obj);
else
  obj = trainEnd(obj);
end
