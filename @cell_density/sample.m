function data = sample(obj, varargin)

data = map(obj.components, 'sample', varargin{:});
