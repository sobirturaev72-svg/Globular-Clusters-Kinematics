function fig01_kap_normalized(cfg, D)
%FIG01_KAP_NORMALIZED KAP figure for the primary normalized interval.
T = D.norm;
[~, order] = sort(T.KAP, 'ascend');
T = T(order, :);
labels = cluster_short_labels(T.cluster);
x = (1:height(T))';

fig = new_publication_figure(cfg, cfg.mainWidthIn, cfg.mainHeightIn);
ax = axes(fig, 'Position', [0.095 0.245 0.885 0.705]);
hold(ax, 'on');

bar(ax, x, T.KAP, 0.72, 'FaceColor', cfg.legacyGreyBar, ...
    'EdgeColor', cfg.legacyGreyEdge, 'LineWidth', 0.80);
errorbar(ax, x, T.KAP, T.KAP_err_analytic, 'k', ...
    'LineStyle', 'none', 'LineWidth', cfg.lineWidth, ...
    'CapSize', cfg.errorCapSize);
yline(ax, 0, '-', 'Color', cfg.zeroLineRed, 'LineWidth', 1.05);

set(ax, 'XTick', x, 'XTickLabel', cellstr(labels));
xtickangle(ax, 45);
xlabel(ax, 'Globular Cluster', 'FontName', cfg.fontName, ...
    'FontSize', cfg.axisLabelFontSize, 'FontWeight', 'bold');
ylabel(ax, 'KAP (Global Kinematic Anisotropy Parameter)', ...
    'FontName', cfg.fontName, 'FontSize', cfg.axisLabelFontSize, ...
    'FontWeight', 'bold');
style_publication_axes(ax, cfg, cfg.mainTickFontSize);

xlim(ax, [0.35 height(T)+0.65]);
ylim(ax, cfg.kapYLim);
yticks(ax, cfg.kapYTicks);
text(ax, 1.0, 0.068, 'Tangential anisotropy', ...
    'Color', cfg.legacyBlue, 'FontName', cfg.fontName, ...
    'FontSize', 9.6, 'FontWeight', 'bold');
text(ax, 1.0, -0.108, 'Radial anisotropy', ...
    'Color', cfg.legacyBlue, 'FontName', cfg.fontName, ...
    'FontSize', 9.6, 'FontWeight', 'bold');

% A common horizontal 2-sigma threshold is intentionally not drawn:
% each cluster has its own uncertainty and significance criterion.
export_figure_bundle(fig, 'Fig01_KAP_normalized', cfg, false);
end
