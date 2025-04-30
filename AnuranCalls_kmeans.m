%% Clean up
clear variables; close all; fclose all; echo off; clc;

%% Add path
addpath('data', 'FastMICE');

%% Import data
[labels, data] = Import_AnuranCallsDataset();
K = max(labels);

%% Linear normalization
data = mapminmax(data', 0, 1)';

%% K-means
for k = 2:K
    tic;
    [idx,C] = kmeans(data, k);
    runtime(k) = toc;

    fourScores(k,:) = computeFourClusteringMetrics(idx,labels);
end

%% Plot performance metrics
figure;
plot(1:K,fourScores);
title('Performance Metrics');
xlabel('k');
legend('NMI', 'ARI', 'ACC', 'PUR', Location='southeast');