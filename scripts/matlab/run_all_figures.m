%% Generate all archived article figures
% Run this file from the package root:
%   run('run_all_figures.m')

clearvars;
clc;

rootDir = fileparts(mfilename('fullpath'));
addpath(genpath(rootDir));

cfg = mnras_figure_config(rootDir);
ensure_output_dirs(cfg);
D = load_release_data(cfg);
validate_release_inputs(cfg, D);

fprintf('\nGenerating main-text figures...\n');
fig01_kap_normalized(cfg, D);
fig02_gki_normalized(cfg, D);
fig03_scatter_diagnostics(cfg, D);

fprintf('\nGenerating appendix figures...\n');
figB1_dispersion_profiles(cfg, D);
figB2_beta_profiles(cfg, D);
figB3_kap_beta_norm_relation(cfg, D);
figB4_radial_interval_sensitivity(cfg, D);

fprintf('\n\n');

write_runtime_manifest(cfg);
validate_figure_outputs(cfg);

fprintf('\nCompleted. Figure windows remain open.\n');
fprintf('PDF outputs: %s\n', cfg.outPdf);
