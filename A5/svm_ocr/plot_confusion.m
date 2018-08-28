clear; clc; close all; format longG;

n_a   = 2248;
n_chA = 2176;
n_tA  = 2311;

predicted = importdata('libsvm/output');

for i = 1 : n_a
	original(i,:) = 1;
end

for j = 1 : n_chA
	original(i+j,:) = 2;
end

for k = 1 : n_tA
	original(i+j+k,:) = 3;
end

[C,order] = confusionmat(original,predicted);

