clear; clc; close all; format longG;

n_a   = importdata('data/ocr/n_a');
n_chA = importdata('data/ocr/n_chA');
n_tA  = importdata('data/ocr/n_tA');

x_a   = importdata('data/ocr/x_a');
x_chA = importdata('data/ocr/x_chA');
x_tA  = importdata('data/ocr/x_tA');

y_a   = importdata('data/ocr/y_a');
y_chA = importdata('data/ocr/y_chA');
y_tA  = importdata('data/ocr/y_tA');

save('all_data');

% digit_number = 5;
% plot(x_a(1:n_a(digit_number)), y_a(1:n_a(digit_number)), 'ko');

train_n_a       =  int16(0.7 * size(n_a,1));
train_n_coords  =  sum(n_a(1:train_n_a));
train_x_a       =  x_a(1:train_n_coords);
train_y_a       =  y_a(1:train_n_coords);
test_n_a        =  size(n_a,1) - int16(0.7 * size(n_a,1));
test_x_a        =  x_a(train_n_coords+1:size(x_a,1));
test_y_a        =  y_a(train_n_coords+1:size(y_a,1));


train_n_chA     =  int16(0.7 * size(n_chA,1));
train_n_coords  =  sum(n_chA(1:train_n_chA));
train_x_chA     =  x_chA(1:train_n_coords);
train_y_chA     =  y_chA(1:train_n_coords);
test_n_chA      =  size(n_chA,1) - int16(0.7 * size(n_chA,1));
test_x_chA      =  x_chA(train_n_coords+1:size(x_chA,1));
test_y_chA      =  y_chA(train_n_coords+1:size(y_chA,1));


train_n_tA      =  int16(0.7 * size(n_tA,1));
train_n_coords  =  sum(n_tA(1:train_n_tA));
train_x_tA      =  x_tA(1:train_n_coords);
train_y_tA      =  y_tA(1:train_n_coords);
test_n_tA       =  size(n_tA,1) - int16(0.7 * size(n_tA,1));
test_x_tA       =  x_tA(train_n_coords+1:size(x_tA,1));
test_y_tA       =  y_tA(train_n_coords+1:size(y_tA,1));


save('train_data', ...
	'train_n_a',   'train_x_a',   'train_y_a', ...
	'train_n_chA', 'train_x_chA', 'train_y_chA', ...
	'train_n_tA',  'train_x_tA',  'train_y_tA' );

save('test_data', ...
	'test_n_a',   'test_x_a',   'test_y_a', ...
	'test_n_chA', 'test_x_chA', 'test_y_chA', ...
	'test_n_tA',  'test_x_tA',  'test_y_tA' );

