clear; clc; close all; format longG;

load('data/ocr/test_features.mat');
predicted = importdata('libsvm/output');

n_a   = 2248;
n_chA = 2176;
n_tA  = 2311;

fileID = fopen('generated_Data/to_test_svm','w');
for i = 1 : n_a	
	fprintf(fileID, '1 0:%f 1:%f 2:%f 3:%f 4:%f\n', test(i,:));	
end

for j = 1 : n_chA
	% fprintf(fileID, '2 0:%f 1:%f 2:%f 3:%f 4:%f\n', test(i+j,:));
	fprintf(fileID, '%d 0:%f 1:%f 2:%f 3:%f 4:%f\n', predicted(i+j,:), test(i+j,:));
end

for k = 1 : n_tA
	fprintf(fileID, '3 0:%f 1:%f 2:%f 3:%f 4:%f\n', test(i+j+k,:));
end

fclose(fileID);


