function [labels, data] = Import_NewsgroupsDataset()
    % Import from file
    filedir = fileparts(mfilename('fullpath'));
    filename = fullfile(filedir, 'Newsgroups\NGs.mat');
    load(filename);

    % Restructure data and labels
    data = [data{1}', data{2}', data{3}'];
    labels = truelabel{1}';

    % Reorder data
    [nSamples, ~] = size(data);
    Prng = randperm(nSamples);
    data = data(Prng, :);
    labels = labels(Prng, :);
end