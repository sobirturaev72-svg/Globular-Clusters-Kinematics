function D = load_release_data(cfg)
%LOAD_REVISION_DATA Read all deterministic CSV inputs.
D.profile = read_csv(fullfile(cfg.dataDir, cfg.inputFiles.profile));
D.norm = read_csv(fullfile(cfg.dataDir, cfg.inputFiles.normalized));
D.full = read_csv(fullfile(cfg.dataDir, cfg.inputFiles.full));
D.normProps = read_csv(fullfile(cfg.dataDir, cfg.inputFiles.normalizedProps));
D.fullProps = read_csv(fullfile(cfg.dataDir, cfg.inputFiles.fullProps));
D.coverage = read_csv(fullfile(cfg.dataDir, cfg.inputFiles.coverage));
D.betaComparisonFull = read_csv(fullfile(cfg.dataDir, cfg.inputFiles.betaComparison));
D.ngc6388Audit = read_csv(fullfile(cfg.dataDir, cfg.inputFiles.ngc6388Audit));

% Normalize categorical/string columns used by the plotting code.
D.profile.cluster = string(D.profile.cluster);
D.norm.cluster = string(D.norm.cluster);
D.full.cluster = string(D.full.cluster);
D.norm.KAP_class = string(D.norm.KAP_class);
D.full.KAP_class = string(D.full.KAP_class);
D.norm.GKI_sign_class = string(D.norm.GKI_sign_class);
D.full.GKI_sign_class = string(D.full.GKI_sign_class);
D.coverage.cluster = string(D.coverage.cluster);
D.normProps.cluster = string(D.normProps.cluster);
D.fullProps.cluster = string(D.fullProps.cluster);
end

function T = read_csv(fileName)
if ~isfile(fileName)
    error('Missing required input file: %s', fileName);
end
try
    T = readtable(fileName, 'VariableNamingRule', 'preserve');
catch
    T = readtable(fileName);
end
end
