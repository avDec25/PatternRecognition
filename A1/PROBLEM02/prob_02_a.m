%% Polynomial Regression on 1D data
 % Question 2(a)
clear; clc; close all;

%% importing data
data = importdata('./data/q24_1.txt');
   x = data(:,1);
   y = data(:,2);


%% creating Vandermonde Matrix from the data
n = 4;
x = x(:);
V = ones(length(x), n + 1);
for j = n:-1:1
   V(:, j) = V(:, j + 1) .* x;
end

%% Solving the system of linear equation to get polynomial coefficients
[Q,R] = qr_decompose(V);
p     = transpose(R \ (transpose(Q) * y(:))); % In decreasing order
                                              % of x-degree they are they
                                              % are associated with
 

%% Plotting estimated polynomial
[r_x,c_x] = size(x);
Ynew = zeros(r_x:1);

for i = 1:1:r_x 
      Ynew(i) = polyval(p,x(i));      
end

RSE = sum(power(y-Ynew',2))

plot(x,y,'bo');
xlabel('From data x-values')
ylabel('From data y-values')
hold on
plot(x,Ynew','r*');
legend('Data','Regression');

%% Ridge Regression

% A(r_x by n+1 matrix) and b(r_x by 1 matrix)
A = V;
b = y;
lambda = 0.01;

% centering and scaling A 
s = std(A,0,1);
s = repmat(s,r_x,1);
A = (A-repmat(mean(A),r_x,1))./s;

% X1 contains coefficients for Ridge Regression
X1 = inv(A'*A+eye(n+1)*lambda)*A'*b;

[rr_x,rc_x] = size(x);
rYnew = zeros(rr_x:1);

for i = 1:1:rr_x 
      rYnew(i) = polyval(X1,x(i));
end

rrse = sum(power(y-rYnew',2));


%% Utility functions
function [Q,R] = qr_decompose(A)
    % Computing the QR decomposition of an m-by-n matrix A using
    % Householder transformations.
    [m,n] = size(A);
    Q = eye(m); % Orthogonal transform so far
    R = A;      % Transformed matrix so far
    for j = 1:n
        % Finding H = I-tau*w*w’ to put zeros below R(j,j)
        normx = norm(R(j:end,j));
        s = -sign(R(j,j));
        u1 = R(j,j) - s*normx;
        w = R(j:end,j)/u1;
        w(1) = 1;
        tau = -s*u1/normx;
        % R = HR, Q = QH
        R(j:end,:) = R(j:end,:)-(tau*w)*(w'*R(j:end,:));
        Q(:,j:end) = Q(:,j:end)-(Q(:,j:end)*w)*(tau*w)';
    end
end