function validate_figure_outputs(cfg)
%VALIDATE_FIGURE_OUTPUTS Check expected vector PDF outputs exist.
expected = { ...
    'Fig01_KAP_normalized', ...
    'Fig02_GKI_normalized', ...
    'Fig03_Ds_raw_vs_corrected', ...
    'FigB1_dispersion_profiles_all20', ...
    'FigB2_beta_profiles_all20', ...
    'FigB3_KAP_beta_norm_relation', ...
    'FigB4_radial_interval_sensitivity'};
missing = strings(0,1);
for i = 1:numel(expected)
    f = fullfile(cfg.outPdf, [expected{i} '.pdf']);
    if ~isfile(f)
        missing(end+1,1) = string(f); %#ok<AGROW>
    end
end
if ~isempty(missing)
    warning('Some expected PDF outputs are missing:
%s', strjoin(missing, newline));
else
    fprintf('Output validation: all expected manuscript PDFs found.
');
end
end
