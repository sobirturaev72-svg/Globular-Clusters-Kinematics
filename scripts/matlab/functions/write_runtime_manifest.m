function write_runtime_manifest(cfg)
%WRITE_RUNTIME_MANIFEST Record execution environment and timestamp.
manifestFile = fullfile(cfg.outLog, 'runtime_manifest.txt');
fid = fopen(manifestFile, 'w');
if fid < 0
    error('Cannot write runtime manifest: %s', manifestFile);
end
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, 'Package: kap_gki_hst_gc_release_v1_1_0\n');
fprintf(fid, 'Generated: %s\n', char(datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss Z')));
fprintf(fid, 'MATLAB version: %s\n', version);
fprintf(fid, 'Computer: %s\n', computer);
fprintf(fid, 'Root: %s\n', cfg.root);
end
