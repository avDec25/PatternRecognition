clear all;
close all;

x=importdata('lda_forest.mat');
y=importdata('lda_open.mat');
z=importdata('lda_tall.mat');

train_forest = []; 
train_open = [];
train_tall = [];
test_forest = []; 
test_open = [];
test_tall = [];

limit = floor(0.7*(size(x,1)/36))*36;
for i=1:size(x,1)
    if i<= limit
        train_forest = [train_forest;x(i,:)];
    else
        test_forest = [test_forest;x(i,:)];
    end
end


limit = floor(0.7*(size(y,1)/36))*36;
for i=1:size(y,1)
    if i<= limit
        train_open = [train_open;y(i,:)];
    else
        test_open = [test_open;y(i,:)];
    end
end


limit = floor(0.7*(size(z,1)/36))*36;
for i=1:size(z,1)
    if i<= limit
        train_tall = [train_tall;z(i,:)];
    else
        test_tall = [test_tall;z(i,:)];
    end
end

    
% plot(train_tall(:,1),train_tall(:,2), 'b.'); hold on;
% plot(train_open(:,1),train_open(:,2), 'g.'); hold on;
% plot(train_forest(:,1),train_forest(:,2), 'r.'); hold on;


% train_forest = x(1:floor(0.7*size(x,1)),:); 
% train_open = y(1:floor(0.7*size(y,1)),:);
% train_tall = z(1:floor(0.7*size(z,1)),:);
% test_forest = b.forest_projected; 
% test_open = b.opencountry_projected;
% test_tall = x(1:floor(0.7*size(x,1)),:);

% 
% plot(test_forest(:,1),test_forest(:,2), 'r.');hold on;
% plot(test_open(:,1),test_open(:,2), 'g.');hold on;
% plot(test_tall(:,1),test_tall(:,2), 'b.');hold on;
% 
% plot(train_forest(:,1),train_forest(:,2), 'r.');hold on;
% plot(train_open(:,1),train_open(:,2), 'g.');hold on;
% plot(train_tall(:,1),train_tall(:,2), 'b.');hold on;
% 



mean_forest = mean(train_forest);
mean_open = mean(train_open);
mean_tall = mean(train_tall);

sigma_forest = cov(train_forest);
sigma_open = cov(train_open);
sigma_tall = cov(train_tall);

sigma = (sigma_forest + sigma_open + sigma_tall)/3;
sigma_forest = sigma;
sigma_open = sigma;
sigma_tall = sigma;

score = zeros(size(test_forest,1)/36+size(test_open,1)/36+size(test_tall,1)/36,2);
for i=1:size(score,1)
    if i<=size(test_forest,1)/36
        score(i,1) = 1;
    elseif i<=size(test_forest,1)/36+size(test_open,1)/36
        score(i,1) = 2;
    else
        score(i,1) = 3;
    end
end

test = [test_forest;test_open;test_tall];

%defining linear classifier parameters for class 1 2 3;
a1 = -0.5*inv(sigma_forest);
b1 = inv(sigma_forest)*mean_forest';
c1 = -0.5*mean_forest*inv(sigma_forest)*mean_forest' - 0.5*log(det(sigma_forest));

a2 = -0.5*inv(sigma_open);
b2 = inv(sigma_open)*mean_open';
c2 = -0.5*mean_open*inv(sigma_open)*mean_open' - 0.5*log(det(sigma_open));

a3 = -0.5*inv(sigma_tall);
b3 = inv(sigma_tall)*mean_tall';
c3 = -0.5*mean_tall*inv(sigma_tall)*mean_tall' - 0.5*log(det(sigma_tall));

score_temp = zeros(size(test,1),1);

for i=1:size(test,1)
    x1 = test(i,1);
    x2 = test(i,2);
    g1 = [x1 x2]*a1*[x1;x2] + b1'*[x1;x2] + c1;
    g2 = [x1 x2]*a2*[x1;x2] + b2'*[x1;x2] + c2;
    g3 = [x1 x2]*a2*[x1;x2] + b3'*[x1;x2] + c3;
    if g1 > g2 && g1 > g3
        score_temp(i,1) = 1;
    elseif g2 > g1 && g2 > g3
        score_temp(i,1) = 2;
    else
        score_temp(i,1) = 3;
    end
end

i=1;
index = 1;
while i<=size(score_temp,1)
    c1=0;c2=0;c3=0;
    
    for j=i:i+35
        if score_temp(j,1) == 1
            c1 = c1+1;
        elseif score_temp(j,1) == 2
            c2 = c2+1;
        else
            c3 = c3+1;
        end
    end
    i=i+36;
    
    if c1>c2 && c1>c3
        score(index,2) = 1;
    elseif c2>c1 && c2>c3
        score(index,2) = 2;
    else
        score(index,2) = 3;
    end
    index = index+1;
    
    score(index,3) = c1/(c1+c2+c3);
    score(index,4) = c2/(c1+c2+c3);
    score(index,5) = c3/(c1+c2+c3);
end
    

% actual = zeros(3,size(score,1));
% target = zeros(3,size(score,1));
% 
% for i=1:size(score,1)
%     actual(score(i,1),i) = 1;
%     target(score(i,2),i) = 1;
% end
% plotconfusion(actual,target);
%ROC AND DET FOR PERCEPTRON------------------------------------------------

m=score;
tpr = zeros(size(m,1),3);
fpr = zeros(size(m,1),3);
fnr = zeros(size(m,1),3);

%classifying wrt g1
m = sortrows(m,3);

for th=1:size(m,1)
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    
    for q = 1:th
        if(m(q,1) == m(q,2) && (m(q,1)==1)) 
            fn=fn+1;
        else
            tn=tn+1;
        end
    end
    
    %these are positive cases
    for q = th+1:size(m,1)
        if(m(q,1) == m(q,2) && (m(q,1)==1))
            tp=tp+1;
        else
            fp=fp+1;
        end
    end
    
    tpr(th,1) = tp/(tp+fn);
    fpr(th,1) = fp/(fp+tn);
    fnr(th,1) = 1-tpr(th,1);%fn/(tp+fn)
end


%classifying wrt g2
m = sortrows(m,4);
for th=1:size(m,1)
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) == m(q,2))&&(m(q,2) == 2))
            fn=fn+1;
        else
            tn=tn+1;
        end
    end
    
    %these are positive cases
    for q = th:size(m,1)
        if((m(q,1) == m(q,2))&&(m(q,2) == 2))
            tp=tp+1;
        else
            fp=fp+1;
        end
    end
    
    tpr(th,2) = tp/(tp+fn);
    fpr(th,2) = fp/(fp+tn);
    fnr(th,2) = 1-tpr(th,2);%fn/(tp+fn)
end

%classifying wrt g3
m = sortrows(m,5);
for th=1:size(m,1)
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) == m(q,2))&&(m(q,2) == 3))
            fn=fn+1;
        else
            tn=tn+1;
        end
    end
    
    %these are positive cases
    for q = th:size(m,1)
        if((m(q,1) == m(q,2))&&(m(q,2) == 3))
            tp=tp+1;
        else
            fp=fp+1;
        end
    end
    
    tpr(th,3) = tp/(tp+fn);
    fpr(th,3) = fp/(fp+tn);
    fnr(th,3) = 1-tpr(th,3);%fn/(tp+fn);
end
x=mean(tpr,2);%mean tpr
y=mean(fpr,2);%mean fpr
z=mean(fnr,2);%mean fnr

plot(y,x,'Linewidth',2);
hold on;



%GENERATING THE TARGET AND NONTARGET VECTORS FOR DET-----------------------

l1=size(test_forest,1)/36;
l2=size(test_open,1)/36;
l3=size(test_tall,1)/36;
target = [m(1:l1,3);m(l1+2:l1+l2,4);m(l1+l2+1:l1+l2+l3-1,5) ];
nontarget = [m(1:l1,4);m(1:l1,5);m(l1+2:l1+l2,3);m(l1+2:l1+l2,5);m(l1+l2+1:l1+l2+l3-1,3);m(l1+l2+1:l1+l2+l3-1,4)];    

save('target.mat','target');
save('non_target.mat','nontarget');





    






