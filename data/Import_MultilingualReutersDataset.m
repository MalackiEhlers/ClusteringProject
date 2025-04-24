function [labels, data] = Import_MultilingualReutersDataset();
    % Import from file
    filedir = fileparts(mfilename('fullpath'));
    filename = fullfile(filedir, 'MultilingualReuters\Reuters_dim10.mat');
    load(filename);

    % Combine test and train datasets
    data = [x_test x_train];
    labels = [y_test y_train]';

    % Combine views
    [V, N, M] = size(data);
    data = permute(data, [2,1,3]);
    data = reshape(data, N, V*M);

    % Shift labels index to start at 1
    labels = double(labels + 1);

    % Reorder data
    [nSamples, ~] = size(data);
    Prng = randperm(nSamples);
    data = data(Prng, :);
    labels = labels(Prng, :);
end