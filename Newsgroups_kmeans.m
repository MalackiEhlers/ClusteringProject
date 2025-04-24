%% Clean up
clear variables; close all; fclose all; echo off; clc;

%% Add path
addpath('data', 'FastMICE');

%% Import Data
[labels, data] = Import_NewsgroupsDataset();
K = max(labels);

%% Linear normalization
%data = mapminmax(data', 0, 1)';

%% ISOMAP
D = squareform(pdist(data, 'euclidean'));
opts = struct();
opts.dims = 20:400;
opts.display = 1;
opts.verbose = 0;
[Y, R, E] = IsoMap(D, 'k', 10, opts);
d = length(Y.coords);
embedding = Y.coords{d}';

%% K-Means
for k = 2:K
    % On raw data
    tic;
    [idx,C] = kmeans(data, k);
    runtime(1,k) = toc;
    fourScoresRaw(k,:) = computeFourClusteringMetrics(idx,labels);

    % On transformed data
    tic;
    [idx,C] = kmeans(embedding, k);
    fourScoresISOMAP(k,:) = computeFourClusteringMetrics(idx,labels);
    runtime(2,k) = toc;
end

%% Plot performance metrics
figure;
subplot(2,1,1);
plot(1:K,fourScoresRaw);
title('Performance Metrics (Raw)');
xlabel('k');
legend('NMI', 'ARI', 'ACC', 'PUR', Location='southeast');

subplot(2,1,2);
plot(1:K,fourScoresISOMAP);
title('Performance Metrics (ISOMAP)');
xlabel('k');
legend('NMI', 'ARI', 'ACC', 'PUR', Location='southeast');