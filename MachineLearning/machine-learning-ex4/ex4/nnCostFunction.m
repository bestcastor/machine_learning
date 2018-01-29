function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Labels the 10 classes with 'y'; Note, we need to lables for all 5000 samples.

I = eye(num_labels);

Y = zeros(m, num_labels);
for i=1:m
  Y(i, :)= I(y(i), :);
end


% Get a1: We need to add the bias unit
a1 = [ones(m, 1) X];

% Get a2: We need to add the bias unit
z2 = a1 * Theta1';
a2 = [ones(size(z2, 1), 1) sigmoid(z2)];


% a3 = H
z3 = a2 * Theta2';
H = a3 = sigmoid(z3);

J = (1/m) * sum( sum( (-Y).*log(H) - (1 - Y).*log(1-H) ));

% regularization: Note: We need to remove the bias units from the Theta1 and Theta2

Reg = lambda/(2*m)* ( sum( sum(Theta1(:, 2:end).^2) ) + sum( sum(Theta2(:, 2:end).^2)));
J = J + Reg;  


% backpropagation
Sigma3 = a3 - Y;
%size(Sigma3) 5000* 10
%size(Theta2) 10 * 26
%size(z2)
sigG = sigmoidGradient([ones(size(z2, 1), 1) z2]);
%size(sigG) 5000 * 26

Sigma2 = (Sigma3 * Theta2 .* sigG)(:, 2: end);

%size(a2) 5000 * 26

delta_2 = Sigma3' * a2;
delta_1 = Sigma2' * a1;

% We need to remove the 1st column of the theta based on the definition;
Theta2_delta = [zeros(size(Theta2, 1), 1) Theta2(:, 2:end)];
Theta1_delta = [zeros(size(Theta1, 1), 1) Theta1(:, 2:end)];

Theta2_grad = (1/m) * delta_2 + (lambda/m) * Theta2_delta;

Theta1_grad = (1/m) * delta_1 + (lambda/m) * Theta1_delta;
























% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end