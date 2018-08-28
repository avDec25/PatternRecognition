clear; clc; close all; format longG;

load('data/isolated/test_rows.mat');

n_1 = size(c1_test,1);
n_2 = size(c2_test,1);
n_5 = size(c5_test,1);

predicted = importdata('libsvm/output');

for i = 1 : n_1
	original(i,:) = 1;
end

for j = 1 : n_2
	original(i+j,:) = 2;
end

for k = 1 : n_5
	original(i+j+k,:) = 3;
end

[C,order] = confusionmat(original,predicted);

