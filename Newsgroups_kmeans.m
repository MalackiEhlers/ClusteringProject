%% Clean up
clear variables; close all; fclose all; echo off; clc;

%% Add path
addpath('data', 'FastMICE', 'functions');

%% Import Data
[labels, data] = Import_NewsgroupsDataset();
K = max(labels);

%% Linear normalization
%data = mapminmax(data', 0, 1)';

%% ISOMAP
D = squareform(pdist(data, 'euclidean'));
opts = struct();
opts.dims = 10:20;
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
    s = silhouette(data, idx);
    s_score(1,k) = mean(s);

    % On transformed data
    tic;
    [idx,C] = kmeans(embedding, k);
    fourScoresISOMAP(k,:) = computeFourClusteringMetrics(idx,labels);
    runtime(2,k) = toc;
    s = silhouette(data, idx);
    s_score(2,k) = mean(s);
end

%% Plot performance metrics
figure;
subplot(2,1,1);
plot(1:K,fourScoresRaw);
title('Newsgroups K-Means Performance (Raw)');
xlabel('k');
legend('NMI', 'ARI', 'ACC', 'PUR', Location='southeast');

subplot(2,1,2);
plot(1:K,fourScoresISOMAP);
title('Newsgroups K-Means Performance (ISOMAP)');
xlabel('k');
legend('NMI', 'ARI', 'ACC', 'PUR', Location='southeast');

figure;
subplot(2,1,1);
plot(1:K, s_score(1,:));
title('Newsgroups K-Means Silhouette Score (Raw)');
xlabel('k');

subplot(2,1,2);
plot(1:K, s_score(2,:));
title('Newsgroups K-Means Silhouette Score (ISOMAP)');
xlabel('k');

figure;
subplot(2,1,1);
plot(1:K, runtime(1,:));
title('Newsgroups K-Means Runtime (Raw)');
xlabel('k');
ylabel('Time (s)');

subplot(2,1,2);
plot(1:K, runtime(2,:));
title('Newsgroups K-Means Runtime (ISOMAP)');
xlabel('k');
ylabel('Time (s)');

%% Display best performance metrics
runIdx = input('Select best k value:');
disp('--------------------------------------------------------------'); 
disp('Newsgroups K-Means (Raw)');
disp(['K = ', num2str(runIdx)]);
disp(['Runtime = ', num2str(runtime(1,runIdx)), ' (s)']);
disp(['NMI = ',num2str(fourScoresRaw(runIdx,1))]);
disp(['ARI = ',num2str(fourScoresRaw(runIdx,2))]);
disp(['ACC = ',num2str(fourScoresRaw(runIdx,3))]);
disp(['PUR = ',num2str(fourScoresRaw(runIdx,4))]);
disp('--------------------------------------------------------------');
disp('Newsgroups K-Means (ISOMAP)');
disp(['K = ', num2str(runIdx)]);
disp(['Runtime = ', num2str(runtime(2,runIdx)), ' (s)']);
disp(['NMI = ',num2str(fourScoresISOMAP(runIdx,1))]);
disp(['ARI = ',num2str(fourScoresISOMAP(runIdx,2))]);
disp(['ACC = ',num2str(fourScoresISOMAP(runIdx,3))]);
disp(['PUR = ',num2str(fourScoresISOMAP(runIdx,4))]);
disp('--------------------------------------------------------------');