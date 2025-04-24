function [labels, data] = Import_AnuranCallsDataset()
    % Import from file
    filedir = fileparts(mfilename('fullpath'));
    filename = fullfile(filedir, 'AnuranCalls\Frogs_MFCCs.csv');
    T = readtable(filename, 'NumHeaderLines', 1);
    labels = T{:,26};
    data = T{:, 1:22};

    % Rearrange Data
    [nSamples, ~] = size(data);
    Prng = randperm(nSamples);
    data = data(Prng, :);
    labels = labels(Prng, :);
end