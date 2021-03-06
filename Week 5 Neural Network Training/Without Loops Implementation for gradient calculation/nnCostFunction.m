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

X=[ones(m,1) X];
a2=sigmoid(X*Theta1');
a2=[ones(size(a2,1),1) a2];
a3=sigmoid(Theta2*a2');
% hx = a3
temp_y=y==[1:num_labels];  %The y provided is a vector but we need y in a matrix form with k*m dimension 
temp_y=temp_y';    %We need transpose to match dimensions with a3 which is matrix with activation value for m samples
J=sum(sum(-temp_y.*log(a3)-(1-temp_y).*log(1-a3)))*(1/m);
%Regularisation term
regterm=(lambda/(2*m))*(sum(sum(Theta1(:,2:size(Theta1,2)).^2))+sum(sum(Theta2(:,2:size(Theta2,2)).^2)));
J=J+regterm; %Add the regularization term


%Backpropagation for m training examples without loop

%Initialise partial derivatives
del1=zeros(size(Theta1)); 
del2=zeros(size(Theta2));

%Forwarded propagation of all 5000 samples 
z2=X*Theta1';  %matrix of size (5000,25)
a2=sigmoid(z2);
a2=[ones(m,1) a2]; %matrix of size (5000,26)
z3=a2*Theta2'; %matrix of size (5000,10)
a3=sigmoid(z3);

%Backpropagating the errors
errk=a3-temp_y'; %matrix of size(5000,10)
err2=(errk*Theta2)(:,2:end).*sigmoidGradient(z2);%matrix size (5000,25) 

%Using matrix multiplication to automaticaly sum up all samples
del2=errk'*a2; %matrix of size (10,26)
del1=err2'*X; %matrix of size (25,401)

%Finilising gradient
Theta1_grad=(1/m)*del1;
Theta2_grad=(1/m)*del2;

%calculating regularization terms
regterm1=(lambda/m)*Theta1;
regterm1(:,1)=0;
regterm2=(lambda/m)*Theta2;
regterm2(:,1)=0;

%Adding the regularization term
Theta1_grad=Theta1_grad+regterm1;
Theta2_grad=Theta2_grad+regterm2;
% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
