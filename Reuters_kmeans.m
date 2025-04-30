%% Clean up
clear variables; close all; fclose all; echo off; clc;

%% Add path
addpath('data', 'FastMICE');

%% Import Data
[labels, data] = Import_MultilingualReutersDataset();
K = max(labels);

%% Linear normalization
data = mapminmax(data', 0, 1)';

%% K-means
for k = 2:K
    tic;
    [idx,C] = kmeans(data, k);
    runtime(k) = toc;

    fourScores(k,:) = computeFourClusteringMetrics(idx,labels);
    s = silhouette(data, idx);
    s_score(k) = mean(s);
end

%% Plot performance metrics
figure;
plot(1:K,fourScores);
title('Reuters K-Means Performance');
xlabel('k');
legend('NMI', 'ARI', 'ACC', 'PUR', Location='southeast');

figure;
plot(1:K, s_score);
title('Reuters K-Means Silhouette Score');
xlabel('k');

figure;
plot(1:K,runtime);
title('Reuters K-Means Runtime');
xlabel('k');
ylabel('Time (s)');

%% Display best performance metrics
runIdx = input('Select best k value:');
disp('--------------------------------------------------------------'); 
disp('Reuters K-Means');
disp(['K = ', num2str(runIdx)]);
disp(['Runtime = ', num2str(runtime(runIdx)), ' (s)']);
disp(['NMI = ',num2str(fourScores(runIdx,1))]);
disp(['ARI = ',num2str(fourScores(runIdx,2))]);
disp(['ACC = ',num2str(fourScores(runIdx,3))]);
disp(['PUR = ',num2str(fourScores(runIdx,4))]);
disp('--------------------------------------------------------------');