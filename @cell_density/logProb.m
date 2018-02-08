function p = logProb(obj, data)
% data is a single cell array where each element may be a collection.

p = map2(obj.components, data, 'logProb');
p = accumulate(p);
