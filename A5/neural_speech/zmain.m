clear; clc; close all; format longG;

load('data/all_data_rows');

n_1 = size(c1_data,1);
n_2 = size(c2_data,1);
n_5 = size(c5_data,1);

training_data = [c1_data; c2_data; c5_data];
training_data = training_data';

target = zeros(3, n_1 + n_2 + n_5);

for i = 1 : n_1
	target(1,i) = 1;
end

for j = 1 : n_2
	target(2,i+j) = 1;
end

for k = 1 : n_5
	target(3,i+j+k) = 1;
end

clearvars -except training_data target

nnstart

