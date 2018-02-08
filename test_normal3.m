d = 10;
n1 = 20;
n2 = 40;

errs = [];
for iter = 1:20
  disp(iter)
  [ml, ub, ab, eb, opt] = test_normal_bayes(d, n1, n2);
  errs(1, iter) = ml;
  errs(2, iter) = ub;
  errs(3, iter) = ab;
  errs(4, iter) = eb;
  errs(5, iter) = opt;
end
errs = errs';
if 1
  plot(errs)
  legend('ML','UB','AB','EB','Opt')
  plot(errs(:,[1 4 5]))
  legend('ML','Bayes','Min')
  xlabel('Trial')
  ylabel('Test error')
  set(gcf,'PaperPos',[0.25 2.5 8 6])
  return
end
if 0
%save bayes.d2.n3.results errs -ascii
cmd = ['save results/bayes.d' num2str(d) '.n' num2str(n1) '.n' num2str(n2) '.results errs -ascii'];
eval(cmd);
end
