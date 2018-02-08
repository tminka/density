d = 2;
norm1 = normal_density(zeros(d, 1), eye(d));
norm2 = normal_density(ones(d, 1), eye(d));
transitions = [0 1; 1 0];
transitions = [0.1 0.9; 0.9 0.1];
transitions = [0.9 0.1; 0.1 0.9];
hmm = hmm_density(transitions, [0.5 0.5], norm1, norm2);
disp(hmm);

data = sample(hmm, 100);
figure(1)
plot(data(1, :), data(2, :), '.');
draw(hmm);

data2 = sample(hmm, 100);

norm1 = normal_density(randn(d, 1), eye(d));
norm2 = normal_density(randn(d, 1), eye(d));
% initial transition matrix should not have zeros
hmm = hmm_density(ones(2)/2, ones(2, 1), norm1, norm2);
hmm = train(hmm, {data, data2});
disp(hmm);
