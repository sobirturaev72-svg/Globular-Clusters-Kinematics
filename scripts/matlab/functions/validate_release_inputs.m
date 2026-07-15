function validate_release_inputs(cfg, D)
%VALIDATE_REVISION_INPUTS Fail fast if numerical inputs are inconsistent.
requiredNorm = {'cluster','n_bins','KAP','KAP_err_analytic','KAP_class', ...
    'GKI','GKI_err','GKI_sign_class','Ds_raw','Ds_corr'};
requiredProfile = {'cluster','R_over_rh_l','sigma','err_sigma', ...
    'sigma_r','err_sigma_r','sigma_t','err_sigma_t'};
assert_columns(D.norm, requiredNorm, 'normalized metrics');
assert_columns(D.full, requiredNorm, 'full-range metrics');
assert_columns(D.profile, requiredProfile, 'profile table');

assert(height(D.norm) == 20, 'Normalized table must contain 20 clusters.');
assert(height(D.full) == 20, 'Full-range table must contain 20 clusters.');
assert(numel(unique(D.profile.cluster)) == 20, ...
    'Profile table must contain 20 unique clusters.');
assert(height(D.profile) == 395, 'Expected 395 audited profile rows.');

nRadNorm = sum(strcmpi(D.norm.KAP_class, 'RADIAL'));
nIsoNorm = sum(strcmpi(D.norm.KAP_class, 'ISOTROPIC'));
nTangNorm = sum(strcmpi(D.norm.KAP_class, 'TANGENTIAL'));
nNegGki = sum(strcmpi(D.norm.GKI_sign_class, 'NEGATIVE'));
nFlatGki = sum(strcmpi(D.norm.GKI_sign_class, 'CONSISTENT_WITH_ZERO'));
nZeroCorr = sum(abs(D.norm.Ds_corr) < 1e-12);
nRadFull = sum(strcmpi(D.full.KAP_class, 'RADIAL'));

assert(nRadNorm == 5, 'Expected five normalized radial-KAP clusters.');
assert(nIsoNorm == 15, 'Expected fifteen normalized isotropic clusters.');
assert(nTangNorm == 0, 'Expected zero normalized tangential clusters.');
assert(nNegGki == 18, 'Expected eighteen negative normalized GKI values.');
assert(nFlatGki == 2, 'Expected two normalized GKI values consistent with zero.');
assert(nZeroCorr == 11, 'Expected eleven normalized Ds_corr values equal to zero.');
assert(nRadFull == 7, 'Expected seven full-range radial-KAP clusters.');

ngc6388Profile = D.profile(D.profile.cluster == "NGC6388", :);
assert(height(ngc6388Profile) == 31, 'NGC6388 must contain 31 audited bins.');
ngc6388Norm = D.norm(D.norm.cluster == "NGC6388", :);
assert(height(ngc6388Norm) == 1, 'NGC6388 missing from normalized table.');
assert(abs(ngc6388Norm.Ds_corr) < 1e-12, ...
    'NGC6388 normalized Ds_corr must be zero.');

maxIdentityDiff = max(abs(D.norm.KAP - D.norm.minus_beta_norm_dispersionweighted));
assert(maxIdentityDiff < 1e-10, ...
    'KAP/dispersion-scale-weighted normalized-beta identity check failed.');

reportFile = fullfile(cfg.outLog, 'input_validation_report.txt');
fid = fopen(reportFile, 'w');
if fid < 0
    error('Cannot write validation report: %s', reportFile);
end
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, 'MN-26-1278-P.R1 MATLAB figure input validation\n');
fprintf(fid, 'Clusters: 20\n');
fprintf(fid, 'Profile rows: 395\n');
fprintf(fid, 'Normalized KAP: 5 radial, 15 isotropic, 0 tangential\n');
fprintf(fid, 'Normalized GKI: 18 negative, 2 consistent with zero\n');
fprintf(fid, 'Normalized Ds_corr: 11 zero, 9 non-zero\n');
fprintf(fid, 'Full-range KAP: 7 radial\n');
fprintf(fid, 'NGC6388 audited bins: 31\n');
fprintf(fid, 'Max KAP identity difference: %.3e\n', maxIdentityDiff);
fprintf(fid, 'Status: PASS\n');
end

function assert_columns(T, required, tableName)
missing = setdiff(required, T.Properties.VariableNames);
if ~isempty(missing)
    error('Missing columns in %s: %s', tableName, strjoin(missing, ', '));
end
end
