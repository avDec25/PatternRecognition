clear; clc; close all; format longG;

load('data/isolated/test_rows.mat');

n_1 = size(c1_test,1);
n_2 = size(c2_test,1);
n_5 = size(c5_test,1);

fileID = fopen('generated_Data/to_test_svm','w');
for i = 1 : n_1
	fprintf(fileID, '1 0:%f 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f 37:%f\n', c1_test(i,:));
end

for j = 1 : n_2
	fprintf(fileID, '2 0:%f 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f 37:%f\n', c2_test(j,:));
end

for k = 1 : n_5
	fprintf(fileID, '3 0:%f 1:%f 2:%f 3:%f 4:%f 5:%f 6:%f 7:%f 8:%f 9:%f 10:%f 11:%f 12:%f 13:%f 14:%f 15:%f 16:%f 17:%f 18:%f 19:%f 20:%f 21:%f 22:%f 23:%f 24:%f 25:%f 26:%f 27:%f 28:%f 29:%f 30:%f 31:%f 32:%f 33:%f 34:%f 35:%f 36:%f 37:%f\n', c5_test(k,:));
end

fclose(fileID);


