# Sample-selection scope

The official HACKS all-cluster velocity-dispersion product contains 57 targets
(56 Galactic globular clusters and the open cluster NGC 6791). This release
includes a parent-product inventory and a full inclusion audit for the 20 article
clusters.

The historical source bundle used for the article did not preserve a
machine-readable exclusion reason for every non-selected parent target. The
field `parent_selection_exclusion_reason` is therefore deliberately set to
`not reconstructed in this release` for excluded targets rather than assigning
post-hoc reasons. This avoids overstating the reproducibility of the original
20-of-56 selection step.

The 20 included clusters all have at least five retained primary-interval bins,
finite required dispersions and uncertainties, and positive component
uncertainties in the standardized table.
