# KAP-GKI HST globular-cluster data and code release v1.1.0

This archive contains the derived data, interval-defined kinematic diagnostics,
article tables, vector figure products, validation summaries, and analysis code
associated with **Projected Kinematic Anisotropy and Velocity-Dispersion Gradients in Galactic Globular Clusters: An Interval-Defined Framework from HST Proper Motions**.

## Authoritative numerical state

- 20 Galactic globular clusters and 395 standardized profile rows;
- primary interval: `R <= R_h,l`;
- primary KAP classes: 5 radial, 15 zero-consistent, 0 tangential;
- full-HST-range KAP classes: 7 radial, 13 zero-consistent, 0 tangential;
- primary GKI classes: 18 negative and 2 flat/zero-consistent;
- primary `D_s,corr`: 11 zero and 9 non-zero;
- interval-dependent radial classifications: NGC 6388 and NGC 6441;
- NGC 6388: 31 full-range bins and 13 primary-interval bins.

KAP and GKI are radial-interval dependent. `D_s` and `D_s,corr` are
profile-inspection diagnostics, not physical severity classes. GKI is the
empirical outward slope `d ln(sigma) / d ln(R)` over the stated interval and is
not a standalone IMBH diagnostic.

## Archive policy

The article PDF and manuscript source are intentionally **not** included. The
release contains only data, code, derived tables, vector PDF figures, metadata,
and audit documentation. Original HACKS source files are not redistributed; the
source DOI, URL, retrieval record, checksum, and parent-product inventory are
included under `data/source_inventory/`.

## Structure

- `data/derived/`: standardized 20-cluster profiles, properties, and inclusion audit;
- `data/source_inventory/`: HACKS source record and 57-target parent inventory;
- `results/tables/csv/`: article-aligned machine-readable results;
- `results/tables/latex/`: article-ready LaTeX tables;
- `results/figures/pdf/`: the seven vector PDF manuscript figures only;
- `results/validation/`: point recalculation, reported and rerun uncertainty summaries, jackknife, and declared synthetic references;
- `scripts/python/`: deterministic recalculation, fast fixed-seed resampling, jackknife, figures, and validation;
- `scripts/matlab/`: independent manuscript-figure implementation;
- `docs/`: methods, provenance, data dictionary, manuscript crosswalk, release audit, and Zenodo checklist.

## Quick verification

```bash
python scripts/python/recompute_point_metrics.py
python scripts/python/run_jackknife.py
python scripts/python/run_parametric_resampling.py --n 10000 --seed 20260715
python scripts/python/generate_figures.py
python scripts/python/validate_release.py
```

The first four commands regenerate outputs. The final command verifies the
article-level numerical hierarchy and required package structure.

## Synthetic validation status

The rounded Test A-F values reported in the article are archived as declared
reference summaries. The original random-state information and intermediate
realisation arrays were unavailable when this release was assembled; these
files are therefore not described as bitwise-reproducible stochastic outputs.
The deterministic observational results and fixed-seed parametric rerun are
fully reproducible from the packaged data and scripts.

## Licensing

- original code: MIT License;
- original documentation and derived release tables: CC BY 4.0;
- HACKS source measurements remain under their source terms and CC BY 4.0 attribution requirements.
