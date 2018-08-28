clear all;
close all;


forest=dir('data/forest/*.jpg_color_edh_entropy');
open=dir('data/opencountry/*.jpg_color_edh_entropy');
tall=dir('data/tallbuilding/*.jpg_color_edh_entropy');
x1=size(forest,1);x2=size(open,1);x3=size(tall,1);
t2 = importdata('test_projected.mat');
t1 = importdata('train_projected.mat');
%{
a = [];
for i=1:size(forest,1)
    a = [a;importdata(['data/forest/' forest(i).name])];
end
save('forest.mat','a'); a = [];
for i=1:size(open,1)
    a = [a;importdata(['data/opencountry/' open(i).name])];
end
save('open.mat','a');a = [];
for i=1:size(tall,1)
    a = [a;importdata(['data/tallbuilding/' tall(i).name])];
end
save('tall.mat','a');
%}


h=0.08;d=23;
forest = importdata('forest.mat');
open = importdata('open.mat');
tall = importdata('tall.mat');


% %%normalising the data
% for i=1:size(forest,1)
%     forest(i,:) =(forest(i,:) - mean(forest))/std(std(forest));
% end
% for i=1:size(open,1)
%     open(i,:) =(open(i,:) - mean(open))/std(std(open));
% end
% for i=1:size(tall,1)
%     tall(i,:) =(tall(i,:) - mean(tall))/std(std(tall));
% end



train_forest = forest(1:floor(0.7*x1)*36,:);
test_forest = forest(floor(0.7*x1)*36+1:x1*36,:);

train_open = open(1:floor(0.7*x2)*36,:);
test_open = open(floor(0.7*x2)*36+1:x2*36,:);
train_tall = tall(1:floor(0.7*x3)*36,:);
test_tall = tall(floor(0.7*x3)*36+1:x3*36,:);

test = [test_forest;test_open;test_tall];
test_rownum = [x1-floor(0.7*x1);x2-floor(0.7*x2);x3-floor(0.7*x3)];


score = zeros(sum(test_rownum),2);
for i=1:size(score,1)
    if i<=test_rownum(1)
        score(i,1) = 1;
    elseif i<=test_rownum(2)+test_rownum(1)
        score(i,1) = 2;
    else
        score(i,1) = 3;
    end
end

index = 1;

i=1;
while i<=size(test,1)
    g1=0;g2=0;g3=0;
    x=test(i:i+35,:);i=i+36;
    %obtaining global score for class 1
    j=1;
    while j<=size(train_forest,1)
        xi = train_forest(j:j+35,:);j=j+36;
        temp = 0;
        for k=1:36
         temp = temp + (h*sqrt(2*pi))^(-d)*exp(-0.5*( ( (x(k)-xi(k)) * (x(k)-xi(k))' )/(2*h*h)));   
        end
        g1 = g1 + temp/36;
    end
    g1 = g1/(x1 - test_rownum(1));
    
    %obtaining global score for class 2
    j=1;
    while j<=size(train_open,1)
        xi = train_open(j:j+35,:);j=j+36;
        temp = 0;
        for k=1:36
         temp = temp + (h*sqrt(2*pi))^(-d)*exp(-0.5*( ( (x(k)-xi(k)) * (x(k)-xi(k))' )/(2*h*h)));   
        end
        g2 = g2 + temp/36;
    end
    g2 = g2/(x2 - test_rownum(2));
    
    %obtaining global score for class 3
    j=1;
    while j<=size(train_tall,1)
        xi = train_tall(j:j+35,:);j=j+36;
        temp = 0;
        for k=1:36
         temp = temp + (h*sqrt(2*pi))^(-d)*exp(-0.5*( ( (x(k)-xi(k)) * (x(k)-xi(k))' )/(2*h*h)));   
        end
        g3 = g3 + temp/36;
    end
    g3 = g3/(x3 - test_rownum(3));
    
    score(index,2) = g1;
    score(index,3) = g2;
    score(index,4) = g3;
    if g1>g2 && g1>g3
        score(index,5) = 1;
    elseif g2>g1 && g2>g3
        score(index,5) = 2;
    else
        score(index,5) = 3;
    end
    index = index +1;
end

actual = zeros(3,size(score,1));
target = zeros(3,size(score,1));

for i=1:size(score,1)
    actual(score(i,1),i) = 1;
    target(score(i,5),i) = 1;
end

% figure;
% plotconfusion(actual,target);


%ROC PLOT for PARZEN-------------------------------------------------------

m=[score(:,1) score(:,5) score(:,2) score(:,3) score(:,4)];
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
target = [score(1:l1,2);score(l1+2:l1+l2,3);score(l1+l2+1:l1+l2+l3,4) ];
nontarget = [score(1:l1,3);score(1:l1,4);score(l1+2:l1+l2,2);score(l1+2:l1+l2,4);score(l1+l2+1:l1+l2+l3,2);score(l1+l2+1:l1+l2+l3,3)]    

save('target.mat','target');
save('non_target.mat','nontarget');



