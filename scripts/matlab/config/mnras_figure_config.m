function cfg = mnras_figure_config(rootDir)
%MNRAS_FIGURE_CONFIG Central configuration for all figure scripts.
% Figure configuration for the associated article and archived release.

if nargin < 1 || isempty(rootDir)
    thisFile = mfilename('fullpath');
    rootDir = fileparts(fileparts(fileparts(thisFile)));
end

cfg.root = rootDir;
packageRoot = fileparts(fileparts(rootDir));
cfg.packageRoot = packageRoot;
cfg.dataDir = fullfile(rootDir, 'data', 'input');
cfg.outPdf = fullfile(packageRoot, 'results', 'figures', 'pdf');
cfg.outLog = fullfile(packageRoot, 'results', 'validation', 'matlab_logs');

cfg.visible = 'on';
cfg.closeAfterExport = false;
cfg.fontName = 'Arial';
cfg.backgroundColor = 'white';

% Typography settings for article figures.
cfg.fontSize = 11.0;
cfg.mainTickFontSize = 10.0;
cfg.smallFontSize = 9.5;
cfg.panelFontSize = 8.2;
cfg.splitPanelFontSize = 9.8;
cfg.axisLabelFontSize = 11.5;
cfg.panelAxisLabelFontSize = 8.3;
cfg.titleFontSize = 11.0;
cfg.panelTitleFontSize = 8.4;

cfg.lineWidth = 1.10;
cfg.markerSize = 5.5;
cfg.errorCapSize = 6;
cfg.axisLineWidth = 0.85;
cfg.gridColor = [0.82 0.82 0.82];
cfg.minorGridColor = [0.90 0.90 0.90];
cfg.gridAlpha = 0.55;
cfg.minorGridAlpha = 0.35;

% Submitted-proof palette (MATLAB-style black/blue/red plus grey bars).
cfg.colourPrimary = [0.00 0.00 0.00];
cfg.colourSecondary = [0.35 0.35 0.35];
cfg.colourAccent = [0.00 0.4470 0.7410];
cfg.colourWarm = [0.8500 0.3250 0.0980];
cfg.colourLight = [0.72 0.72 0.72];
cfg.legacyGreyBar = [0.76 0.76 0.76];
cfg.legacyGreyEdge = [0.25 0.25 0.25];
cfg.legacyRed = [0.80 0.16 0.16];
cfg.legacyBlue = [0.18 0.38 0.76];
cfg.legacyGreen = [0.20 0.65 0.25];
cfg.legacyOrange = [1.00 0.55 0.12];
cfg.legacyBetaBlue = [0.3010 0.7450 0.9330];
cfg.zeroLineRed = [0.90 0.10 0.10];
cfg.rhGuideColour = [0.45 0.45 0.45];

% Figure sizes chosen to match the submitted proof proportions.
cfg.mainWidthIn = 7.20;
cfg.mainHeightIn = 3.55;
cfg.scatterHeightIn = 4.20;
cfg.twoPanelWidthIn = 7.20;
cfg.twoPanelHeightIn = 3.80;
cfg.profileWidthIn = 7.20;
cfg.profileHeightIn = 6.75;
cfg.profileSplitHeightIn = 8.60;

% Preserve original axis scales where they remain scientifically valid.
cfg.kapYLim = [-0.12 0.08];
cfg.kapYTicks = -0.12:0.02:0.08;
cfg.gkiYLim = [-0.30 0.05];
cfg.gkiYTicks = -0.30:0.05:0.05;
cfg.dsXLim = [0 4.2];
cfg.dsXTicks = 0:0.5:4.0;
cfg.betaYLim = [-1.0 0.75];
cfg.addRhGuide = true;

cfg.inputFiles.profile = 'profiles_hacks_20clusters.csv';
cfg.inputFiles.normalized = 'metrics_primary_R_le_Rh.csv';
cfg.inputFiles.full = 'metrics_full_HST.csv';
cfg.inputFiles.normalizedProps = 'metrics_primary_R_le_Rh_with_cluster_properties.csv';
cfg.inputFiles.fullProps = 'metrics_full_HST_with_cluster_properties.csv';
cfg.inputFiles.coverage = 'radial_coverage.csv';
cfg.inputFiles.betaComparison = 'kap_beta_norm_identity_full.csv';
cfg.inputFiles.ngc6388Audit = 'ngc6388_bin_audit.csv';
end
