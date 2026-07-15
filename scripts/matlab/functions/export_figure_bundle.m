function export_figure_bundle(fig, baseName, cfg, varargin)
%EXPORT_FIGURE_BUNDLE Export a vector PDF manuscript figure.
pdfFile = fullfile(cfg.outPdf, [baseName '.pdf']);
drawnow;
set(fig, 'Renderer', 'painters');
try
    exportgraphics(fig, pdfFile, 'ContentType', 'vector', 'BackgroundColor', 'white');
catch
    print(fig, pdfFile, '-dpdf', '-painters', '-bestfit');
end
if cfg.closeAfterExport
    close(fig);
end
end
