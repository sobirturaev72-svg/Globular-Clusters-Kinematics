function figB1_dispersion_profiles(cfg, D)
%FIGB1_DISPERSION_PROFILES Audited profiles in the original 4x5 style.
codes = D.norm.cluster;
make_page(cfg, D.profile, codes, 'FigB1_dispersion_profiles_all20', 4, 5, ...
    cfg.profileWidthIn, cfg.profileHeightIn, cfg.panelFontSize);
make_page(cfg, D.profile, codes(1:10), 'FigB1a_dispersion_profiles_01_10', 2, 5, ...
    cfg.profileWidthIn, cfg.profileSplitHeightIn, cfg.splitPanelFontSize);
make_page(cfg, D.profile, codes(11:20), 'FigB1b_dispersion_profiles_11_20', 2, 5, ...
    cfg.profileWidthIn, cfg.profileSplitHeightIn, cfg.splitPanelFontSize);
end

function make_page(cfg, P, codes, baseName, nCols, nRows, widthIn, heightIn, fontSize)
fig = new_publication_figure(cfg, widthIn, heightIn);
tl = tiledlayout(fig, nRows, nCols, 'TileSpacing', 'compact', 'Padding', 'compact');
for i = 1:numel(codes)
    ax = nexttile(tl);
    hold(ax, 'on');
    S = P(P.cluster == codes(i), :);
    [~, idx] = sort(S.R_arcsec);
    S = S(idx, :);

    errorbar(ax, S.R_arcsec, S.sigma, S.err_sigma, '-o', ...
        'Color', cfg.colourPrimary, 'MarkerFaceColor', cfg.colourPrimary, ...
        'MarkerEdgeColor', cfg.colourPrimary, 'MarkerSize', 3.5, ...
        'LineWidth', 0.95, 'CapSize', 2.5);
    errorbar(ax, S.R_arcsec, S.sigma_r, S.err_sigma_r, '-s', ...
        'Color', cfg.colourAccent, 'MarkerFaceColor', cfg.colourAccent, ...
        'MarkerEdgeColor', cfg.colourAccent, 'MarkerSize', 3.5, ...
        'LineWidth', 0.95, 'CapSize', 2.5);
    errorbar(ax, S.R_arcsec, S.sigma_t, S.err_sigma_t, '-d', ...
        'Color', cfg.colourWarm, 'MarkerFaceColor', cfg.colourWarm, ...
        'MarkerEdgeColor', cfg.colourWarm, 'MarkerSize', 3.5, ...
        'LineWidth', 0.95, 'CapSize', 2.5);

    if cfg.addRhGuide
        rhArcsec = median(S.R_arcsec ./ S.R_over_rh_l, 'omitnan');
        xline(ax, rhArcsec, '--', 'Color', cfg.rhGuideColour, ...
            'LineWidth', 0.75, 'HandleVisibility', 'off');
    end

    set(ax, 'XScale', 'log');
    title(ax, cluster_short_labels(codes(i)), 'FontWeight', 'normal', ...
        'FontName', cfg.fontName, 'FontSize', fontSize+0.2, ...
        'Interpreter', 'none');
    style_publication_axes(ax, cfg, fontSize);
    set(ax, 'XMinorGrid', 'on', 'YMinorGrid', 'on');

    xMin = max(1.5, 0.82*min(S.R_arcsec));
    xMax = 1.15*max(S.R_arcsec);
    xlim(ax, [xMin xMax]);
    allLow = [S.sigma-S.err_sigma; S.sigma_r-S.err_sigma_r; S.sigma_t-S.err_sigma_t];
    allHigh = [S.sigma+S.err_sigma; S.sigma_r+S.err_sigma_r; S.sigma_t+S.err_sigma_t];
    yMin = max(0, min(allLow));
    yMax = max(allHigh);
    yPad = max(0.04*(yMax-yMin), 0.005);
    ylim(ax, [max(0,yMin-yPad), yMax+yPad]);

    xlabel(ax, 'Radius (arcsec)', 'FontName', cfg.fontName, ...
        'FontSize', max(7.2,fontSize-0.1));
    ylabel(ax, 'Dispersion (mas yr^{-1})', 'FontName', cfg.fontName, ...
        'FontSize', max(7.2,fontSize-0.1), 'Interpreter', 'tex');
end
export_figure_bundle(fig, baseName, cfg, false);
end
