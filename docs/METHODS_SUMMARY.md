# Methods summary

## Radial intervals

The primary cluster-to-cluster comparison retains bins with
`R / R_h,l <= 1`. The full available HST profile is a radial-coverage
sensitivity layer. Physical half-light radii are converted to angular radii by
`theta_h,l(arcsec) = 206.265 R_h,l(pc) / d(kpc)`.

## KAP

\[
\mathrm{KAP}=\frac{\sum_i w_i(\sigma_{t,i}^2-\sigma_{r,i}^2)}
{\sum_i w_i(\sigma_{t,i}^2+\sigma_{r,i}^2)},\qquad
w_i=\left[(2\sigma_{t,i}\delta\sigma_{t,i})^2+
(2\sigma_{r,i}\delta\sigma_{r,i})^2\right]^{-1}.
\]

Negative KAP denotes a projected radial squared-dispersion excess; positive KAP
denotes a tangential excess. Analytic propagation evaluates the weights from
the measured profile and holds them fixed. Parametric resampling recomputes the
weights in every realisation and rejects and redraws non-positive dispersions.

Classification uses analytic uncertainty: radial for
`KAP <= -2 delta_KAP`, tangential for `KAP >= 2 delta_KAP`, and
zero-consistent otherwise. The zero-consistent label does not imply local
isotropy in every bin.

## GKI

\[
\mathrm{GKI}=\frac{d\ln\sigma}{d\ln R}.
\]

GKI is estimated by weighted linear regression in log projected radius and log
combined dispersion. Negative, positive, and flat labels use the analytic
slope uncertainty and the same two-sided 2-sigma rule. GKI is an
interval-specific empirical summary, not a global physical power law and not a
standalone IMBH indicator.

## Local projected anisotropy and scatter diagnostics

\[
\beta_i=1-\frac{\sigma_{t,i}^2}{\sigma_{r,i}^2},\qquad
D_s=\frac{\mathrm{Var}(\beta_i)}{|\mathrm{KAP}|+0.01},
\]

\[
D_{s,\mathrm{corr}}=
\frac{\max[\mathrm{Var}(\beta_i)-\langle\delta\beta_i^2\rangle,0]}
{|\mathrm{KAP}|+0.01}.
\]

`Var(beta_i)` is the unweighted sample variance over retained bins. Both scatter
quantities are profile-inspection diagnostics only.
