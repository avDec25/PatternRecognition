clear; clc; close all; format longG;

load('data/train_features.mat');

n_label_a   = 5450;
n_label_chA = 5326;
n_label_tA  = 6039;

train_data = train';

target = zeros(3, n_label_a + n_label_chA + n_label_tA);

for i = 1 : n_label_a
	target(1,i) = 1;
end

for j = 1 : n_label_chA
	target(2,i+j) = 1;
end

for k = 1 : n_label_tA
	target(3,i+j+k) = 1;
end

