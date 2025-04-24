function [labels, data] = Import_ReligiousTextsDataset()
    % Import from file
    filedir = fileparts(mfilename('fullpath'));
    filename = fullfile(filedir, 'ReligiousTexts\AllBooks_baseline_DTM_Labelled.csv');
    T = readtable(filename, 'NumHeaderLines', 1);
    chapters = T{:,1};
    data = T{:, 2:end};

    % Process Data
    bookNames = cellfun(@(s) strtok(s, '_'), chapters, 'UniformOutput', false);
    [~, ~, labels] = unique(bookNames);
    
    % Rearrange Data
    [nSamples, ~] = size(data);
    Prng = randperm(nSamples);
    data = data(Prng, :);
    labels = labels(Prng, :);
end