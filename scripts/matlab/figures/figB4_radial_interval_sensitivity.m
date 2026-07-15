function figB4_radial_interval_sensitivity(cfg, D)
%FIGB4_RADIAL_INTERVAL_SENSITIVITY Full versus normalized diagnostics.
F = D.full;
N = D.norm;
[tf, loc] = ismember(F.cluster, N.cluster);
assert(all(tf), 'Cluster mismatch between full and normalized tables.');
N = N(loc, :);
changed = ~strcmpi(F.KAP_class, N.KAP_class);

fig = new_publication_figure(cfg, cfg.twoPanelWidthIn, cfg.twoPanelHeightIn);
tl = tiledlayout(fig, 1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% KAP panel
ax1 = nexttile(tl);
hold(ax1, 'on');
add_xy_errorbars(ax1, F.KAP, N.KAP, F.KAP_err_analytic, N.KAP_err_analytic, ...
    cfg.colourLight, 0.7);
plot_identity(ax1, [F.KAP; N.KAP], cfg);
plot(ax1, F.KAP(~changed), N.KAP(~changed), 'o', 'LineStyle', 'none', ...
    'MarkerFaceColor', 'white', 'MarkerEdgeColor', cfg.colourPrimary, ...
    'MarkerSize', 5.2, 'LineWidth', 1.0, 'DisplayName', 'Unchanged class');
plot(ax1, F.KAP(changed), N.KAP(changed), 's', 'LineStyle', 'none', ...
    'MarkerFaceColor', cfg.colourAccent, 'MarkerEdgeColor', cfg.colourAccent, ...
    'MarkerSize', 6.0, 'DisplayName', 'Changed KAP class');
label_selected(ax1, F, N, {'NGC6388','NGC6441'}, 'KAP');
xlabel(ax1, 'Full-range KAP');
ylabel(ax1, 'KAP in R \leq R_{h,l}', 'Interpreter', 'tex');
style_publication_axes(ax1, cfg, cfg.smallFontSize);
axis(ax1, 'square');
legend(ax1, 'Location', 'best', 'Box', 'off', 'FontSize', 7.5);

% GKI panel
ax2 = nexttile(tl);
hold(ax2, 'on');
add_xy_errorbars(ax2, F.GKI, N.GKI, F.GKI_err, N.GKI_err, ...
    cfg.colourLight, 0.7);
plot_identity(ax2, [F.GKI; N.GKI], cfg);
plot(ax2, F.GKI, N.GKI, 'o', 'LineStyle', 'none', ...
    'MarkerFaceColor', 'white', 'MarkerEdgeColor', cfg.colourPrimary, ...
    'MarkerSize', 5.2, 'LineWidth', 1.0);
label_selected(ax2, F, N, {'NGC6388','NGC6441'}, 'GKI');
xlabel(ax2, 'Full-range GKI');
ylabel(ax2, 'GKI in R \leq R_{h,l}', 'Interpreter', 'tex');
style_publication_axes(ax2, cfg, cfg.smallFontSize);
axis(ax2, 'square');

export_figure_bundle(fig, 'FigB4_radial_interval_sensitivity', cfg, false);
end

function plot_identity(ax, values, cfg)
lo = min(values(:));
hi = max(values(:));
pad = 0.08 * max(hi-lo, 0.05);
lo = lo-pad;
hi = hi+pad;
plot(ax, [lo hi], [lo hi], '--', 'Color', cfg.colourSecondary, ...
    'LineWidth', 0.9, 'HandleVisibility', 'off');
xlim(ax, [lo hi]);
ylim(ax, [lo hi]);
end

function label_selected(ax, F, N, codeList, fieldName)
for k = 1:numel(codeList)
    idx = find(F.cluster == string(codeList{k}), 1);
    if isempty(idx), continue; end
    x = F.(fieldName)(idx);
    y = N.(fieldName)(idx);
    text(ax, x, y, ['  ' char(cluster_display_names(F.cluster(idx)))], ...
        'FontSize', 7.2, 'Interpreter', 'none', 'VerticalAlignment', 'bottom');
end
end
