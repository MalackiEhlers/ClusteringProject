%% Clean up
clear variables; close all; fclose all; echo off; clc;

%% Add path
addpath('data', 'FastMICE', 'classes');

%% Import Data
[labels, data] = Import_BitcoinDataset();
K = max(labels);

%% Normalization
data = mapminmax(data', 0, 1)';

%% Fuzzy ART
rho = 0.30:0.10:0.60;
for r = 1:length(rho)
    % ART Parameter settings
    settings = struct();
    settings.rho = rho(r);
    settings.alpha = 1e-3;
    settings.beta = 1;
    settings.display = 1;
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
title('Bitcoin Heist Fuzzy ART Performance');
xlabel('rho');
legend('NMI', 'ARI', 'ACC', 'PUR', Location='southeast');

figure;
plot(rho,runtime);
title('Bitcoin Heist Fuzzy ART Runtime');
xlabel('rho');
ylabel('Time (s)');

%% Display best performance metrics
runIdx = find(rho==input('Select best rho value:'));
disp('--------------------------------------------------------------'); 
disp('Bitcoin Heist Fuzzy ART');
disp(['Rho = ', num2str(rho(runIdx))]);
disp(['Runtime = ', num2str(runtime(runIdx)), ' (s)']);
disp(['NMI = ',num2str(fourScores(runIdx,1))]);
disp(['ARI = ',num2str(fourScores(runIdx,2))]);
disp(['ACC = ',num2str(fourScores(runIdx,3))]);
disp(['PUR = ',num2str(fourScores(runIdx,4))]);
disp('--------------------------------------------------------------');