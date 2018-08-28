clear all;
close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  now testing scores %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%input data for class
path = 'data/connected/test2/24';
input1 = dir(fullfile(path));

%for all test files
len = (length(input1)-2);
train1 = [];
row_num1 = [];
f_test = {};
for i=3:length(input1)
    nm = input1(i).name;
    p = fullfile(path,nm);
    f_test = vertcat(f_test,nm);
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
    end
end

train1(:,1) = [];%removing the first collumn from the matrix
%assigning cluster index to all the test points


c_mean = importdata('cluster_id.txt');
[m n] = size(train1);
[cluster points] = size(c_mean);
test_c_no = [];
for i=1:m
    a=train1(i,:);
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
fid = fopen( 'connected_test1.txt', 'wt' );
for i = 1:size(row_num1)
  for j=1:row_num1(i,1)
      a=test_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);




%{
str = sprintf('./test_hmm connected_test1.txt model11.hmm');
system(str);
scores = importdata('alphaout');
str = sprintf('./test_hmm connected_test1.txt model12.hmm');
system(str);
scores = [scores;importdata('alphaout')];
str = sprintf('./test_hmm connected_test1.txt model21.hmm');
system(str);
scores = [scores;importdata('alphaout')];
str = sprintf('./test_hmm connected_test1.txt model22.hmm');
system(str);
scores = [scores;importdata('alphaout')];
%}

%generating referance matrix to store templates
index_matrix = [];%stores index numbers for all combinations of 2 and 3 digit models
index = 1;
for i=1:3
    for j=1:3
        if i==3
            i1=5;
        else
            i1=i;
        end
        if j==3
            j1=5;
        else
            j1=j;
        end
        str = sprintf('%d%d', i1 , j1 );
        index_matrix = [index_matrix str2num(str)];
    end
end
for i=1:3
    for j=1:3
        for k=1:3
            if i==3
            i1=5;
        else
            i1=i;
        end
        if j==3
            j1=5;
        else
            j1=j;
        end
        if k==3
            k1=5;
        else
            k1=k;
        end
        str = sprintf('%d%d%d', i1 , j1 ,k1);
        index_matrix = [index_matrix str2num(str)];
    end
    end
end
scores = [];

%use this for dummy hmm

%calculating the scores

for i=1:3
    for j=1:3
        str = sprintf('./test_hmm connected_test1.txt model%d%d.txt.hmm', i , j );
        system(str);
        scores = [scores;importdata('alphaout')];
    end
end

for i=1:3
    for j=1:3
        for k=1:3
        str = sprintf('./test_hmm connected_test1.txt model%d%d%d.txt.hmm', i , j ,k );
        system(str);
        scores = [scores;importdata('alphaout')];
    end
end
end

scores = scores';


%use this for non  dummy hmm
%calculating the scores
%{
for i=1:3
    for j=1:3
        
        str = sprintf('./test_hmm connected_test1.txt nodummy_model%d%d.hmm', i , j );
        system(str);
        scores = [scores;importdata('alphaout')];
    end
end

for i=1:3
    for j=1:3
        for k=1:3
        str = sprintf('./test_hmm connected_test1.txt nodummy_model%d%d%d.hmm', i , j ,k );
        system(str);
        scores = [scores;importdata('alphaout')];
    end
end
end

scores = scores';
%}

predicted = [];
[x y] = size(scores);
for i=1:x
    A = scores(i,:);
    [M,I] = max(A);
    predicted = [predicted;index_matrix(I)];
end

