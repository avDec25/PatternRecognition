clear all;
close all;
clc;
%input data
A = importdata('real.txt');
class1 = A([1:350],[1:2]);          %class 1
class2 = A([501:850],[1:2]);        %class 2
class3 = A([1001:1350],[1:2]);      %class 3

mu_C1 = mean(class1);
mu_C2 = mean(class2);
mu_C3 = mean(class3);

sigma_C1 = cov(class1);
sigma_C2 = cov(class2);
sigma_C3 = cov(class3);

%making covariance matrix same for all cases, by taking their mean
sigma_C1 = cov(class1);
sigma_C2 = cov(class2);
sigma_C3 = cov(class3);
sg = (sigma_C1 + sigma_C2 + sigma_C3)/3;
sigma_C1 = sg;
sigma_C2 = sg;
sigma_C3 = sg;
% %{
% %plotting scatter plots
% scatter(class1(:,1),class1(:,2),'o', 'MarkerFaceColor','r');
% hold on;
% scatter(class2(:,1),class2(:,2),'o', 'MarkerFaceColor','g');
% hold on;
% scatter(class3(:,1),class3(:,2),'o', 'MarkerFaceColor','b');
% hold on;
% %}

syms x1 x2;
%a1 = -0.5*inv(sigma_C1);
b1 = inv(sigma_C1)*mu_C1';
c1 = -0.5*mu_C1*inv(sigma_C1)*mu_C1' - 0.5*log(det(sigma_C1));
%g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
g1 = b1'*[x1;x2] + c1;

%a2 = -0.5*inv(sigma_C2);
b2 = inv(sigma_C2)*mu_C2';
c2 = -0.5*mu_C2*inv(sigma_C2)*mu_C2' - 0.5*log(det(sigma_C2));
%g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
g2 = b2'*[x1;x2] + c2;

%a3 = -0.5*inv(sigma_C3);
b3 = inv(sigma_C3)*mu_C3';
c3 = -0.5*mu_C3*inv(sigma_C3)*mu_C3' - 0.5*log(det(sigma_C3));
%g3 = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;
g3 = b3'*[x1;x2] + c3;

b12 = g1 - g2;
b13 = g1 - g3;
b23 = g2 - g3;


[a b] = solve(b12,b23);
a  = double(a);
b  = double(b);

%decision boundaries meet at 4 points in a 2 dimensional plane
%there fore each of a b are 4 x 1 vectors, corresponding to the coordinates
%of the intersection.

%red line divides red and green
 f1  = ezplot(b12, [0,420,0,3000]);
 set(f1 , 'color'  , 'r'  );
 hold on;
 
%black line divid, [0,1400,0,3000]es blue and green
  f3 = ezplot(b23, [420,1400,0,3000]);
   set(f3 , 'color'  , 'k'  );
    hold on ;
%blue line divides red and blue
 f2 = ezplot(b13, [420,1400,0,3000]) ;
  set(f2 , 'color'  , 'b'  );
  hold on;
%  fill(b12,b23,'y');




for i = [0:10:1400]
    for j = [0:50:3000]
        g1_rand = b1'*[i;j] + c1;
        g2_rand = b2'*[i;j] + c2;
        g3_rand = b3'*[i;j] + c3;
        if((g1_rand > g2_rand) & (g1_rand > g3_rand))
            scatter(i,j,'.g');
            hold on;
        elseif((g2_rand > g1_rand) & (g2_rand > g3_rand))
            scatter(i,j,'.b');
            hold on;
        else((g3_rand > g2_rand) & (g3_rand > g1_rand))
            scatter(i,j,'.r'); 
            hold on;
        end
    end
end

%plotting scatter plots
scatter(class1(:,1),class1(:,2),'o', 'MarkerFaceColor','r');
hold on;
scatter(class2(:,1),class2(:,2),'o', 'MarkerFaceColor','g');
hold on;
scatter(class3(:,1),class3(:,2),'o', 'MarkerFaceColor','b');
hold on;

%line between all classes, plotting format is x1-x2   y1-y2
plot([mu_C1(1,1) mu_C2(1,1)],[mu_C1(1,2) mu_C2(1,2)],'k');
hold on;
plot([mu_C1(1,1) mu_C3(1,1)],[mu_C1(1,2) mu_C3(1,2)],'k');
hold on;
plot([mu_C2(1,1) mu_C3(1,1)],[mu_C2(1,2) mu_C3(1,2)],'k');
hold on;

  