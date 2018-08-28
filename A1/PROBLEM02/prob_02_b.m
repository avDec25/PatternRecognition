%% Polynomial Regression on 2D data
 % Question 2(a)
clear; clc; close all;

%% importing data
data = importdata('./data/q24_2.txt');
   x1 = data(:,1);
   x2 = data(:,2);
    y = data(:,3);

%% creating Vandermonde Matrix from the data
n = 3;
x1 = x1(:);
x2 = x2(:);
V = ones(length(x1),1);

V = [V x1 x2 power(x1,2) x1.*x2 power(x2,2) ...
    power(x1,3) power(x1,2).*x2 x1.*power(x2,2) power(x2,3)];

%% Computing the Coefficients of Polynomial
% p = (transpose(V)*V) \ (transpose(V) * y);
[Q,R] = qr_decompose(V);
p     = transpose(R \ (transpose(Q) * y(:)));

%% Plotting estimated polynomial & getting Residual squared error

[fitresult, gof] = displayFit(x1, x2, y);
RSE = gof.sse

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

function [fitresult, gof] = displayFit(x1, x2, y)
[xData, yData, zData] = prepareSurfaceData( x1, x2, y );

% Set up fittype and options.
ft = fittype( 'poly33' );

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft );

% Plot fit with data.
figure( 'Name', 'Regression' );
h = plot( fitresult, [xData, yData], zData );
legend( h, 'Regression', 'y vs. x_1, x_2', 'Location', 'NorthEast' );
% Label axes
xlabel x_1
ylabel x_2
zlabel y
grid on
view( -1.9, 2.0 );
end