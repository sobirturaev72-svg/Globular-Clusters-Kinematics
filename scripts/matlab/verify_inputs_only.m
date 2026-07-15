%% Verify deterministic inputs without drawing figures
clearvars; clc;
rootDir = fileparts(mfilename('fullpath'));
addpath(genpath(rootDir));
cfg = mnras_figure_config(rootDir);
ensure_output_dirs(cfg);
D = load_release_data(cfg);
validate_release_inputs(cfg, D);
fprintf('Input validation completed successfully.\n');
