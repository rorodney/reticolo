function sweep = load_bragg_table(filepath, sweep)
% LOAD_BRAGG_TABLE  Load a (Energy, alpha) Bragg-peak table and populate
%                   sweep.values and sweep.alpha_deg for use with run_rcwa.
%
% The file is expected to be tab-separated with a header row.
% Required columns (case-insensitive): Energy, alpha
% Any additional columns (Efficiency, beta, Cff etc.) are ignored.
%
% USAGE
%   sweep = load_bragg_table('bragg_table.tsv')
%   sweep = load_bragg_table('bragg_table.tsv', sweep)   % merge into existing
%
% OUTPUT
%   sweep.type      = 'bragg'
%   sweep.values    = [energy1, energy2, ...]   (eV)
%   sweep.alpha_deg = [alpha1,  alpha2,  ...]   (grazing angle, deg)

if nargin < 2; sweep = struct(); end

if exist(filepath, 'file') ~= 2
    error('load_bragg_table: file not found: %s', filepath);
end

% Read header line to find column indices
fid   = fopen(filepath, 'r');
hdr   = strtrim(fgetl(fid));
fclose(fid);

% Support tab or comma separation
if contains(hdr, '\t') || numel(strfind(hdr, sprintf('\t'))) > 0
    delim = '\t';
else
    delim = ',';
end

cols = strsplit(hdr, sprintf(delim));
cols = strtrim(cols);
cols_lower = lower(cols);

idx_E = find(strcmp(cols_lower, 'energy'), 1);
% alpha column: accept 'alpha', 'alpha(norm)' is the complementary normal-incidence
% angle — we want the grazing angle, which in the table is plain 'alpha'
idx_a = find(strcmp(cols_lower, 'alpha'), 1);

if isempty(idx_E)
    error('load_bragg_table: could not find ''Energy'' column in %s', filepath);
end
if isempty(idx_a)
    error('load_bragg_table: could not find ''alpha'' column in %s', filepath);
end

% Read numeric data
data = dlmread(filepath, sprintf(delim), 1, 0);

sweep.type      = 'bragg';
sweep.values    = data(:, idx_E)';
sweep.alpha_deg = data(:, idx_a)';

fprintf('load_bragg_table: loaded %d (energy, alpha) pairs from %s\n', ...
    numel(sweep.values), filepath);
fprintf('  Energy range: %.1f – %.1f eV\n', min(sweep.values), max(sweep.values));
fprintf('  Alpha range:  %.3f – %.3f deg\n', min(sweep.alpha_deg), max(sweep.alpha_deg));

end
