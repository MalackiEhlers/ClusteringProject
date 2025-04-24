function [labels, data] = Import_BitcoinDataset()
    % Import from file
    filedir = fileparts(mfilename('fullpath'));
    filename = fullfile(filedir, 'Bitcoin\BitcoinHeistData.csv');
    T = readtable(filename, 'NumHeaderLines', 1);
    family = T{:,10};
    data = T{:, 2:9};
    [~, ~, labels] = unique(family);

    % Rearrange Data
    [nSamples, ~] = size(data);
    Prng = randperm(nSamples);
    data = data(Prng, :);
    labels = labels(Prng, :);
end