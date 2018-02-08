function c = cluster_leaves(p)

[J,N] = size(p);
if 0
  % random init
  c = sample([1 1]/2, J);
else
  % non-random init
  c = ones(1,J);
  c(J) = 2;
end
current_score = score_assignment(c,p);

assign = [];
score = [];
temp = 100;
for iter = 1:10
  c
  assign(iter,:) = c;
  score(iter) = current_score;
  score2(iter) = score_assignment(c,p,2);

  for j = 1:J
    current = c(j);
    other = 3 - c(j);
    s(current) = current_score;
    new_c = c;
    new_c(j) = other;
    s(other) = score_assignment(new_c,p);
    if temp == 0
      % pick the best assignment
      [y,k] = min(s);
      c(j) = k;
    else
      q = exp(-s/temp);
      q = q./sum(q);
      c(j) = sample(q);
    end
    current_score = s(c(j));
  end
  if (temp == 0) & all(c == assign(iter,:))
    break
  end
end
score
score2
[y,i] = min(score);
c = assign(i,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function score = score_assignment(c, p, w)

lp = log(p);
[J,N] = size(p);

% compute cluster means
% compute intermediate probs
m = [];
v = [];
for k = 1:2
  j = find(c == k);
  if isempty(j)
    score = Inf;
    return
  end
  m(k,:) = col_sum(lp(j,:))/length(j);
  if length(j) > 1
    v(k) = 0;
    for j1 = j
      v(k) = v(k) + var(lp(j1,:) - m(k,:));
    end
  else
    % singleton leaf
    v(k) = -1;
  end
  pp(k,:) = col_sum(p(j,:));
end
% add parent variance
r = pp(1,:)./pp(2,:);
v(3) = var(log(r));

% remove singletons from v
v(find(v == -1)) = [];

if any(v == 0)
  score = -Inf;
  return
end

score = sum(log(v));
%score = score + length(v)/2;
return
v

% compute variance hyperparam
a = 1;
b = mean(v)/a;
score = sum((a/2-1)*log(v) - (a/2)*log(b) +b/2./v);
