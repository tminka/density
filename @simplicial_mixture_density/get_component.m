function c = get_component(obj, w)
% Returns the mixture component indexed by weights w.

% initialize theta
fields = fieldnames(obj.corners{1});
theta = struct(fields{1}, 0);
for i = 1:length(fields)
  theta = setfield(theta, fields{i}, 0);
end

% loop corners
for k = 1:length(obj.corners)
  for i = 1:length(fields)
    theta = setfield(theta, fields{i}, getfield(theta, fields{i}) ...
	+ w(k)*getfield(obj.corners{k}, fields{i}));
  end
end

c = obj.prototype;
for i = 1:length(fields)
  c = feval(['set_' fields{i}], c, getfield(theta, fields{i}));
end
