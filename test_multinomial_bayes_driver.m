[err_ml_test, err_ab_test, err_eb_test, err_opt_test] = ...
    test_multinomial_bayes(10,4,8);

figure(1)
plot(1:length(err_ml_test), err_ml_test, ...
    1:length(err_ab_test), err_ab_test, ...
    1:length(err_eb_test), err_eb_test, ...
    1:length(err_opt_test), err_opt_test)
legend('ML', 'AB', 'EB', 'Opt')

sum(err_ml_test(1:100) <= 0) + sum(err_ml_test(101:200) >= 0)
sum(err_ab_test(1:100) <= 0) + sum(err_ab_test(101:200) >= 0)
sum(err_eb_test(1:100) <= 0) + sum(err_eb_test(101:200) >= 0)
sum(err_opt_test(1:100) <= 0) + sum(err_opt_test(101:200) >= 0)
