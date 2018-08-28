
close all;
clear all;

a=importdata('HandWritten_data/a-chA-tA/3.mat');
    ax = (a.xData)';
    ay = (a.yData)';
    plot(ax,ay,'k');
    
datax = [];datay = []; row_num1=[];
for i=1:3
    str = sprintf('HandWritten_data/a-chA-tA/%d.mat',i); 
    a=importdata(str);
    ax = (a.xData)';
    ay = (a.yData)';
    plot(ax,ay,'k');
    [n m] = size(ax);
    datax = [datax;ax];
    datay = [datay;ay];
    row_num1 = [row_num1;n];
end
    

%normalizing the data-----------------------------------------------------
datax(:) = datax(:)*10000;
datay(:) = datay(:)*10000;
datax(:) = (datax(:) - mean(datax(:)))/std(datax(:));
datay(:) = (datay(:) - mean(datay(:)))/std(datay(:));
datax(:) = datax(:)*10000;
datay(:) = datay(:)*10000;
% extracting features-----------------------------------------------------
feature1 = datax;
feature1(:) = (feature1(:) - mean(feature1(:)))/std(feature1(:));
feature2 = datay;
feature2(:) = (feature2(:) - mean(feature2(:)))/std(feature2(:));

[n m] = size(datax);
feature3 = [];
for i=1:n
    feature3 = [feature3;atan(datay(i)/datax(i))];
end

sigxy = 0;
for i=1:n
    sigxy = sigxy + (datax(i) - mean(datax(:)))^2;
    sigxy = sigxy + (datay(i) - mean(datay(:)))^2;
end
sigxy = sqrt(sigxy);

feature4 = (datax(:) - mean(datax))/sigxy;
feature5 = (datay(:) - mean(datay))/sigxy;

%final feature matrix, this is what counts from now on
train1 = [feature1 feature2 feature3 feature4 feature5];
%importing the cluster mean--------------------------------------------
c_mean = importdata('hand_cluster_means.txt');

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
fid = fopen( 'h_conn_test1.txt', 'wt' );
for i = 1:size(row_num1)
  for j=1:row_num1(i,1)
      a=test_c_no(index,1);
      fprintf( fid, '%d ', a);
      index = index+1;
  end
  fprintf( fid, '\n');
end
fclose(fid);

% generating the index matrix
index_matrix = [];%stores index numbers for all combinations of 2 and 3 digit models
index = 1;
for i=1:3
    for j=1:3
        for k=1:3
        str = sprintf('%d%d%d', i , j ,k);
        index_matrix = [index_matrix str2num(str)];
        end
    end
end

% storing the final scores after testing on different models------------------
scores = [];

for i=1:3
    for j=1:3
        for k=1:3
        str = sprintf('./test_hmm h_conn_test1.txt h_model%d%d%d.txt.hmm', i , j ,k );
        system(str);
        scores = [scores;importdata('alphaout')];
    end
end
end
scores = scores';

predicted = [];
[x y] = size(scores);
for i=1:x
    A = scores(i,:);
    [M,I] = max(A);
    predicted = [predicted;index_matrix(I)];
end
