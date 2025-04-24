%% Clean up
clear variables; close all; fclose all; echo off; clc;

%% Add path
addpath('data', 'FastMICE', 'classes');

%% Import data
[labels, data] = Import_AnuranCallsDataset();
K = max(labels);

%% Linear normalization
data = mapminmax(data', 0, 1)';

%% Fuzzy ART
rho = 0.20:0.05:0.70;
for r = 1:length(rho)
    % ART Parameter settings
    settings = struct();
    settings.rho = rho(r);
    settings.alpha = 1e-3;
    settings.beta = 1;
    settings.display = 0;
    nEpochs = 2;
    FA = FuzzyART(settings);

    % Train
    tic;
    FA = FA.train(data, nEpochs);
    runtime(r) = toc;

    % Performance metrics
    fourScores(r,:) = computeFourClusteringMetrics(FA.labels, labels);
end

%% Plot performance metrics
figure;
plot(rho',fourScores);
title('Performance Metrics');
xlabel('rho');
legend('NMI', 'ARI', 'ACC', 'PUR', Location='southeast');