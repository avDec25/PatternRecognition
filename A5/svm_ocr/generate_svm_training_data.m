clear; clc; close all; format longG;

load('data/ocr/train_features.mat');

n_label_a   = 5450;
n_label_chA = 5326;
n_label_tA  = 6039;

fileID = fopen('generated_Data/to_train_svm','w');
for i = 1 : n_label_a
	fprintf(fileID, '1 0:%f 1:%f 2:%f 3:%f 4:%f\n', train(i,:));
end

for j = 1 : n_label_chA
	fprintf(fileID, '2 0:%f 1:%f 2:%f 3:%f 4:%f\n', train(i+j,:));
end

for k = 1 : n_label_tA
	fprintf(fileID, '3 0:%f 1:%f 2:%f 3:%f 4:%f\n', train(i+j+k,:));
end

fclose(fileID);


