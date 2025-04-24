%% Clean up
clear variables; close all; fclose all; echo off; clc;

%% Add path
addpath('data', 'FastMICE');

%% Import Data
[labels, data] = Import_MultilingualReutersDataset();
k = max(labels);

%% Linear normalization
data = mapminmax(data', 0, 1)';

%% K-means
[idx,C] = kmeans(data, k);

%% Evaluate performance
fourScores = computeFourClusteringMetrics(idx,labels);

disp('--------------------------------------------------------------'); 
disp(['NMI = ',num2str(fourScores(1))]);
disp(['ARI = ',num2str(fourScores(2))]);
disp(['ACC = ',num2str(fourScores(3))]);
disp(['PUR = ',num2str(fourScores(4))]);
disp('--------------------------------------------------------------');