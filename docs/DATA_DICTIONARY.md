# Data dictionary

## `profiles_hacks_20clusters.csv`

Audited bin-level profile table. Key fields:

- `cluster`: canonical cluster code;
- `R_arcsec`, `R_pc`, `R_over_rh_l`: projected radius;
- `sigma`, `sigma_r`, `sigma_t`: combined, radial, and tangential proper-motion dispersions;
- `err_sigma`, `err_sigma_r`, `err_sigma_t`: corresponding 1-sigma errors;
- `rh_l_pc`: projected half-light radius.

## `metrics_primary_R_le_Rh.csv`

Primary normalized-interval diagnostics:

- `KAP`, `KAP_err_analytic`, `KAP_class`;
- `GKI`, `GKI_err`, `GKI_sign_class`;
- `Ds_raw`, `Ds_corr`;
- normalized-beta comparison fields.

## `metrics_full_HST.csv`

Audited full-HST-range diagnostics used only as a radial-coverage sensitivity layer.

## `radial_coverage.csv`

Per-cluster HST radial coverage in units of the projected half-light radius.

## `ngc6388_bin_audit.csv`

Compact audit summary documenting the adopted 31-bin profile and the 13-bin normalized subset.
