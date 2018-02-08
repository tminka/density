% Example of logistic regression with a nonlinear boundary via data transformations.
% Written by Tom Minka

n = 200;
features = 2;
fig = 1;
for task = 1:4
	kernels = {'linear','quad','gaussian'};
	for kernelIndex = 1:length(kernels)
		kernel = kernels{kernelIndex};
		%kernel = 'gaussian';
		kernel_width = 0.6;

		if 1
			% data is features x n
			if task == 1
				% separable data with sinewave boundary
				data = 2*rand(2, 2*n)-1;
				y = sin(1.5*pi*data(1, :))/2;
				i = find(data(2, :) < y);
				train1 = data(:, i);
				i = find(data(2, :) > y);
				train2 = data(:, i);
				axis([0 1 0 1]);
			elseif task == 2
				% separable data with circular boundary
				data = 2*rand(2, 2*n)-1;
				s = sum(data.^2);
				i = find(s <= 1/2);
				train1 = data(:,i);
				i = find(s > 1/2);
				train2 = data(:,i);
			elseif task == 3
				% nonseparable data with bimodal class
				v = eye(2)/25;
				train1 = randnorm(n/2, [0;0], [], v);
				train2 = [randnorm(n/4, [-1; 1]*0.5, [], v) ...
							randnorm(n/4, [1; -1]*0.5, [], v)];
			else
				% nonseparable data with Gaussian classes
				v1 = randn(2)/5;
				v1 = v1*v1';
				v2 = randn(2)/5;
				v2 = v2*v2';
				v1 = eye(2)/5;
				v2 = [1 0.9; 0.9 1]/17;
				train1 = randnorm(n/2, [-0.5;0], [], v1);
				train2 = randnorm(n/2, [0.5;0], [], v2);
			end
		end

		figure(fig);
		clf
		plot(train1(1, :), train1(2, :), 'o', train2(1, :), train2(2, :), 'x');

		if features == 1
			train1f = polynomial_embedding(train1, k);
			train2f = polynomial_embedding(train2, k);
		elseif strcmp(kernel,'quad')
			% "a" removes redundant rows
			%a = pinv(duplication(2));
			a = [1 0 0 0; 0 0.5 0.5 0; 0 0 0 1];
			train1f = [ones(1,cols(train1)); train1; a*outer(train1,train1)];
			train2f = [ones(1,cols(train2)); train2; a*outer(train2,train2)];
		elseif strcmp(kernel,'linear')
			train1f = [ones(1,cols(train1)); train1];
			train2f = [ones(1,cols(train2)); train2];
		else
			% kernel = 'gaussian'
			centers = [train1 train2];
			i = randperm(cols(centers));
			centers = centers(:,i);
			train1f = exp(-sqdist(centers, train1)/(2*kernel_width^2));
			train2f = exp(-sqdist(centers, train2)/(2*kernel_width^2));
		end

		data = [train1f -train2f];

		% Logistic regression
		obj = logit_density(ones(rows(data), 1)/10, 0);
		obj.e_type = 'fixed';
		% Use a very weak Gaussian prior.
		obj.prior_type = 'gaussian';
		obj.prior_icov = eye(rows(data))/1e6;
		obj = train(obj, data);
		if 0
			% squared-error method
			b = data' \ ones(cols(data), 1);
			obj = logit_density(b);
		end

		% number of errors
		errs = sum(exp(logProb(obj, data)) <= 0.5);
		%fprintf('%d training errors\n', errs);
		like = sum(logProb(obj, data));
		ev = evidence(obj, data);
		title(sprintf('Task %d %s evidence=%g', task, kernel, ev))

		if 1
			% plot the decision boundary
			r = linspace(-1,1,200);
			xy = ndgridmat(r,r)';
			if features == 1
				xy = polynomial_embedding(xy, k);
			elseif strcmp(kernel,'quad')
				%a = pinv(duplication(2));
				a = [1 0 0 0; 0 0.5 0.5 0; 0 0 0 1];
				xy = [ones(1,cols(xy)); xy; a*outer(xy,xy)];
			elseif strcmp(kernel,'linear')
				xy = [ones(1,cols(xy)); xy];
			else % kernel = 'gaussian'
				xy = exp(-sqdist(centers, xy)/(2*kernel_width^2));
			end
			p = exp(logProb(obj, xy));
			side = sqrt(cols(p));
			p = reshape(p,side,side)';
			p = (p > 0.5);

			hold on
			c = 0.5+1e-4;
			contour(r,r,p,[c c],'m');
			hold off
			axis([-1 1 -1 1]);
			set(gcf,'PaperPosition',[0.25 2.5 4 4])

			if 0
				figure(2)
				mesh(r, r, p)
				rotate3d on
			end
		end
		fig = fig+1;
	end
end
