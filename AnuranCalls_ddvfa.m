%% Clean up
clear variables; close all; fclose all; echo off; clc;

%% Add path
addpath('data', 'FastMICE', 'DDVFA\functions', 'DDVFA\classes');

%% Import data
[labels, data] = Import_AnuranCallsDataset();

%% DDVFA

% DDVFA parameters
params_DDVFA_1 = struct();
params_DDVFA_1.rho_lb = 0.75;
params_DDVFA_1.rho_ub = 0.80;
params_DDVFA_1.alpha = 1e-3;
params_DDVFA_1.beta = 1;
params_DDVFA_1.gamma = 3;
params_DDVFA_1.gamma_ref = 1;
nEpochs = 1;
method = 'single';

% DDVFA
DDVFA_1 = DistDualVigFuzzyART(params_DDVFA_1);  
DDVFA_1.display = true;
DDVFA_1 = DDVFA_1.train(data, nEpochs, method);

% Merge ART parameters
params_MFA            = struct();
params_MFA.rho        = DDVFA_1.rho;
params_MFA.alpha      = DDVFA_1.alpha;
params_MFA.beta       = DDVFA_1.beta;
params_MFA.gamma      = DDVFA_1.gamma;
params_MFA.gamma_ref  = DDVFA_1.gamma_ref;
nEpochs_MFA = 1;

% Merge ART
t = 1;
MFA = MergeFuzzyART(params_MFA);
MFA.display = true;
MFA = MFA.train(DDVFA_1, nEpochs_MFA);
MFA_old = MFA;
while true
    t = t + 1;
    MFA.F2 = {};
    MFA = MFA.train(MFA_old, nEpochs_MFA); 
    if MFA.nCategories == MFA_old.nCategories        
        MFA = MFA.compress();   
        break;
    end    
    MFA_old = MFA;
end

%% Evaluate Performance
fourScores = computeFourClusteringMetrics(MFA.labels, labels);
disp('--------------------------------------------------------------'); 
disp(['NMI = ',num2str(fourScores(1))]);
disp(['ARI = ',num2str(fourScores(2))]);
disp(['ACC = ',num2str(fourScores(3))]);
disp(['PUR = ',num2str(fourScores(4))]);
disp('--------------------------------------------------------------');