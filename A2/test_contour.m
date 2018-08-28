clear all;
close all;
clc;
%input data
A = importdata('linear_sp.txt');
%let it be, c1,c2,c3, donot change, works fine
class1 = A([1:350],[1:2]);          %class 1
class2 = A([501:850],[1:2]);        %class 2
class3 = A([1001:1350],[1:2]);      %class 3

mu_C1 = mean(class1);
mu_C2 = mean(class2);
mu_C3 = mean(class3);


sigma_C1 = cov(class1);
sigma_C2 = cov(class2);
sigma_C3 = cov(class3);
scatter(class1(:,1),class1(:,2),'o', 'MarkerFaceColor','r');
hold on;
scatter(class2(:,1),class2(:,2),'o', 'MarkerFaceColor','g');
hold on;
scatter(class3(:,1),class3(:,2),'o', 'MarkerFaceColor','b');
hold on;


%-------------------pdf for the first class---------------------
%finding the range of 2 random variables
xmin=class1(1,1);
xmax=class1(1,1);
ymin=class1(1,2);
ymax=class1(1,2);
for i=1:350
    if xmin > class1(i,1)
        xmin = class1(i,1);
    end
    if xmax < class1(i,1)
        xmax = class1(i,1);
    end
    if ymin > class1(i,2)
        ymin = class1(i,2);
    end
    if ymax < class1(i,2)
        ymax = class1(i,2);
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

contour(X,Y,pdf);
hold on;
[v,d] = eig(sigma_C1);
v1 = v(:,1)*3;
v2 = v(:,2)*3;
plot([mu(1,1) (v1(1,1)+mu(1,1))],[mu(2,1) (v1(2,1)+mu(2,1))],'k');
hold on;
plot([mu(1,1) (v2(1,1)+mu(1,1))],[mu(2,1) (v2(2,1)+mu(2,1))],'k');
hold on;
%-------------------pdf for the second class---------------------
%finding the range of 2 random variables
xmin=class2(1,1);
xmax=class2(1,1);
ymin=class2(1,2);
ymax=class2(1,2);
for i=1:350
    if xmin > class2(i,1)
        xmin = class2(i,1);
    end
    if xmax < class2(i,1)
        xmax = class2(i,1);
    end
    if ymin > class2(i,2)
        ymin = class2(i,2);
    end
    if ymax < class2(i,2)
        ymax = class2(i,2);
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

contour(X,Y,pdf);
hold on;
[v,d] = eig(sigma_C1);
v1 = v(:,1)*3;
v2 = v(:,2)*3;
plot([mu(1,1) (v1(1,1)+mu(1,1))],[mu(2,1) (v1(2,1)+mu(2,1))],'k');
hold on;
plot([mu(1,1) (v2(1,1)+mu(1,1))],[mu(2,1) (v2(2,1)+mu(2,1))],'k');
hold on;

%-------------------pdf for the third class---------------------
%finding the range of 2 random variables
xmin=class3(1,1);
xmax=class3(1,1);
ymin=class3(1,2);
ymax=class3(1,2);
for i=1:350
    if xmin > class3(i,1)
        xmin = class3(i,1);
    end
    if xmax < class3(i,1)
        xmax = class3(i,1);
    end
    if ymin > class3(i,2)
        ymin = class3(i,2);
    end
    if ymax < class3(i,2)
        ymax = class3(i,2);
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

contour(X,Y,pdf);
hold on;
[v,d] = eig(sigma_C1);
v1 = v(:,1)*3;
v2 = v(:,2)*3;
plot([mu(1,1) (v1(1,1)+mu(1,1))],[mu(2,1) (v1(2,1)+mu(2,1))],'k');
hold on;
plot([mu(1,1) (v2(1,1)+mu(1,1))],[mu(2,1) (v2(2,1)+mu(2,1))],'k');

