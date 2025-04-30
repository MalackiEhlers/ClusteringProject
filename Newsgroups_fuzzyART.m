%% Clean up
clear variables; close all; fclose all; echo off; clc;

%% Add path
addpath('data', 'FastMICE', 'functions', 'classes');

%% Import Data
[labels, data] = Import_NewsgroupsDataset();

%% ISOMAP
D = squareform(pdist(data, 'euclidean'));
opts = struct();
opts.dims = 20:350;
opts.display = 1;
opts.verbose = 0;
[Y, R, E] = IsoMap(D, 'k', 10, opts);
d = length(Y.coords);
embedding = Y.coords{d}';

%% Linear normalization
data = mapminmax(data', 0, 1)';
embedding = mapminmax(embedding', 0, 1)';

%% Fuzzy ART
rho = 0.30:0.05:0.80;
for r = 1:length(rho)
    % ART Parameter settings
    settings = struct();
    settings.rho = rho(r);
    settings.alpha = 1e-3;
    settings.beta = 1;
    settings.display = 1;
    nEpochs = 2;

    % Train on raw data
    FA = FuzzyART(settings);
    tic;
    FA = FA.train(data, nEpochs);
    runtime(1,r) = toc;
    fourScoresRaw(r,:) = computeFourClusteringMetrics(FA.labels, labels);
    s = silhouette(data, FA.labels);
    s_score(1,r) = mean(s);

    % Train on ISOMAP data
    FA = FuzzyART(settings);
    tic;
    FA = FA.train(embedding, nEpochs);
    runtime(2,r) = toc;
    fourScoresISOMAP(r,:) = computeFourClusteringMetrics(FA.labels, labels);
    s = silhouette(data, FA.labels);
    s_score(2,r) = mean(s);
end

%% Plot performance metrics
figure;
subplot(2,1,1);
plot(rho,fourScoresRaw);
title('Newsgroups Fuzzy ART Performance (Raw)');
xlabel('rho');
legend('NMI', 'ARI', 'ACC', 'PUR', Location='southeast');

subplot(2,1,2);
plot(rho,fourScoresISOMAP);
title('Newsgroups Fuzzy ART Performance (ISOMAP)');
xlabel('rho');
legend('NMI', 'ARI', 'ACC', 'PUR', Location='southeast');

figure;
subplot(2,1,1);
plot(rho, s_score(1,:));
title('Newsgroups Fuzzy ART Silhouette Score (Raw)');
xlabel('rho');

subplot(2,1,2);
plot(rho, s_score(2,:));
title('Newsgroups Fuzzy ART Silhouette Score (ISOMAP)');
xlabel('rho');

figure;
subplot(2,1,1);
plot(rho, runtime(1,:));
title('Newsgroups Fuzzy ART Runtime (Raw)');
xlabel('rho');
ylabel('Time (s)');

subplot(2,1,2);
plot(rho, runtime(2,:));
title('Newsgroups Fuzzy ART Runtime (ISOMAP)');
xlabel('rho');
ylabel('Time (s)');


%% Display best performance metrics
runIdx = find(rho==input('Select best rho value:'));
disp('--------------------------------------------------------------'); 
disp('Newsgroups Fuzzy ART (Raw)');
disp(['Rho = ', num2str(rho(runIdx))]);
disp(['Runtime = ', num2str(runtime(1,runIdx)), ' (s)']);
disp(['NMI = ',num2str(fourScoresRaw(runIdx,1))]);
disp(['ARI = ',num2str(fourScoresRaw(runIdx,2))]);
disp(['ACC = ',num2str(fourScoresRaw(runIdx,3))]);
disp(['PUR = ',num2str(fourScoresRaw(runIdx,4))]);
disp('--------------------------------------------------------------');
disp('Newsgroups Fuzzy ART (ISOMAP)');
disp(['Rho = ', num2str(rho(runIdx))]);
disp(['Runtime = ', num2str(runtime(2,runIdx)), ' (s)']);
disp(['NMI = ',num2str(fourScoresISOMAP(runIdx,1))]);
disp(['ARI = ',num2str(fourScoresISOMAP(runIdx,2))]);
disp(['ACC = ',num2str(fourScoresISOMAP(runIdx,3))]);
disp(['PUR = ',num2str(fourScoresISOMAP(runIdx,4))]);
disp('--------------------------------------------------------------');