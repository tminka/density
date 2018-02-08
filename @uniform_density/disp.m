function disp(obj)

disp('a = ');
disp(obj.a);
disp('b = ');
disp(obj.b);
if isinf(obj.a) | isinf(obj.b)
  disp('p = ');
  disp(exp(obj.logp));
end
