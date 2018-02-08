function [obj, logp] = train(obj, data, varargin)

[d,n] = size(data);

% the phase variable lets you train the parameters in stages
obj.phase = 0;
verbose = 0;
logp = -Inf;
niter = 1000;
for iter = 1:niter
  if verbose
    disp(['EM iteration ' num2str(iter) ' (phase ' num2str(obj.phase) ')']);
    if 0
      domain = 1:d;
      universe = Universe(repmat(2,1,d));
      plot_bpm_mix(fromDensity(domain,universe,obj),2);
    end
    drawnow
  end
  old_logp = logp;
  %obj.reweight = (iter > 1);
  %obj.reweight = 0;
  [obj, logp, activity] = train_generic(obj, data, varargin{:});
  if 0
    % If we are only plotting the likelihood, without the prior term,
    % sometimes the curve may decrease, because we are trading likelihood
    % for prior probability.
    score(iter) = logp;
    oldfig=gcf;figure(3);
    if iter > 60
      i = (50*floor(iter/50)):iter;
      plot(i,score(i));
    else
      plot(score);
    end
    figure(oldfig);
    drawnow;
  end
  activity = max(activity, abs(logp - old_logp));
  if ((iter > 2) & (activity < 1e-8)) | (rem(iter, 20) == 0)
    obj.phase = obj.phase + 1;
    if obj.phase == 10
      break
    end
  else
    if obj.phase > 0
      obj.phase = obj.phase - 1;
    end
  end
end
