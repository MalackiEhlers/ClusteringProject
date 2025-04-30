%% Clean up
clear variables; close all; fclose all; echo off; clc;

%% Add path
addpath('data', 'FastMICE');

%% Import Data
[labels, data] = Import_BitcoinDataset();
K = max(labels);

%% Normalization
%data = mapminmax(data', 0, 1)';
data = zscore(data);

%% K-means
k = [2:5:K, K];
for j = 1:length(k)
    tic;
    [idx,C] = kmeans(data, k(j), 'MaxIter', 200);
    runtime(j) = toc;

    fourScores(j,:) = computeFourClusteringMetrics(idx,labels);
end

%% Plot performance metrics
figure;
plot(k,fourScores);
title('Bitcoin Heist K-Means Performance');
xlabel('k');
legend('NMI', 'ARI', 'ACC', 'PUR', Location='southeast');

figure;
plot(k,runtime);
title('Bitcoin Heist K-Means Runtime');
xlabel('k');
ylabel('Time (s)');

%% Display best performance metrics
runIdx = find(k==input('Select best k value:'));
disp('--------------------------------------------------------------'); 
disp('Bitcoin Heist K-Means');
disp(['K = ', num2str(k(runIdx))]);
disp(['Runtime = ', num2str(runtime(runIdx)), ' (s)']);
disp(['NMI = ',num2str(fourScores(runIdx,1))]);
disp(['ARI = ',num2str(fourScores(runIdx,2))]);
disp(['ACC = ',num2str(fourScores(runIdx,3))]);
disp(['PUR = ',num2str(fourScores(runIdx,4))]);
disp('--------------------------------------------------------------');