norm1 = normal_density(4, 2);
norm2 = normal_density(7, 2);
%transitions = [0 1; 1 0];
%transitions = [0.1 0.9; 0.9 0.1];
transitions = [0.9 0.1; 0.1 0.9];
hmm = hmm_density(transitions, [0.5 0.5], norm1, norm2);
disp(hmm);

data = [7 4 7 4];
% answer should be 0.5*(0.3989)^4 = 0.0127
exp(logProb(hmm, {data}))

data = sample(hmm, 100);
figure(1)
plot(data, 1:cols(data), '-');
draw(hmm);

data2 = sample(hmm, 100);

norm1 = normal_density(randn, 1);
norm2 = normal_density(randn, 1);
% initial transition matrix should not have zeros
hmm = hmm_density(ones(2)/2, ones(2, 1), norm1, norm2);
hmm = train(hmm, {data, data2});
disp(hmm);
