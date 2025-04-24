%% Clean up
clear variables; close all; fclose all; echo off; clc;

%% Add path
addpath('data', 'FastMICE');

%% Import Data
[labels, data] = Import_BitcoinDataset();
k = max(labels);

%% Normalization
%data = mapminmax(data', 0, 1)';
data = zscore(data);

%% K-means
tic;
[idx,C] = kmeans(data, k);
runtime = toc;
disp(['Runtime: ', num2str(runtime), ' (s)']);

%% Evaluate performance
fourScores = computeFourClusteringMetrics(idx,labels);

disp('--------------------------------------------------------------'); 
disp(['NMI = ',num2str(fourScores(1))]);
disp(['ARI = ',num2str(fourScores(2))]);
disp(['ACC = ',num2str(fourScores(3))]);
disp(['PUR = ',num2str(fourScores(4))]);
disp('--------------------------------------------------------------');