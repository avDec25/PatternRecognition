clear all;
close all;

%input data for class
path = 'data/isolated/24/1';
input1 = dir(fullfile(path));

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
train_row_numbers = [row_num1;row_num2;row_num3];
test_row_numbers = [test_row1;test_row2;test_row3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we need to classify each test file into a class;
% total 120 train files, there fore 120 dtw calculation for each train file

final_score = zeros(51,5);
test_count = 0;

for test_index = 1:51
    

dtw_test = [];              %this is the current training data matrix
n=test_row_numbers(test_index); %row number of testing matrix
%generating the testing matrix
for i=test_count + 1:test_count + n
    dtw_test = [dtw_test;final_test(i,:)];
end
test_count = test_count + n;
train_count  = 0;
temp_score = zeros(120,2);



%testing one  test data for all train data;-----------------------
for index = 1:120
    m=train_row_numbers(index);             %row number of training matrix
    dtw_train = [];                         %this is the current testing data matrix
    %generating the training matrix
    for i=train_count+1:train_count + m; 
        dtw_train = [dtw_train;final_train(i,:)];
    end
    %updating count after each run;
    train_count = train_count + m;
    dtw = zeros(n,m);                       %final dtw matrix
    %evaluating the base conditions
    dtw(1,1) = sqrt(sum((dtw_test(1,:) - dtw_train(1,:)).^2));
    for i=2:m
        dtw(1,i) = dtw(1,i-1) + sqrt(sum((dtw_test(1,:) - dtw_train(i,:)).^2));
    end
    for i=2:n
            dtw(i,1) = dtw(i-1,1) + sqrt(sum((dtw_test(i,:) - dtw_train(1,:)).^2));
    end
    %evaluating the recursive condition
    min = 0;
    for i=2:n
        for j=2:m

            g1 = dtw(i-1,j); 
            g2 = dtw(i-1,j-1);
            g3 = dtw(i,j-1);

            if(g1<=g2 && g1<=g3)
                min = g1;
            elseif(g2<=g1 && g2<=g3)
                min = g2;
            else(g3<=g2 && g3<=g1)
                min = g3;
            end

            dtw(i,j) = min + sqrt(sum((dtw_test(i,:) - dtw_train(j,:)).^2));
        end
    end
    %fillling up the temporary score matrix
    temp_score(index,1) = dtw(n,m);
    if index<=40
        temp_score(index,2) = 1;
    elseif index<=80
        temp_score(index,2) = 2;
    elseif index<=120
        temp_score(index,2) = 5;
    end
        
    
end

temp_score = sortrows(temp_score,1);

freq_mat = [];
for i=1:6
    freq_mat = [freq_mat; temp_score(i,2)]
end
[cl ff] = mode(freq_mat(:));
       
final_score(test_index,2) = cl;

if test_index<=17
    final_score(test_index,1) = 1;
elseif test_index<=34
    final_score(test_index,1) = 2;
else
    final_score(test_index,1) = 5;
end


min1=temp_score(120,1);
min2=temp_score(120,1);;
min5=temp_score(120,1);;

for i=1:120
    if temp_score(i,2) == 1
        if temp_score(i,1) < min1
            min1 = temp_score(i,1);
        end
    elseif temp_score(i,2) == 2
        if temp_score(i,1) < min2
            min2 = temp_score(i,1);
        end
    else
        if temp_score(i,1) < min5
            min5 = temp_score(i,1);
        end
    end
end

final_score(test_index,3) = min1;
final_score(test_index,4) = min2;
final_score(test_index,5) = min5;

end

target_matrix = zeros(3,51);
output_matrix = zeros(3,51);

for i=1:51
    x=final_score(i,1);
    y=final_score(i,2);
    
    if or(x==1,x==2)
        target_matrix(x,i) = 1;
    else
        target_matrix(3,i) = 1;
    end
    
    if or(y==1,y==2)
        output_matrix(y,i) = 1;
    else
        output_matrix(3,i) = 1;
    end
end
    
plotconfusion(target_matrix,output_matrix);

% storing the score matrix in dtw
fid = fopen( 'score_dtw.txt', 'wt' );
[x1 y1] = size(final_score);
for i = 1:x1
  for j = 1:y1
      a=final_score(i,j);
      if j==1|j==2
          fprintf( fid, '%d ', a);
      else
          fprintf( fid, '%f ', a);
      end
  end
  fprintf( fid, '\n');
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mm = importdata('score_dtw.txt');


f_numerator = 0;
f_dinominator = 0;

tpr = zeros(51,3);
fpr = zeros(51,3);
fnr = zeros(51,3);

%classifying wrt score 1
mm = sortrows(mm,3);

for th=1:51
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    
    for q = 1:th
        if(mm(q,1) == mm(q,2) && (mm(q,1)==1)) 
            fn=fn+1;
        else
            tn=tn+1
        end
    end
    
    %these are positive cases
    for q = th+1:51
        if(mm(q,1) == mm(q,2) && (mm(q,1)==1))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,1) = tp/(tp+fn);
    fpr(th,1) = fp/(fp+tn);
    fnr(th,1) = 1-tpr(th,1);%fn/(tp+fn)
end

f_numerator =f_numerator +  tp+tn;
f_dinominator = f_dinominator + tp+tn+fp+fn;

%classifying wrt score 2
mm = sortrows(mm,4);
for th=1:51
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((mm(q,1) == mm(q,2))&&(mm(q,2) == 2))
            fn=fn+1;
        else
            tn=tn+1;
        end
    end
    
    %these are positive cases
    for q = th:51
        if((mm(q,1) == mm(q,2))&&(mm(q,2) == 2))
            tp=tp+1;
        else
            fp=fp+1
        end
    end
    
    tpr(th,2) = tp/(tp+fn);
    fpr(th,2) = fp/(fp+tn);
    fnr(th,2) = 1-tpr(th,2);%fn/(tp+fn)
end

f_numerator =f_numerator +  tp+tn;
f_dinominator = f_dinominator + tp+tn+fp+fn;

%classifying wrt g3
mm = sortrows(mm,5);
for th=1:51
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((mm(q,1) == mm(q,2))&&(mm(q,2) == 5))
            fn=fn+1;
        else
            tn=tn+1;
        end
    end
    
    %these are positive cases
    for q = th:51
        if((mm(q,1) == mm(q,2))&&(mm(q,2) == 5))
            tp=tp+1;
        else
            fp=fp+1;
        end
    end
    
    tpr(th,3) = tp/(tp+fn);
    fpr(th,3) = fp/(fp+tn);
    fnr(th,3) = 1-tpr(th,3);%fn/(tp+fn);
end


f_numerator =f_numerator +  tp+tn;
f_dinominator = f_dinominator + tp+tn+fp+fn;

x=mean(tpr,2);%mean tpr
y=mean(fpr,2);%mean fpr
z=mean(fnr,2);%mean fnr

plot(x,y,'r');
hold on;


