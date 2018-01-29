function J = costFunctionJ(X, y, theta)
  % X is the 'design matrix' contains our training samples
  % y is the class label vector

  m = size(X, 1);         % number of training samples
  predictions = X*theta;  % predictions of hypothesis on all m examples
  sqrErrors = (predictions - y).^2;  % squared errors

  J = 1/(2*m) * sum(sqrErrors);
