clear all;
close all;
clc;
%input data
A = importdata('linear_sp.txt');

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
%making covariance matrix same for all cases, by taking their mean
av1=0;av2=0;av3=0;
for i=1:2
    for j=1:2
        av1=av1+sigma_C1(i,j);
        av2=av2+sigma_C2(i,j);
        av3=av3+sigma_C3(i,j);
    end
end
av1=av1/4;
av2=av2/4;
av3=av3/4;
for i=1:2
    for j=1:2
        if(i~=j)
            sigma_C1(i,j) = 0;
            sigma_C2(i,j) = 0;
            sigma_C3(i,j) = 0;
        else
            sigma_C1(i,j) = av1;
            sigma_C2(i,j) = av2;
            sigma_C3(i,j) = av3;
        end
    end
end


%{
%plotting scatter plots
scatter(class1(:,1),class1(:,2),'o', 'MarkerFaceColor','r');
hold on;
scatter(class2(:,1),class2(:,2),'o', 'MarkerFaceColor','g');
hold on;
scatter(class3(:,1),class3(:,2),'o', 'MarkerFaceColor','b');
hold on;
%}

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
 f1  = ezplot(b12,[a(2,1),25,-5,25] );
 set(f1 , 'color'  , 'r'  );
 hold on;
 
%black line divides blue and green
  f3 = ezplot(b23,[a(2,1),25,-5,25]  );
   set(f3 , 'color'  , 'k'  );
    hold on ;
%blue line divides red and blue
 f2 = ezplot(b13,[-5,a(2,1),-5,25]  ) ;
  set(f2 , 'color'  , 'b'  );
  hold on;
%  fill(b12,b23,'y');




% for i = [-5:0.8:25]
%     for j = [-5:0.8:25]
%         g1_rand = [i j]*a1*[i;j] + b1'*[i;j] + c1;
%         g2_rand = [i j]*a2*[i;j] + b2'*[i;j] + c2;
%         g3_rand = [i j]*a3*[i;j] + b3'*[i;j] + c3;
%         if((g1_rand > g2_rand) & (g1_rand > g3_rand))
%             scatter(i,j,'.g');
%             hold on;
%         elseif((g2_rand > g1_rand) & (g2_rand > g3_rand))
%             scatter(i,j,'.b');
%             hold on;
%         else((g3_rand > g2_rand) & (g3_rand > g1_rand))
%             scatter(i,j,'.r'); 
%             hold on;
%         end
%     end
% end

%plotting scatter plots
scatter(class1(:,1),class1(:,2),'o', 'MarkerFaceColor','r');
hold on;
scatter(class2(:,1),class2(:,2),'o', 'MarkerFaceColor','g');
hold on;
scatter(class3(:,1),class3(:,2),'o', 'MarkerFaceColor','b');
hold on;

%plotting format is x1-x2   y1-y2
plot([mu_C1(1,1) mu_C2(1,1)],[mu_C1(1,2) mu_C2(1,2)],'k');
hold on;
plot([mu_C1(1,1) mu_C3(1,1)],[mu_C1(1,2) mu_C3(1,2)],'k');
hold on;
plot([mu_C2(1,1) mu_C3(1,1)],[mu_C2(1,2) mu_C3(1,2)],'k');
hold on;

title('Decision Boundary and Decision Surface')
xlabel('Feature 1') % x-axis label
ylabel('Feature 2') % y-axis label
%zlabel('Probability') % z-axis label