function figB3_kap_beta_norm_relation(cfg, D)
%FIGB3_KAP_BETA_NORM_RELATION Relation to normalized beta contrasts.
T = D.full;
fig = new_publication_figure(cfg, cfg.twoPanelWidthIn, cfg.twoPanelHeightIn);
tl = tiledlayout(fig, 1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

ax1 = nexttile(tl);
hold(ax1, 'on');
plot_relation(ax1, T.minus_beta_norm_wmean, T.KAP, cfg);
xlabel(ax1, '-\langle\beta_{norm}\rangle_w', 'Interpreter', 'tex');
ylabel(ax1, 'KAP');
style_publication_axes(ax1, cfg, cfg.smallFontSize);
axis(ax1, 'square');

ax2 = nexttile(tl);
hold(ax2, 'on');
plot_relation(ax2, T.minus_beta_norm_dispersionweighted, T.KAP, cfg);
xlabel(ax2, 'Dispersion-scale-weighted -\beta_{norm}', 'Interpreter', 'tex');
ylabel(ax2, 'KAP');
style_publication_axes(ax2, cfg, cfg.smallFontSize);
axis(ax2, 'square');

maxDiff = max(abs(T.KAP - T.minus_beta_norm_dispersionweighted));
text(ax2, 0.04, 0.94, sprintf('max |difference| = %.1e', maxDiff), ...
    'Units', 'normalized', 'VerticalAlignment', 'top', ...
    'FontSize', 7.5, 'Interpreter', 'none');

export_figure_bundle(fig, 'FigB3_KAP_beta_norm_relation', cfg, false);
end

function plot_relation(ax, x, y, cfg)
lo = min([x; y]);
hi = max([x; y]);
pad = 0.10 * max(hi-lo, 0.05);
lo = lo-pad;
hi = hi+pad;
plot(ax, [lo hi], [lo hi], '--', 'Color', cfg.colourSecondary, ...
    'LineWidth', 0.9, 'HandleVisibility', 'off');
plot(ax, x, y, 'o', 'LineStyle', 'none', 'MarkerFaceColor', 'white', ...
    'MarkerEdgeColor', cfg.colourPrimary, 'MarkerSize', 5.5, 'LineWidth', 1.0);
xlim(ax, [lo hi]);
ylim(ax, [lo hi]);
end
