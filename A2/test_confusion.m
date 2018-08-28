clear all;
close all;
clc;
%input data
%A = importdata('linear_sp.txt');

A = importdata('class1.txt');
class1 = A([1:700],[1:2]);          %class 1
cl1 = A([701:900],[1:2]);          %class 1

A = importdata('class2.txt');
class2 = A([1:700],[1:2]);        %class 2
cl2 = A([701:900],[1:2]);        %class 2

A = importdata('class3.txt');
class3 = A([1:700],[1:2]);      %class 3

cl3 = A([701:900],[1:2]);      %class 3

mu_C1 = mean(class1);
mu_C2 = mean(class2);
mu_C3 = mean(class3);

sigma_C1 = cov(class1);
sigma_C2 = cov(class2);
sigma_C3 = cov(class3);


class_temp = [cl1;cl2;cl3];




syms x1 x2;
a1 = -0.5*inv(sigma_C1);
b1 = inv(sigma_C1)*mu_C1';
c1 = -0.5*mu_C1*inv(sigma_C1)*mu_C1' - 0.5*log(det(sigma_C1));
g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;

a2 = -0.5*inv(sigma_C2);
b2 = inv(sigma_C2)*mu_C2';
c2 = -0.5*mu_C2*inv(sigma_C2)*mu_C2' - 0.5*log(det(sigma_C2));
g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;


a3 = -0.5*inv(sigma_C3);
b3 = inv(sigma_C3)*mu_C3';
c3 = -0.5*mu_C3*inv(sigma_C3)*mu_C3' - 0.5*log(det(sigma_C3));
g3 = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;


tmp1 = ones(1,200);
tmp2 = ones(1,200)*2;
tmp3 = ones(1,200)*3;
actual_vector = [tmp1 tmp2 tmp3];
plotted_vector = zeros(1,300);

%classify each point according to the discriminant functions
for i = [1:600]
    x1 = class_temp(i,1);
    x2 = class_temp(i,2);
        g1_rand = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
        g2_rand = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
        g3_rand = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;
        if((g1_rand > g2_rand) & (g1_rand > g3_rand))
            plotted_vector(i) = 1;
        elseif((g2_rand > g1_rand) & (g2_rand > g3_rand))
            plotted_vector(i) = 2;
        else((g3_rand > g2_rand) & (g3_rand > g1_rand))
            plotted_vector(i) = 3;
        end
end

%create 3*3 matrices to send to plotconfusion
target = zeros(3, 600);
output = zeros(3, 600);
p1 = sub2ind(size(target),actual_vector,1:600);
p2 = sub2ind(size(output),plotted_vector,1:600);

target(p1) = 1;
output(p2) = 1;
c=plotconfusion(target,output);
