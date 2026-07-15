function fig02_gki_normalized(cfg, D)
%FIG02_GKI_NORMALIZED GKI figure for the primary normalized interval.
T = D.norm;
% Preserve the cluster ordering used by Figure 1, as in the proof.
[~, order] = sort(T.KAP, 'ascend');
T = T(order, :);
labels = cluster_short_labels(T.cluster);
x = (1:height(T))';

fig = new_publication_figure(cfg, cfg.mainWidthIn, cfg.mainHeightIn);
ax = axes(fig, 'Position', [0.095 0.245 0.885 0.690]);
hold(ax, 'on');

isNegative = strcmpi(T.GKI_sign_class, 'NEGATIVE');
barColours = repmat(cfg.legacyBlue, height(T), 1);
barColours(isNegative, :) = repmat(cfg.legacyRed, sum(isNegative), 1);
b = bar(ax, x, T.GKI, 0.72, 'FaceColor', 'flat', ...
    'EdgeColor', cfg.legacyGreyEdge, 'LineWidth', 0.80);
b.CData = barColours;
errorbar(ax, x, T.GKI, T.GKI_err, 'k', ...
    'LineStyle', 'none', 'LineWidth', cfg.lineWidth, ...
    'CapSize', cfg.errorCapSize);
yline(ax, 0, '-', 'Color', cfg.zeroLineRed, 'LineWidth', 1.05);

set(ax, 'XTick', x, 'XTickLabel', cellstr(labels));
xtickangle(ax, 45);
xlabel(ax, 'Globular Cluster', 'FontName', cfg.fontName, ...
    'FontSize', cfg.axisLabelFontSize, 'FontWeight', 'bold');
ylabel(ax, 'GKI (Global Kinematic Index)', 'FontName', cfg.fontName, ...
    'FontSize', cfg.axisLabelFontSize, 'FontWeight', 'bold');
title(ax, 'Velocity Dispersion Gradients for 20 Globular Clusters', ...
    'FontName', cfg.fontName, 'FontSize', cfg.titleFontSize, ...
    'FontWeight', 'bold');
style_publication_axes(ax, cfg, cfg.mainTickFontSize);

xlim(ax, [0.35 height(T)+0.65]);
ylim(ax, cfg.gkiYLim);
yticks(ax, cfg.gkiYTicks);
text(ax, 1.0, 0.028, 'Consistent with zero', ...
    'Color', cfg.legacyBlue, 'FontName', cfg.fontName, ...
    'FontSize', 9.4, 'FontWeight', 'bold');
text(ax, 1.0, -0.278, 'Negative empirical slope', ...
    'Color', cfg.legacyRed, 'FontName', cfg.fontName, ...
    'FontSize', 9.4, 'FontWeight', 'bold');

% The old fixed GKI=-0.1 boundary is intentionally omitted because GKI is
% an interval-dependent empirical slope and zero-consistency is determined
% from the cluster-specific uncertainty.
export_figure_bundle(fig, 'Fig02_GKI_normalized', cfg, false);
end
