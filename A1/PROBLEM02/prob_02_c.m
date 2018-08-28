%% Polynomial Regression on 2D data
 % Question 2(a)
clear; clc; close all;

%% importing data
data = importdata('./data/24_3.txt');
size(data)
   x1 = data(:,1);
   x2 = data(:,2);
   x3 = data(:,3);
   x4 = data(:,4);
   x5 = data(:,5);
   x6 = data(:,6);
   x7 = data(:,7);
   x8 = data(:,8);
    y = data(:,9);

    all_x = [x1 x2 x3 x4 x5 x6 x7 x8];
    
cftool