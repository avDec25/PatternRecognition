clear; clc; close all; format longG;

%%%%%%%%%%%%%%%%%%%%% Separate Data as Training and Test %%%%%%%%%%%%%%%%%%%%%
load('data/isolated/all_rows');

n_c1_train = int16(0.7 * size(c1_data,1));
c1_train   = c1_data(1:n_c1_train,:);
c1_test    = c1_data(1+n_c1_train: size(c1_data,1),:);

n_c2_train = int16(0.7 * size(c2_data,1));
c2_train   = c2_data(1:n_c2_train,:);
c2_test    = c2_data(1+n_c2_train: size(c2_data,1),:);

n_c5_train = int16(0.7 * size(c5_data,1));
c5_train   = c5_data(1:n_c5_train,:);
c5_test    = c5_data(1+n_c5_train: size(c5_data,1),:);

save('data/isolated/test_rows', 'c1_test', 'c2_test', 'c5_test');
save('data/isolated/train_rows', 'c1_train', 'c2_train', 'c5_train');

