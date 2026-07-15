function ensure_output_dirs(cfg)
%ENSURE_OUTPUT_DIRS Create PDF and log output directories.
paths = {cfg.outPdf, cfg.outLog};
for i = 1:numel(paths)
    if ~isfolder(paths{i})
        mkdir(paths{i});
    end
end
end
