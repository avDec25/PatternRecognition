clc; clear; close all;

%% importing data
data = importdata('./data/q24_2.txt');
   x1 = data(:,1);
   x2 = data(:,2);
    y = data(:,3);

cftool