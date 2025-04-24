function data = Import_USCensusDataset()
    % Import Data
    filedir = fileparts(mfilename('fullpath'));
    filename = fullfile(filedir, 'USCensus1990\USCensus1990.data.txt');
    opts = detectImportOptions(filename);
    opts.DataLines = 2;
    data = readmatrix(filename, opts);
    data(:,1) = [];
    [nSamples, ~] = size(data);
    
    % Randomization
    Prng = randperm(nSamples);
    data = data(Prng, :);
end

