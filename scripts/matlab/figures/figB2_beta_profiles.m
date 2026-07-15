function figB2_beta_profiles(cfg, D)
%FIGB2_BETA_PROFILES Audited beta profiles in the original 4x5 style.
codes = D.norm.cluster;
make_page(cfg, D.profile, codes, 'FigB2_beta_profiles_all20', 4, 5, ...
    cfg.profileWidthIn, cfg.profileHeightIn, cfg.panelFontSize);
make_page(cfg, D.profile, codes(1:10), 'FigB2a_beta_profiles_01_10', 2, 5, ...
    cfg.profileWidthIn, cfg.profileSplitHeightIn, cfg.splitPanelFontSize);
make_page(cfg, D.profile, codes(11:20), 'FigB2b_beta_profiles_11_20', 2, 5, ...
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
    [beta, betaErr] = compute_beta_profile(S.sigma_r, S.err_sigma_r, ...
        S.sigma_t, S.err_sigma_t);

    errorbar(ax, S.R_arcsec, beta, betaErr, '-o', ...
        'Color', cfg.legacyBetaBlue, ...
        'MarkerFaceColor', cfg.legacyBetaBlue, ...
        'MarkerEdgeColor', cfg.legacyBetaBlue, ...
        'MarkerSize', 3.5, 'LineWidth', 0.95, 'CapSize', 2.5);
    yline(ax, 0, '--', 'Color', cfg.zeroLineRed, 'LineWidth', 0.85, ...
        'HandleVisibility', 'off');
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
    ylim(ax, cfg.betaYLim);

    xlabel(ax, 'Radius (arcsec)', 'FontName', cfg.fontName, ...
        'FontSize', max(7.2,fontSize-0.1));
    ylabel(ax, '\beta(R)', 'FontName', cfg.fontName, ...
        'FontSize', max(7.2,fontSize-0.1), 'Interpreter', 'tex');
end
export_figure_bundle(fig, baseName, cfg, false);
end
