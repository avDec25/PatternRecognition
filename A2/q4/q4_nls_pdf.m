clear all;
close all;
clc;

%input data
A = importdata('class1.txt');
c1 = A([1:700],[1:2]);          %class 1
A = importdata('class2.txt');
c2 = A([1:700],[1:2]);        %class 2
A = importdata('class3.txt');
c3 = A([1:700],[1:2]);      %class 3

mu_C1 = mean(c1);
mu_C2 = mean(c2);
mu_C3 = mean(c3);

sigma_C1 = cov(c1);
sigma_C2 = cov(c2);
sigma_C3 = cov(c3);

%making covariance matrix same for all cases, by taking their mean
for i=1:2
    for j=1:2
        if(i~=j)
           sigma_C1(i,j) = 0;
           sigma_C2(i,j) = 0;
           sigma_C3(i,j) = 0;
        else
           x=(sigma_C1(i,j) + sigma_C2(i,j) + sigma_C3(i,j))/3;
           sigma_C1(i,j) = x;
           sigma_C2(i,j) = x;
           sigma_C3(i,j) = x;
        end
    end
end
 
%-------------------pdf for the first class---------------------
%finding the range of 2 random variables
xmin=c1(1,1);
xmax=c1(1,1);
ymin=c1(1,2);
ymax=c1(1,2);
for i=1:700
    if xmin > c1(i,1)
        xmin = c1(i,1);
    end
    if xmax < c1(i,1)
        xmax = c1(i,1);
    end
    if ymin > c1(i,2)
        ymin = c1(i,2);
    end
    if ymax < c1(i,2)
        ymax = c1(i,2);
    end
end

if(xmax*xmin>0)
incx = (xmax-xmin)/100;
else
incx = (xmax-xmin+1)/100;
end

if(ymax*ymin>0)
incy = (ymax-ymin)/100;
else
incy = (ymax-ymin)/100;
end;

%plotting the pdf for first class
mu = mu_C1';
sigma = sigma_C1;
[X,Y] = meshgrid(xmin:incx:xmax,ymin:incy:ymax);
% Define the constant
const = (1/sqrt(2*pi))^2;
const = const/sqrt(det(sigma));
% Compute Density at every point on the grid
temp = [X(:)-mu(1) Y(:)-mu(2)];
pdf = const*exp(-0.5*diag(temp*inv(sigma)*temp'));
pdf = reshape(pdf,size(X));
figure(1)

surf(X, Y, pdf); 
hold on;
[~,h] = contourf(X,Y,pdf);
h.ContourZLevel = -0.005;
depth = [-0.005 -0.005];
%plotting the eigen vectors 
[v,d] = eig(sigma);
v1 = v(:,1)*3;
v2 = v(:,2)*3;
plot3([mu(1,1) (v1(1,1)+mu(1,1))],[mu(2,1) (v1(2,1)+mu(2,1))],depth,'k');
hold on;
plot3([mu(1,1) (v2(1,1)+mu(1,1))],[mu(2,1) (v2(2,1)+mu(2,1))],depth,'k');
hold on;
%-------------------pdf for the second class---------------------
%finding the range of 2 random variables
xmin=c2(1,1);
xmax=c2(1,1);
ymin=c2(1,2);
ymax=c2(1,2);
for i=1:700
    if xmin > c2(i,1)
        xmin = c2(i,1);
    end
    if xmax < c2(i,1)
        xmax = c2(i,1);
    end
    if ymin > c2(i,2)
        ymin = c2(i,2);
    end
    if ymax < c2(i,2)
        ymax = c2(i,2);
    end
end

if(xmax*xmin>0)
incx = (xmax-xmin)/100;
else
incx = (xmax-xmin+1)/100;
end

if(ymax*ymin>0)
incy = (ymax-ymin)/100;
else
incy = (ymax-ymin)/100;
end;

%plotting the pdf for second class
mu = mu_C2';
sigma = sigma_C2;
[X,Y] = meshgrid(xmin:incx:xmax,ymin:incy:ymax);
% Define the constant
const = (1/sqrt(2*pi))^2;
const = const/sqrt(det(sigma));
% Compute Density at every point on the grid
temp = [X(:)-mu(1) Y(:)-mu(2)];
pdf = const*exp(-0.5*diag(temp*inv(sigma)*temp'));
pdf = reshape(pdf,size(X));

surf(X, Y, pdf); 
hold on;
[~,h] = contourf(X,Y,pdf);
h.ContourZLevel = -0.005;
depth = [-0.005 -0.005];
%plotting the eigen vectors 
[v,d] = eig(sigma);
v1 = v(:,1)*3;
v2 = v(:,2)*3;
plot3([mu(1,1) (v1(1,1)+mu(1,1))],[mu(2,1) (v1(2,1)+mu(2,1))],depth,'k');
hold on;
plot3([mu(1,1) (v2(1,1)+mu(1,1))],[mu(2,1) (v2(2,1)+mu(2,1))],depth,'k');
hold on;

%-------------------pdf for the third class---------------------
%finding the range of 2 random variables
xmin=c3(1,1);
xmax=c3(1,1);
ymin=c3(1,2);
ymax=c3(1,2);
for i=1:700
    if xmin > c3(i,1)
        xmin = c3(i,1);
    end
    if xmax < c3(i,1)
        xmax = c3(i,1);
    end
    if ymin > c3(i,2)
        ymin = c3(i,2);
    end
    if ymax < c3(i,2)
        ymax = c3(i,2);
    end
end

if(xmax*xmin>0)
incx = (xmax-xmin)/100;
else
incx = (xmax-xmin+1)/100;
end

if(ymax*ymin>0)
incy = (ymax-ymin)/100;
else
incy = (ymax-ymin)/100;
end;

%plotting the pdf for thirs class
mu = mu_C3';
sigma = sigma_C3;
[X,Y] = meshgrid(xmin:incx:xmax,ymin:incy:ymax);
% Define the constant
const = (1/sqrt(2*pi))^2;
const = const/sqrt(det(sigma));
% Compute Density at every point on the grid
temp = [X(:)-mu(1) Y(:)-mu(2)];
pdf = const*exp(-0.5*diag(temp*inv(sigma)*temp'));
pdf = reshape(pdf,size(X));

surf(X, Y, pdf); 
hold on;
[~,h] = contourf(X,Y,pdf);
h.ContourZLevel = -0.005;
depth = [-0.005 -0.005];
%plotting the eigen vectors 
[v,d] = eig(sigma);
v1 = v(:,1)*3;
v2 = v(:,2)*3;
plot3([mu(1,1) (v1(1,1)+mu(1,1))],[mu(2,1) (v1(2,1)+mu(2,1))],depth,'k');
hold on;
plot3([mu(1,1) (v2(1,1)+mu(1,1))],[mu(2,1) (v2(2,1)+mu(2,1))],depth,'k');
hold on;

title('Probability Distribution Function for Linearly Non Seperable Data')
xlabel('Feature 1') % x-axis label
ylabel('Feature 2') % y-axis label
zlabel('Probability') % z-axis label

colormap(cool);
%shading interp;