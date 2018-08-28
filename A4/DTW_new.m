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

final_score = zeros(51,2);
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
    
    %first row
    for i=1:m
        dtw(1,i) = sqrt(sum((dtw_test(1,:) - dtw_train(i,:)).^2));
    end
    %first collumn
    for i=2:n
        dtw(i,1) = sqrt(sum((dtw_test(i,:) - dtw_train(1,:)).^2)) + dtw(i-1,1);
    end
    
    %evaluating the recursive condition
    
    for i=2:n
        for j=2:m
            %find minimum of earlier row, collumns 1-j
            min = dtw(i-1,1);
            for k=2:j
                if dtw(i-1,k)<min
                    min = dtw(i-1,k);
                end
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