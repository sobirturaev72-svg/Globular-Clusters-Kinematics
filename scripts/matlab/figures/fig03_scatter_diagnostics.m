function fig03_scatter_diagnostics(cfg, D)
%FIG03_SCATTER_DIAGNOSTICS Proof-matched horizontal bar presentation.
T = D.norm;
[~, order] = sort(T.Ds_raw, 'descend');
T = T(order, :);
labels = cluster_short_labels(T.cluster);
y = (1:height(T))';

fig = new_publication_figure(cfg, cfg.mainWidthIn, cfg.scatterHeightIn);
ax = axes(fig, 'Position', [0.145 0.135 0.825 0.825]);
hold(ax, 'on');

% Wide raw bars preserve the submitted visual hierarchy. Narrow blue bars
% overlay the noise-aware values without restoring the old severity classes.
barh(ax, y, T.Ds_raw, 0.72, 'FaceColor', cfg.legacyRed, ...
    'EdgeColor', cfg.legacyGreyEdge, 'LineWidth', 0.75, ...
    'DisplayName', 'Raw D_s');
barh(ax, y, T.Ds_corr, 0.36, 'FaceColor', cfg.legacyBlue, ...
    'EdgeColor', cfg.legacyGreyEdge, 'LineWidth', 0.70, ...
    'DisplayName', 'Noise-aware D_{s,corr}');

set(ax, 'YTick', y, 'YTickLabel', cellstr(labels), 'YDir', 'reverse');
xlabel(ax, 'Anisotropy-Profile Scatter Diagnostic', ...
    'FontName', cfg.fontName, 'FontSize', cfg.axisLabelFontSize, ...
    'FontWeight', 'bold');
ylabel(ax, 'Globular Cluster', 'FontName', cfg.fontName, ...
    'FontSize', cfg.axisLabelFontSize, 'FontWeight', 'bold');
style_publication_axes(ax, cfg, cfg.mainTickFontSize);
xlim(ax, cfg.dsXLim);
xticks(ax, cfg.dsXTicks);
ylim(ax, [0.35 height(T)+0.65]);
legend(ax, 'Location', 'northeast', 'Box', 'off', ...
    'FontName', cfg.fontName, 'FontSize', 9.5, 'Interpreter', 'tex');

% Threshold lines and categorical colour classes are
% deliberately removed: D_s and D_s,corr are profile-inspection flags.
export_figure_bundle(fig, 'Fig03_Ds_raw_vs_corrected', cfg, false);
end
