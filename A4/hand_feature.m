
cluster = 12;
states = 10;
seed = 1;

ax = importdata('HandWritten_data/DATA/FeaturesHW/a_x');
ay = importdata('HandWritten_data/DATA/FeaturesHW/a_y');
chax = importdata('HandWritten_data/DATA/FeaturesHW/chA_x');
chay = importdata('HandWritten_data/DATA/FeaturesHW/chA_y');
tax = importdata('HandWritten_data/DATA/FeaturesHW/tA_x');
tay = importdata('HandWritten_data/DATA/FeaturesHW/tA_y');
a_count = importdata('HandWritten_data/DATA/FeaturesHW/a_count');
cha_count = importdata('HandWritten_data/DATA/FeaturesHW/chA_count');
ta_count = importdata('HandWritten_data/DATA/FeaturesHW/tA_count');

%
[x y] = size(a_count);
train_len1 = ceil(x*0.7);
[x y] = size(cha_count);
train_len2 = ceil(x*0.7);
[x y] = size(ta_count);
train_len3 = ceil(x*0.7);

train_row1 = [];train_row2 = [];train_row3 = [];
test_row1 = [];test_row2 = [];test_row3 = [];
%finding the row count of all train and test classes
for i=1:size(a_count)
    if i<= train_len1
        train_row1 = [train_row1;a_count(i)];
    else
        test_row1 = [test_row1;a_count(i)];
    end
end

for i=1:size(cha_count)
    if i<= train_len2
        train_row2 = [train_row2;cha_count(i)];
    else
        test_row2 = [test_row2;cha_count(i)];
    end
end

for i=1:size(ta_count)
    if i<= train_len3
        train_row3 = [train_row3;ta_count(i)];
    else
        test_row3 = [test_row3;ta_count(i)];
    end
end

%taking all train and test data together for x and y coordinates-------------------

trainx = [];testx = [];
for i=1:sum(a_count(:))
    if i<= sum(a_count(1:train_len1))
        trainx = [trainx;ax(i)];
    else
        testx = [testx;ax(i)];
    end
end
for i=1:sum(cha_count(:))
    if i<= sum(cha_count(1:train_len2))
        trainx = [trainx;chax(i)];
    else
        testx = [testx;chax(i)];
    end
end
for i=1:sum(ta_count(:))
    if i<= sum(ta_count(1:train_len3))
        trainx = [trainx;tax(i)];
    else
        testx = [testx;tax(i)];
    end
end

%test and train data for y coordinates------------------------------------
trainy = [];testy = [];
for i=1:sum(a_count(:))
    if i<= sum(a_count(1:train_len1))
        trainy = [trainy;ax(i)];
    else
        testy = [testy;ax(i)];
    end
end
for i=1:sum(cha_count(:))
    if i<= sum(cha_count(1:train_len2))
        trainy = [trainy;chax(i)];
    else
        testy = [testy;chax(i)];
    end
end
for i=1:sum(ta_count(:))
    if i<= sum(ta_count(1:train_len3))
        trainy = [trainy;tax(i)];
    else
        testy = [testy;tax(i)];
    end
end



%scaling and normalising train and test data------------------------------
trainx(:) = trainx(:)*10000;
trainy(:) = trainy(:)*10000;
trainx(:) = (trainx(:) - mean(trainx(:)))/std(trainx(:));
trainy(:) = (trainy(:) - mean(trainy(:)))/std(trainy(:));
trainx(:) = trainx(:)*10000;
trainy(:) = trainy(:)*10000;

testx(:) = testx(:)*10000;
testy(:) = testy(:)*10000;
testx(:) = (testx(:) - mean(testx(:)))/std(testx(:));
testy(:) = (testy(:) - mean(testy(:)))/std(testy(:));
testx(:) = testx(:)*10000;
testy(:) = testy(:)*10000;


% extracting features-----------------------------------------------------
feature1 = trainx;
feature1(:) = (feature1(:) - mean(feature1(:)))/std(feature1(:));
feature2 = trainy;
feature2(:) = (feature2(:) - mean(feature2(:)))/std(feature2(:));

feature1_t = testx;
feature2_t = testy;
feature1_t(:) = (feature1_t(:) - mean(feature1_t(:)))/std(feature1_t(:));
feature2_t(:) = (feature2_t(:) - mean(feature2_t(:)))/std(feature2_t(:));

[n m] = size(trainx);
feature3 = [];
for i=1:n
    feature3 = [feature3;atan(trainy(i)/trainx(i))];
end

[n1 m] = size(testx);
feature3_t = [];
for i=1:n1
    feature3_t = [feature3_t;atan(testy(i)/testx(i))];
end

sigxy = 0;
for i=1:n
    sigxy = sigxy + (trainx(i) - mean(trainx(:)))^2;
    sigxy = sigxy + (trainy(i) - mean(trainy(:)))^2;
end
sigxy = sqrt(sigxy);

sigxy_t = 0;
for i=1:n1
    sigxy_t = sigxy_t + (testx(i) - mean(testx(:)))^2;
    sigxy_t = sigxy_t + (testy(i) - mean(testy(:)))^2;
end
sigxy_t = sqrt(sigxy_t);

feature4 = (trainx(:) - mean(trainx))/sigxy;
feature5 = (trainy(:) - mean(trainy))/sigxy;

feature4_t = (testx(:) - mean(testx))/sigxy;
feature5_t = (testy(:) - mean(testy))/sigxy_t;




%final feature matrix, this is what counts from now on
train = [feature1 feature2 feature3 feature4 feature5];
test = [feature1_t feature2_t feature3_t feature4_t feature5_t];
%k-means on training data

rng(seed);
[train_c_no cl_mean] = kmeans(train,cluster);

fid = fopen('hand_cluster_means.txt','wt');
[rr cc]  =size(cl_mean);
for i = 1:rr
    for j=1:cc
    fprintf(fid,'%f ',cl_mean(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);


%asigning cluster number to testing data---------------------------------
test_c_no = [];
for i=1:size(test)
    a=test(i,:);
    b=norm(a-cl_mean(1,:));
    c=1;
    for j=2:cluster
        b1 = norm(a - cl_mean(j,:))
        if b1<b
            c=j;
            b=b1;
        end
    end
    
    if i==0
        test_c_no = c;
    else
        test_c_no = [test_c_no;c];
    end
end


%segregating training data-----------------------------------------------

index = 1;
fid = fopen( 'h_train1.txt', 'wt' );
for i = 1:size(train_row1)
  for j=1:train_row1(i,1)
      a=train_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);

fid = fopen( 'h_train2.txt', 'wt' );
for i = 1:size(train_row2)
  for j=1:train_row2(i,1)
      a=train_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);

fid = fopen( 'h_train3.txt', 'wt' );
for i = 1:size(train_row3)
  for j=1:train_row3(i,1)
      a=train_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);

%segregating testing data------------------------------------------------
index = 1;
%for the first class
fid = fopen( 'h_test1.txt', 'wt' );
for i = 1:size(test_row1)
  for j=1:test_row1(i,1)
      a=test_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);

%for the second class
fid = fopen( 'h_test2.txt', 'wt' );
for i = 1:size(test_row2)
  for j=1:test_row2(i,1)
      a=test_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);

%for the third class
fid = fopen( 'h_test3.txt', 'wt' );
for i = 1:size(test_row3)
  for j=1:test_row3(i,1)
      a=test_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);

%training hmm for all train classes ------------------------------------
% now run script in terminal for generating scores in hmm files;

str = sprintf('./train_hmm h_train1.txt 1234 %d %d 0.01', states , cluster );
system(str);
str = sprintf('./train_hmm h_train2.txt 1234 %d %d 0.01', states , cluster );
system(str);
str = sprintf('./train_hmm h_train3.txt 1234 %d %d 0.01', states , cluster );
system(str);



%all three scores for test data in class 1
test1_all = [];
str = sprintf('./test_hmm h_test1.txt h_train1.txt.hmm');
system(str);
test1_all = importdata('alphaout');
str = sprintf('./test_hmm h_test1.txt h_train2.txt.hmm');
system(str);
test1_all = [test1_all;importdata('alphaout')];
str = sprintf('./test_hmm h_test1.txt h_train3.txt.hmm');
system(str);
test1_all = [test1_all;importdata('alphaout')];


%scores for test data in class 2
test2_all = [];
str = sprintf('./test_hmm h_test2.txt h_train1.txt.hmm');
system(str);
test2_all = importdata('alphaout');
str = sprintf('./test_hmm h_test2.txt h_train2.txt.hmm');
system(str);
test2_all = [test2_all;importdata('alphaout')];
str = sprintf('./test_hmm h_test2.txt h_train3.txt.hmm');
system(str);
test2_all = [test2_all;importdata('alphaout')];


%scores for test data in class 3
test3_all = [];
str = sprintf('./test_hmm h_test3.txt h_train1.txt.hmm');
system(str);
test3_all = importdata('alphaout');
str = sprintf('./test_hmm h_test3.txt h_train2.txt.hmm');
system(str);
test3_all = [test3_all;importdata('alphaout')];
str = sprintf('./test_hmm h_test3.txt h_train3.txt.hmm');
system(str);
test3_all = [test3_all;importdata('alphaout')];

% test1_all has scores of all model(1,2,3) for test data 1
% test2_all has scores of all model(1,2,3) for test date 2
% test2_all has scores of all model(1,2,3) for test data 3



%calculating score, roc and det -------------------------------------------

a1=test1_all'; %30 collumns
a2=test2_all';  %30 collumns
a3=test3_all';  %29 collumns

[x1 y1] = size(a1);
[x2 y2] = size(a2);
[x3 y3] = size(a3);
xx = x1+x2+x3;
m = zeros(x1+x2+x3,2);
%defining the score matrix
a_all = [a1;a2;a3]
m=[m a_all]

for i=1:x1+x2+x3    
        if(i<=x1)
        m(i,1) = 1;
        elseif(i<=x1+x2)
        m(i,1) = 2;
        else
        m(i,1) = 3;
        end
        
        g1 = m(i,3); 
        g2 = m(i,4);
        g3 = m(i,5);
        
        if(g1>=g2 && g1>=g3)
            m(i,2) = 1;
        elseif(g2>=g1 && g2>=g3)
            m(i,2) = 2;
        else(g3>=g2 && g3>=g1)
            m(i,2) = 3;
        end
        
end

%{
%normalizing the scores
norm_m = m;
for i=1:51
    s = norm_m(i,3)+norm_m(i,4)+norm_m(i,5);
    norm_m(i,3) = 1-(norm_m(i,3)/s);
    norm_m(i,4) = 1-(norm_m(i,4)/s);
    norm_m(i,5) = 1-(norm_m(i,5)/s);
    s = norm_m(i,3)+norm_m(i,4)+norm_m(i,5);
    norm_m(i,3) = (norm_m(i,3)/s);
    norm_m(i,4) = (norm_m(i,4)/s);
    norm_m(i,5) = (norm_m(i,5)/s);
end
m = norm_m;
%}

tpr = zeros(xx,3);
fpr = zeros(xx,3);
fnr = zeros(xx,3);

%classifying wrt score 1
m = sortrows(m,3);

for th=1:xx
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
    for q = th+1:xx
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


%classifying wrt score 2
m = sortrows(m,4);
for th=1:xx
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
    for q = th:xx
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
for th=1:xx
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
    for q = th:xx
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



%{
x=mean(tpr,2);%mean tpr
y=mean(fpr,2);%mean fpr
z=mean(fnr,2);%mean fnr
%}

x=(tpr(:,1) + tpr(:,2))/2;
y=(fpr(:,1) + fpr(:,2))/2;
z=(fnr(:,1) + fnr(:,2))/2


plot(y,x,'LineWidth',2);
hold on;



%plotting confusion matrix

target = zeros(3,51);
output = zeros(3,51);

for i=1:xx
    a=m(i,1);
    b=m(i,2);
    target(a,i) = 1;
    output(b,i) = 1;
end

%plotconfusion(target,output);
%plotroc(target,output);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen( 'score.txt', 'wt' );
[x1 y1] = size(m);
for i = 1:x1
  for j = 1:y1
      a=m(i,j);
      if j==1|j==2
          fprintf( fid, '%d ', a);
      else
          fprintf( fid, '%f ', a);
      end
  end
  fprintf( fid, '\n');
end
fclose(fid);

tar1 = [];
nnon1 = [];
m = importdata('score.txt');
[x y] = size(m);
index = 1;
for i=1:x
    if m(i,2) == 1
        tar1(1,i) = m(i,3);
        non1(1,index) = m(i,4);
        index = index + 1;
        non1(1,index) = m(i,5);
        index = index + 1;
    elseif m(i,2) == 2
        tar1(1,i) = m(i,4);
        non1(1,index) = m(i,3);
        index = index + 1;
        non1(1,index) = m(i,5);
        index = index + 1;
    else
        tar1(1,i) = m(i,5);
        non1(1,index) = m(i,3);
        index = index + 1;
        non1(1,index) = m(i,4);
        index = index + 1;
    end
end

DET_usage(tar1,non1);





