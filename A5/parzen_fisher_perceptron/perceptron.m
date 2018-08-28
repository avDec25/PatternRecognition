clear all;
close all;

curve=[0.1 0.01 0.001 0.0001];

for repeat = 1:4
iterations = 300;
enough_count=25;
rate = curve(1,repeat);


forest = importdata('forest.mat');
open = importdata('open.mat');
tall = importdata('tall.mat');
%appending 1 at the end of all data points
temp = zeros(size(forest,1),1)+1;
forest = [forest temp];
temp = zeros(size(open,1),1)+1;
open = [open temp];
temp = zeros(size(tall,1),1)+1;
tall = [tall temp];

%training and testing data
limit = floor(0.7*(size(forest,1)/36));
train_f = forest(1:limit*36,:);
test_f = forest(limit*36+1:size(forest,1),:);

limit = floor(0.7*(size(open,1)/36));
train_o = open(1:limit*36,:);
test_o = open(limit*36+1:size(open,1),:);

limit = floor(0.7*(size(tall,1)/36));
train_t = tall(1:limit*36,:);
test_t = tall(limit*36+1:size(tall,1),:);



%perceptron for forest vs all;---------------------------------------------
a1 = zeros(1,size(forest,2))+1;
target = [train_f;-train_o;-train_t];

for k=1:iterations
i=1;
while i<=size(target,1)
    count = 0;
    for j=i:i+35
        if (a1*(target(j,:)'))>0
            count = count +1;
        end
    end
    %if not enough
    if count<enough_count
       for j=i:i+35
            a1=a1+rate*target(j,:);
       end
    end 
    i=i+36;
end
end

%perceptron for opencountry vs all-----------------------------------------
a2 = zeros(1,size(open,2))+1;
target = [train_o;-train_t;-train_f];

for k=1:iterations
i=1;
while i<=size(target,1)
    count = 0;
    for j=i:i+35
        if (a2*(target(j,:)'))>0
            count = count +1;
        end
    end
    %if not enough
    if count<enough_count
       for j=i:i+35
            a2=a2+rate*target(j,:);
       end
    end 
    i=i+36;
end
end

%perceptron for tallbuilding vs all;---------------------------------------
a3 = zeros(1,size(tall,2))+1;
target = [train_t;-train_o;-train_f];

for k=1:iterations
i=1;
while i<=size(target,1)
    count = 0;
    for j=i:i+35
        if (a3*(target(j,:)'))>0
            count = count +1;
        end
    end
    %if not enough
    if count<enough_count
       for j=i:i+35
            a3=a3+rate*target(j,:);
       end
    end 
    i=i+36;
end
end

%TESTING FOR ALL CLASSES -------------------------------------------------------------------

scoref=0;scoreo=0;scoret=0;
test = [test_f;test_o;test_t];
m=zeros(size(test,1)/36,5);

i=1;
index = 1;
while i<=size(test,1)
    scoref=0;scoreo=0;scoret=0;
    for j=i:i+35
    %     scoref = scoref + a1*test_f(i,:)';
    %     scoreo = scoreo + a2*test_f(i,:)';
    %     scoret = scoret + a3*test_f(i,:)';
        if a1*test(j,:)'>0
            scoref = scoref + 1;
        end
        if a2*test(j,:)'>0
            scoreo = scoreo + 1;
        end
        if a3*test(j,:)'>0
            scoret = scoret + 1;
        end
    end
    
    m(index,3) = scoref/(scoref+scoreo+scoret);
    m(index,4) = scoreo/(scoref+scoreo+scoret);
    m(index,5) = scoret/(scoref+scoreo+scoret);
    
    i=i+36;
    if scoref>=scoreo && scoref>=scoret
        m(index,2) = 1;
    elseif scoreo>=scoref && scoreo>=scoret
        m(index,2) = 2;
    else
        m(index,2) = 3;
    end
    if index<=size(test_f,1)/36
        m(index,1) = 1;
    elseif index<=size(test_f,1)/36+size(test_o,1)/36
        m(index,1) = 2;
    else
        m(index,1) = 3;
    end
    
    index = index + 1;
end

actual = zeros(3,size(m,1));
target = zeros(3,size(m,1));
for i=1:size(m,1)
    actual(m(i,1),i) = 1;
    target(m(i,2),i) = 1;
end

% figure(repeat);
% plotconfusion(actual,target);
% str = sprintf('iteration %d',repeat);
% title(str);    



%ROC AND DET FOR PERCEPTRON------------------------------------------------

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

end

%GENERATING THE TARGET AND NONTARGET VECTORS FOR DET-----------------------

l1=size(test_f,1)/36;
l2=size(test_o,1)/36;
l3=size(test_t,1)/36;
target = [m(1:l1,3);m(l1+2:l1+l2,4);m(l1+l2+1:l1+l2+l3-1,5) ];
nontarget = [m(1:l1,4);m(1:l1,5);m(l1+2:l1+l2,3);m(l1+2:l1+l2,5);m(l1+l2+1:l1+l2+l3-1,3);m(l1+l2+1:l1+l2+l3-1,4)];    

save('target.mat','target');
save('non_target.mat','nontarget');



