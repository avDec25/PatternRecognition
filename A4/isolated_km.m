

%input data for class
path = 'data/isolated/24/1';
input1 = dir(fullfile(path));

cluster = 12;
states = 5;
seed = 1;
%for class 1
len = ceil((length(input1)-2)*0.7);
train1 = [];
row_num1 = [];
test1 = [];
test_row1 = [];

for i=3:length(input1)
    nm = input1(i).name;
    p = fullfile(path,nm);
    file1 = dlmread(p,' ',1,0);
    [r c] = size(file1);
    if i<= len+2    %training data
    
        if i==3
        train1 = file1;
        row_num1 = r;
        else
        train1 = [train1;file1];
        row_num1 = [row_num1;r];
        end
    else            %testing data
        if i== len+3 
        test1 = file1;
        test_row1 = r;
        else
        test1 = [test1;file1];
        test_row1 = [test_row1;r];
        end
    end
    
end
train1(:,1) = [];%removing the first collumn from the matrix
test1(:,1) = [];%removing the first collumn from the matrix


%for class 2
path = 'data/isolated/24/2';
input1 = dir(fullfile(path));
len = ceil((length(input1)-2)*0.7);
train2 = [];
row_num2 = [];
test2 = [];
test_row2 = [];

for i=3:length(input1)
    nm = input1(i).name;
    p = fullfile(path,nm);
    file1 = dlmread(p,' ',1,0);
    [r c] = size(file1);
    
    if i<=len+2     %training data
        if i==3
        train2 = file1;
        row_num2 = r;
        else
        train2 = [train2;file1];
        row_num2 = [row_num2;r];
        end
    else        %testing data
        if i== len+3 
        test2 = file1;
        test_row2 = r;
        else
        test2 = [test2;file1];
        test_row2 = [test_row2;r];
        end 
    end
            
end
train2(:,1) = [];%removing the first collumn from the matrix
test2(:,1) = [];%removing the first collumn from the matrix

%for class 5
path = 'data/isolated/24/5';
input1 = dir(fullfile(path));
len = ceil((length(input1)-2)*0.7);
train3 = [];
row_num3 = [];
test3 = [];
test_row3 = [];

for i=3:length(input1)
    nm = input1(i).name;
    p = fullfile(path,nm);
    file1 = dlmread(p,' ',1,0);
    [r c] = size(file1);
    
    if i<= len+2    % training data
        if i==3
        train3 = file1;
        row_num3 = r;
        else
        train3 = [train3;file1];
        row_num3 = [row_num3;r];
        end
    else            %testing data
        if i== len+3 
        test3 = file1;
        test_row3 = r;
        else
        test3 = [test3;file1];
        test_row3 = [test_row3;r];
        end 
    end
end
train3(:,1) = [];%removing the first collumn from the matrix
test3(:,1) = [];%removing the first collumn from the matrix

final_train = [train1;train2;train3];
final_test = [test1;test2;test3];

%running k-means on all training data
rng(seed);
[train_c_no c_mean] = kmeans(final_train,cluster);

fid = fopen('cluster_id.txt','wt');
[rr cc]  =size(c_mean);
for i = 1:rr
    for j=1:cc
    fprintf(fid,'%f ',c_mean(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);


%now c_no has the cluster indices of all training data, we need to segregate it

%segregating training data


index = 1;
fid = fopen( 'results_train1.txt', 'wt' );
for i = 1:size(row_num1)
  for j=1:row_num1(i,1)
      a=train_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);


fid = fopen( 'results_train2.txt', 'wt' );
for i = 1:size(row_num2)
  for j=1:row_num2(i,1)
      a=train_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);


fid = fopen( 'results_train3.txt', 'wt' );
for i = 1:size(row_num3)
  for j=1:row_num3(i,1)
      a=train_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);


%assigning cluster number to testing data

test_c_no = [];
for i=1:size(final_test)
    a=final_test(i,:);
    b=norm(a-c_mean(1,:));
    c=1;
    for j=2:cluster
        b1 = norm(a - c_mean(j,:))
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

%dividing them into files
index = 1;
%for the first class
fid = fopen( 'results_test1.txt', 'wt' );
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
fid = fopen( 'results_test2.txt', 'wt' );
for i = 1:size(test_row2)
  for j=1:test_row2(i,1)
      a=test_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);

%for the first class
fid = fopen( 'results_test3.txt', 'wt' );
for i = 1:size(test_row3)
  for j=1:test_row3(i,1)
      a=test_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now run script in terminal for generating scores in hmm files;

str = sprintf('./train_hmm results_train1.txt 1234 %d %d 0.01', states , cluster );
system(str);
str = sprintf('./train_hmm results_train2.txt 1234 %d %d 0.01', states , cluster );
system(str);
str = sprintf('./train_hmm results_train3.txt 1234 %d %d 0.01', states , cluster );
system(str);


%scores for test data in class 1
test1_all = [];
str = sprintf('./test_hmm results_test1.txt results_train1.txt.hmm');
system(str);
test1_all = importdata('alphaout');
str = sprintf('./test_hmm results_test1.txt results_train2.txt.hmm');
system(str);
test1_all = [test1_all;importdata('alphaout')];
str = sprintf('./test_hmm results_test1.txt results_train3.txt.hmm');
system(str);
test1_all = [test1_all;importdata('alphaout')];


%scores for test data in class 2
test2_all = [];
str = sprintf('./test_hmm results_test2.txt results_train1.txt.hmm');
system(str);
test2_all = importdata('alphaout');
str = sprintf('./test_hmm results_test2.txt results_train2.txt.hmm');
system(str);
test2_all = [test2_all;importdata('alphaout')];
str = sprintf('./test_hmm results_test2.txt results_train3.txt.hmm');
system(str);
test2_all = [test2_all;importdata('alphaout')];

%scores for test data in class 3
test3_all = [];
str = sprintf('./test_hmm results_test3.txt results_train1.txt.hmm');
system(str);
test3_all = importdata('alphaout');
str = sprintf('./test_hmm results_test3.txt results_train2.txt.hmm');
system(str);
test3_all = [test3_all;importdata('alphaout')];
str = sprintf('./test_hmm results_test3.txt results_train3.txt.hmm');
system(str);
test3_all = [test3_all;importdata('alphaout')];

% test1_all has scores of all model(1,2,3) for test data 1
% test2_all has scores of all model(1,2,3) for test date 2
% test2_all has scores of all model(1,2,3) for test data 3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a1=test1_all';
a2=test2_all';
a3=test3_all';


m = zeros(51,2);
%defining the score matrix
a_all = [a1;a2;a3]
m=[m a_all]

for i=1:51    
        if(i<=17)
        m(i,1) = 1;
        elseif(i<=34)
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

tpr = zeros(51,3);
fpr = zeros(51,3);
fnr = zeros(51,3);

%classifying wrt score 1
m = sortrows(m,3);

for th=1:51
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
    for q = th+1:51
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
for th=1:51
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
    for q = th:51
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
for th=1:8
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
    for q = th:51
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
%plot(y,x,'LineWidth',2);
%hold on;




%plotting confusion matrix

target = zeros(3,51);
output = zeros(3,51);

for i=1:51
    a=m(i,1);
    b=m(i,2);
    target(a,i) = 1;
    output(b,i) = 1;
end

plotconfusion(target,output);
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



