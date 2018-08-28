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
test_row_numbers = [test_row1;test_row2;test_num3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we need to classify each test file into a class;
% total 120 train files, there fore 120 dtw calculation for each train file



dtw_test = [];              %this is the current training data matrix
n=test_row_numbers(1); %row number of testing matrix
%generating the testing matrix
for i=1:n
    dtw_test = [dtw_test;final_test(i,:)];
end
count  = 0;
temp_score = zeros(120,2);

%testing one  test data for all train data;-----------------------
for index = 1:120
    m=train_row_numbers(index);             %row number of training matrix
    dtw_train = [];                         %this is the current testing data matrix
    %generating the training matrix
    for i=count+1:count + m; 
        dtw_train = [dtw_train;final_train(i,:)];
    end
    %updating count after each run;
    count = count + m;
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
    freq_mat = [freq_mat;
        




