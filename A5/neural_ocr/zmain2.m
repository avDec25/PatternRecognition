clear; clc; close all; format longG;

load('data/all_data.mat');

all_x = [x_a; x_chA; x_tA];
all_y = [y_a; y_chA; y_tA];

all_data = [all_x all_y];
for i = 1 : size(all_data)
	feature1(i,:) = atan(all_y(i) / all_x(i));
end

training_data = [all_data feature1];
training_data = training_data';

target = zeros(3, size(all_data,1));

for i = 1 : n_a
	target(1,i) = 1;
end

for j = 1 : n_chA
	target(2,i+j) = 1;
end

for k = 1 : n_tA
	target(3,i+j+k) = 1;
end

nnstart
