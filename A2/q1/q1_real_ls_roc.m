clear all
close all
clc;
%input data
A = importdata('real.txt');

class1 = A([1:350],[1:2]);          %class 1
class2 = A([501:850],[1:2]);        %class 2
class3 = A([1001:1350],[1:2]);      %class 3

cl1 = A([351:450],[1:2]);          %class 1
cl2 = A([851:950],[1:2]);        %class 2
cl3 = A([1351:1450],[1:2]);      %class 3

c = [cl1;cl2;cl3];
m = zeros(300,5);



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

%defining the discriminant functions

syms x1 x2;
a1 = -0.5*inv(sigma_C1);
b1 = inv(sigma_C1)*mu_C1';
c1 = -0.5*mu_C1*inv(sigma_C1)*mu_C1' - 0.5*log(det(sigma_C1));
%g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
g1 = b1'*[x1;x2] + c1;

a2 = -0.5*inv(sigma_C2);
b2 = inv(sigma_C2)*mu_C2';
c2 = -0.5*mu_C2*inv(sigma_C2)*mu_C2' - 0.5*log(det(sigma_C2));
%g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
g2 = b2'*[x1;x2] + c2;

a3 = -0.5*inv(sigma_C3);
b3 = inv(sigma_C3)*mu_C3';
c3 = -0.5*mu_C3*inv(sigma_C3)*mu_C3' - 0.5*log(det(sigma_C3));
%g3 = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;
g3 = b3'*[x1;x2] + c3;

%defining the score matrix
for i=1:300
    
        x1 = c(i,1);
        x2 = c(i,2);
        
        if(i<=100)
        m(i,1) = 1;
        elseif(i<=200)
        m(i,1) = 2;
        else
        m(i,1) = 3;
        end
        
         g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
        g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
        g3 = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;
        m(i,3) = g1;
        m(i,4) = g2;
        m(i,5) = g3;
        
        if(g1>=g2 && g1>=g3)
            m(i,2) = 1;
        elseif(g2>=g1 && g2>=g3)
            m(i,2) = 2;
        else(g3>=g2 && g3>=g1)
            m(i,2) = 3;
        end
end

tpr = zeros(300,3);
fpr = zeros(300,3);
fnr = zeros(300,3);

%classifying wrt g1
m = sortrows(m,3);

for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    
    for q = 1:th
        if(m(q,1) == m(q,2) && (m(q,1)==1)) 
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th+1:300
        if(m(q,1) == m(q,2) && (m(q,1)==1))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,1) = tp/(tp+fn);
    fpr(th,1) = fp/(fp+tn);
    fnr(th,1) = 1-tpr(th,1);%fn/(tp+fn)
end


%classifying wrt g2
m = sortrows(m,4);
for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) == m(q,2))&&(m(q,2) == 2))
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th:300
        if((m(q,1) == m(q,2))&&(m(q,2) == 2))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,2) = tp/(tp+fn);
    fpr(th,2) = fp/(fp+tn);
    fnr(th,2) = 1-tpr(th,2);%fn/(tp+fn)
end

%classifying wrt g3
m = sortrows(m,5);
for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) == m(q,2))&&(m(q,2) == 3))
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th:300
        if((m(q,1) == m(q,2))&&(m(q,2) == 3))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,3) = tp/(tp+fn);
    fpr(th,3) = fp/(fp+tn);
    fnr(th,3) = 1-tpr(th,3);%fn/(tp+fn);
end
x=mean(tpr,2);%mean tpr
y=mean(fpr,2);%mean fpr
z=mean(fnr,2);%mean fnr

plot(y,z,'r');
hold on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% q2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%input data
A = importdata('real.txt');

class1 = A([1:350],[1:2]);          %class 1
class2 = A([501:850],[1:2]);        %class 2
class3 = A([1001:1350],[1:2]);      %class 3

cl1 = A([351:450],[1:2]);          %class 1
cl2 = A([851:950],[1:2]);        %class 2
cl3 = A([1351:1450],[1:2]);      %class 3

c = [cl1;cl2;cl3];
m = zeros(300,5);



mu_C1 = mean(class1);
mu_C2 = mean(class2);
mu_C3 = mean(class3);

sigma_C1 = cov(class1);
sigma_C2 = cov(class2);
sigma_C3 = cov(class3);


%defining the discriminant functions

syms x1 x2;
a1 = -0.5*inv(sigma_C1);
b1 = inv(sigma_C1)*mu_C1';
c1 = -0.5*mu_C1*inv(sigma_C1)*mu_C1' - 0.5*log(det(sigma_C1));
g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
%g1 = b1'*[x1;x2] + c1;

a2 = -0.5*inv(sigma_C2);
b2 = inv(sigma_C2)*mu_C2';
c2 = -0.5*mu_C2*inv(sigma_C2)*mu_C2' - 0.5*log(det(sigma_C2));
g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
%g2 = b2'*[x1;x2] + c2;

a3 = -0.5*inv(sigma_C3);
b3 = inv(sigma_C3)*mu_C3';
c3 = -0.5*mu_C3*inv(sigma_C3)*mu_C3' - 0.5*log(det(sigma_C3));
g3 = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;
%g3 = b3'*[x1;x2] + c3;

%defining the score matrix
for i=1:300
    
        x1 = c(i,1);
        x2 = c(i,2);
        
        if(i<=100)
        m(i,1) = 1;
        elseif(i<=200)
        m(i,1) = 2;
        else
        m(i,1) = 3;
        end
        
        g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
        g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
        g3 = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;
        m(i,3) = g1;
        m(i,4) = g2;
        m(i,5) = g3;
        
        if(g1>=g2 && g1>=g3)
            m(i,2) = 1;
        elseif(g2>=g1 && g2>=g3)
            m(i,2) = 2;
        else(g3>=g2 && g3>=g1)
            m(i,2) = 3;
        end
end

tpr = zeros(300,3);
fpr = zeros(300,3);
fnr = zeros(300,3);

%classifying wrt g1
m = sortrows(m,3);

for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    
    for q = 1:th
        if(m(q,1) == m(q,2) && (m(q,1)==1)) 
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th+1:300
        if(m(q,1) == m(q,2) && (m(q,1)==1))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,1) = tp/(tp+fn);
    fpr(th,1) = fp/(fp+tn);
    fnr(th,1) = 1-tpr(th,1);%fn/(tp+fn)
end


%classifying wrt g2
m = sortrows(m,4);
for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) == m(q,2))&&(m(q,2) == 2))
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th:300
        if((m(q,1) == m(q,2))&&(m(q,2) == 2))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,2) = tp/(tp+fn);
    fpr(th,2) = fp/(fp+tn);
    fnr(th,2) = 1-tpr(th,2);%fn/(tp+fn)
end

%classifying wrt g3
m = sortrows(m,5);
for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) == m(q,2))&&(m(q,2) == 3))
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th:300
        if((m(q,1) == m(q,2))&&(m(q,2) == 3))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,3) = tp/(tp+fn);
    fpr(th,3) = fp/(fp+tn);
    fnr(th,3) = 1-tpr(th,3);%fn/(tp+fn);
end
x=mean(tpr,2);%mean tpr
y=mean(fpr,2);%mean fpr
z=mean(fnr,2);%mean fnr

plot(y,z,'g');
hold on;

     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     q3        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%input data
A = importdata('real.txt');

class1 = A([1:350],[1:2]);          %class 1
class2 = A([501:850],[1:2]);        %class 2
class3 = A([1001:1350],[1:2]);      %class 3

cl1 = A([351:450],[1:2]);          %class 1
cl2 = A([851:950],[1:2]);        %class 2
cl3 = A([1351:1450],[1:2]);      %class 3

c = [cl1;cl2;cl3];
m = zeros(300,5);



mu_C1 = mean(class1);
mu_C2 = mean(class2);
mu_C3 = mean(class3);

sigma_C1 = cov(class1);
sigma_C2 = cov(class2);
sigma_C3 = cov(class3);

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


%defining the discriminant functions

syms x1 x2;
a1 = -0.5*inv(sigma_C1);
b1 = inv(sigma_C1)*mu_C1';
c1 = -0.5*mu_C1*inv(sigma_C1)*mu_C1' - 0.5*log(det(sigma_C1));
g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
%g1 = b1'*[x1;x2] + c1;

a2 = -0.5*inv(sigma_C2);
b2 = inv(sigma_C2)*mu_C2';
c2 = -0.5*mu_C2*inv(sigma_C2)*mu_C2' - 0.5*log(det(sigma_C2));
g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
%g2 = b2'*[x1;x2] + c2;

a3 = -0.5*inv(sigma_C3);
b3 = inv(sigma_C3)*mu_C3';
c3 = -0.5*mu_C3*inv(sigma_C3)*mu_C3' - 0.5*log(det(sigma_C3));
g3 = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;
%g3 = b3'*[x1;x2] + c3;

%defining the score matrix
for i=1:300
    
        x1 = c(i,1);
        x2 = c(i,2);
        
        if(i<=100)
        m(i,1) = 1;
        elseif(i<=200)
        m(i,1) = 2;
        else
        m(i,1) = 3;
        end
        
        g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
        g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
        g3 = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;
        m(i,3) = g1;
        m(i,4) = g2;
        m(i,5) = g3;
        
        if(g1>=g2 && g1>=g3)
            m(i,2) = 1;
        elseif(g2>=g1 && g2>=g3)
            m(i,2) = 2;
        else(g3>=g2 && g3>=g1)
            m(i,2) = 3;
        end
end

tpr = zeros(300,3);
fpr = zeros(300,3);
fnr = zeros(300,3);

%classifying wrt g1
m = sortrows(m,3);

for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    
    for q = 1:th
        if(m(q,1) == m(q,2) && (m(q,1)==1)) 
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th+1:300
        if(m(q,1) == m(q,2) && (m(q,1)==1))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,1) = tp/(tp+fn);
    fpr(th,1) = fp/(fp+tn);
    fnr(th,1) = 1-tpr(th,1);%fn/(tp+fn)
end


%classifying wrt g2
m = sortrows(m,4);
for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) == m(q,2))&&(m(q,2) == 2))
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th:300
        if((m(q,1) == m(q,2))&&(m(q,2) == 2))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,2) = tp/(tp+fn);
    fpr(th,2) = fp/(fp+tn);
    fnr(th,2) = 1-tpr(th,2);%fn/(tp+fn)
end

%classifying wrt g3
m = sortrows(m,5);
for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) == m(q,2))&&(m(q,2) == 3))
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th:300
        if((m(q,1) == m(q,2))&&(m(q,2) == 3))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,3) = tp/(tp+fn);
    fpr(th,3) = fp/(fp+tn);
    fnr(th,3) = 1-tpr(th,3);%fn/(tp+fn);
end
x=mean(tpr,2);%mean tpr
y=mean(fpr,2);%mean fpr
z=mean(fnr,2);%mean fnr

plot(y,z,'b');
hold on;

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   q4     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%input data
A = importdata('real.txt');

class1 = A([1:350],[1:2]);          %class 1
class2 = A([501:850],[1:2]);        %class 2
class3 = A([1001:1350],[1:2]);      %class 3

cl1 = A([351:450],[1:2]);          %class 1
cl2 = A([851:950],[1:2]);        %class 2
cl3 = A([1351:1450],[1:2]);      %class 3

c = [cl1;cl2;cl3];
m = zeros(300,5);



mu_C1 = mean(class1);
mu_C2 = mean(class2);
mu_C3 = mean(class3);

sigma_C1 = cov(class1);
sigma_C2 = cov(class2);
sigma_C3 = cov(class3);

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

%defining the discriminant functions

syms x1 x2;
a1 = -0.5*inv(sigma_C1);
b1 = inv(sigma_C1)*mu_C1';
c1 = -0.5*mu_C1*inv(sigma_C1)*mu_C1' - 0.5*log(det(sigma_C1));
g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
%g1 = b1'*[x1;x2] + c1;

a2 = -0.5*inv(sigma_C2);
b2 = inv(sigma_C2)*mu_C2';
c2 = -0.5*mu_C2*inv(sigma_C2)*mu_C2' - 0.5*log(det(sigma_C2));
g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
%g2 = b2'*[x1;x2] + c2;

a3 = -0.5*inv(sigma_C3);
b3 = inv(sigma_C3)*mu_C3';
c3 = -0.5*mu_C3*inv(sigma_C3)*mu_C3' - 0.5*log(det(sigma_C3));
g3 = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;
%g3 = b3'*[x1;x2] + c3;

%defining the score matrix
for i=1:300
    
        x1 = c(i,1);
        x2 = c(i,2);
        
        if(i<=100)
        m(i,1) = 1;
        elseif(i<=200)
        m(i,1) = 2;
        else
        m(i,1) = 3;
        end
        
         g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
        g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
        g3 = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;
        m(i,3) = g1;
        m(i,4) = g2;
        m(i,5) = g3;
        
        if(g1>=g2 && g1>=g3)
            m(i,2) = 1;
        elseif(g2>=g1 && g2>=g3)
            m(i,2) = 2;
        else(g3>=g2 && g3>=g1)
            m(i,2) = 3;
        end
end

tpr = zeros(300,3);
fpr = zeros(300,3);
fnr = zeros(300,3);

%classifying wrt g1
m = sortrows(m,3);

for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    
    for q = 1:th
        if(m(q,1) == m(q,2) && (m(q,1)==1)) 
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th+1:300
        if(m(q,1) == m(q,2) && (m(q,1)==1))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,1) = tp/(tp+fn);
    fpr(th,1) = fp/(fp+tn);
    fnr(th,1) = 1-tpr(th,1);%fn/(tp+fn)
end


%classifying wrt g2
m = sortrows(m,4);
for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) == m(q,2))&&(m(q,2) == 2))
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th:300
        if((m(q,1) == m(q,2))&&(m(q,2) == 2))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,2) = tp/(tp+fn);
    fpr(th,2) = fp/(fp+tn);
    fnr(th,2) = 1-tpr(th,2);%fn/(tp+fn)
end

%classifying wrt g3
m = sortrows(m,5);
for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) == m(q,2))&&(m(q,2) == 3))
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th:300
        if((m(q,1) == m(q,2))&&(m(q,2) == 3))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,3) = tp/(tp+fn);
    fpr(th,3) = fp/(fp+tn);
    fnr(th,3) = 1-tpr(th,3);%fn/(tp+fn);
end
x=mean(tpr,2);%mean tpr
y=mean(fpr,2);%mean fpr
z=mean(fnr,2);%mean fnr

plot(y,z,'c');
hold on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% q5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
 
%input data
A = importdata('real.txt');

class1 = A([1:350],[1:2]);          %class 1
class2 = A([501:850],[1:2]);        %class 2
class3 = A([1001:1350],[1:2]);      %class 3

cl1 = A([351:450],[1:2]);          %class 1
cl2 = A([851:950],[1:2]);        %class 2
cl3 = A([1351:1450],[1:2]);      %class 3

c = [cl1;cl2;cl3];
m = zeros(300,5);



mu_C1 = mean(class1);
mu_C2 = mean(class2);
mu_C3 = mean(class3);

sigma_C1 = cov(class1);
sigma_C2 = cov(class2);
sigma_C3 = cov(class3);

%making non diagonal elements zero
for i=1:2
    for j=1:2
        if(i~=j)
            sigma_C1(i,j) = 0;
            sigma_C2(i,j) = 0;
            sigma_C3(i,j) = 0;
        end
    end
end


%defining the discriminant functions

syms x1 x2;
a1 = -0.5*inv(sigma_C1);
b1 = inv(sigma_C1)*mu_C1';
c1 = -0.5*mu_C1*inv(sigma_C1)*mu_C1' - 0.5*log(det(sigma_C1));
g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
%g1 = b1'*[x1;x2] + c1;

a2 = -0.5*inv(sigma_C2);
b2 = inv(sigma_C2)*mu_C2';
c2 = -0.5*mu_C2*inv(sigma_C2)*mu_C2' - 0.5*log(det(sigma_C2));
g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
%g2 = b2'*[x1;x2] + c2;

a3 = -0.5*inv(sigma_C3);
b3 = inv(sigma_C3)*mu_C3';
c3 = -0.5*mu_C3*inv(sigma_C3)*mu_C3' - 0.5*log(det(sigma_C3));
g3 = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;
%g3 = b3'*[x1;x2] + c3;

%defining the score matrix
for i=1:300
    
        x1 = c(i,1);
        x2 = c(i,2);
        
        if(i<=100)
        m(i,1) = 1;
        elseif(i<=200)
        m(i,1) = 2;
        else
        m(i,1) = 3;
        end
        
        g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
        g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
        g3 = [x1 x2]*a3*[x1;x2] + b3'*[x1;x2] + c3;
        m(i,3) = g1;
        m(i,4) = g2;
        m(i,5) = g3;
        
        if(g1>=g2 && g1>=g3)
            m(i,2) = 1;
        elseif(g2>=g1 && g2>=g3)
            m(i,2) = 2;
        else(g3>=g2 && g3>=g1)
            m(i,2) = 3;
        end
end

tpr = zeros(300,3);
fpr = zeros(300,3);
fnr = zeros(300,3);

%classifying wrt g1
m = sortrows(m,3);

for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    
    for q = 1:th
        if(m(q,1) == m(q,2) && (m(q,1)==1)) 
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th+1:300
        if(m(q,1) == m(q,2) && (m(q,1)==1))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,1) = tp/(tp+fn);
    fpr(th,1) = fp/(fp+tn);
    fnr(th,1) = 1-tpr(th,1);%fn/(tp+fn)
end


%classifying wrt g2
m = sortrows(m,4);
for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) == m(q,2))&&(m(q,2) == 2))
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th:300
        if((m(q,1) == m(q,2))&&(m(q,2) == 2))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,2) = tp/(tp+fn);
    fpr(th,2) = fp/(fp+tn);
    fnr(th,2) = 1-tpr(th,2);%fn/(tp+fn)
end

%classifying wrt g3
m = sortrows(m,5);
for th=1:300
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) == m(q,2))&&(m(q,2) == 3))
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th:300
        if((m(q,1) == m(q,2))&&(m(q,2) == 3))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,3) = tp/(tp+fn);
    fpr(th,3) = fp/(fp+tn);
    fnr(th,3) = 1-tpr(th,3);%fn/(tp+fn);
end
x=mean(tpr,2);%mean tpr
y=mean(fpr,2);%mean fpr
z=mean(fnr,2);%mean fnr

plot(y,z,'m');
hold on;

        
        
     
        


        
        
        

        
        
        
        