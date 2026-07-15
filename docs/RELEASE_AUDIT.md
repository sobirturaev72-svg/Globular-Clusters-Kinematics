# Release audit

````text
PASS	version	1.1.0
PASS	cluster_count	20
PASS	profile_rows	395
PASS	parent_target_inventory	57
PASS	ngc6388_full_bins	31
PASS	ngc6388_primary_bins	13
PASS	primary_KAP_counts	(5, 15, 0)
PASS	full_KAP_counts	(7, 13, 0)
PASS	primary_GKI_counts	(18, 2)
PASS	primary_Ds_corr_counts	(11, 9)
PASS	interval_changes	['NGC6388', 'NGC6441']
PASS	KAP_beta_norm_identity	0.0
PASS	figure_pdf_set	['Fig01_KAP_primary.pdf', 'Fig02_GKI_primary.pdf', 'Fig03_Ds_raw_vs_corrected.pdf', 'FigB1_dispersion_profiles_all20.pdf', 'FigB2_beta_profiles_all20.pdf', 'FigB3_KAP_beta_norm_identity.pdf', 'FigB4_radial_interval_sensitivity.pdf']
PASS	no_duplicate_figure_formats	[]
PASS	no_manuscript_pdf_or_source	[]
PASS	nonempty_Fig01_KAP_primary	16839
PASS	nonempty_Fig02_GKI_primary	18151
PASS	nonempty_Fig03_Ds_raw_vs_corrected	18011
PASS	nonempty_FigB1_dispersion_profiles_all20	76969
PASS	nonempty_FigB2_beta_profiles_all20	46021
PASS	nonempty_FigB3_KAP_beta_norm_identity	18975
PASS	nonempty_FigB4_radial_interval_sensitivity	22611
PASS	declared_tests_A_to_E_reported_reference	tests_A_to_E_reported_reference.csv
PASS	declared_test_F_reported_reference	test_F_reported_reference.csv
WARN	Synthetic Test A-F rounded reference summaries are not bitwise reproducible because the original random-state arrays were unavailable.
````

All authoritative observational checks pass. The synthetic-reference warning is a declared limitation rather than a failed numerical check.
