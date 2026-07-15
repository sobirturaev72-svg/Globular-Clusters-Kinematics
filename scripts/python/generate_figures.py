#!/usr/bin/env python3
"""Regenerate the seven manuscript figures as vector PDF files only."""
from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'results/figures/pdf'; OUT.mkdir(parents=True,exist_ok=True)
N=pd.read_csv(ROOT/'results/tables/csv/metrics_primary_R_le_Rh.csv')
F=pd.read_csv(ROOT/'results/tables/csv/metrics_full_HST.csv')
P=pd.read_csv(ROOT/'data/derived/profiles_hacks_20clusters.csv')

def short(c): return 'NGC '+str(int(str(c).replace('NGC','')))
def save(fig,name):
    fig.savefig(OUT/f'{name}.pdf',bbox_inches='tight')
    plt.close(fig)

def identity(ax,values):
    lo=float(np.nanmin(values)); hi=float(np.nanmax(values)); pad=.08*max(hi-lo,.05)
    lo-=pad; hi+=pad; ax.plot([lo,hi],[lo,hi],'--',linewidth=.9); ax.set_xlim(lo,hi); ax.set_ylim(lo,hi)

# Figure 1
T=N.sort_values('KAP'); x=np.arange(len(T)); fig,ax=plt.subplots(figsize=(7.2,3.7))
ax.bar(x,T.KAP,edgecolor='black',linewidth=.7); ax.errorbar(x,T.KAP,yerr=T.KAP_err_analytic,fmt='none',capsize=3)
ax.axhline(0,linewidth=1); ax.set_ylim(-.12,.08); ax.set_xticks(x,labels=[short(c) for c in T.cluster],rotation=45,ha='right')
ax.set_ylabel('KAP (Global Kinematic Anisotropy Parameter)'); ax.set_xlabel('Globular cluster'); ax.grid(alpha=.3)
save(fig,'Fig01_KAP_primary')
# Figure 2
fig,ax=plt.subplots(figsize=(7.2,3.7)); ax.bar(x,T.GKI,edgecolor='black',linewidth=.7); ax.errorbar(x,T.GKI,yerr=T.GKI_err,fmt='none',capsize=3)
ax.axhline(0,linewidth=1); ax.set_ylim(-.30,.05); ax.set_xticks(x,labels=[short(c) for c in T.cluster],rotation=45,ha='right')
ax.set_ylabel('GKI (Global Kinematic Index)'); ax.set_xlabel('Globular cluster'); ax.set_title('Velocity-dispersion gradients for 20 globular clusters'); ax.grid(alpha=.3)
save(fig,'Fig02_GKI_primary')
# Figure 3
T3=N.sort_values('Ds_raw',ascending=False); y=np.arange(len(T3)); fig,ax=plt.subplots(figsize=(7.2,4.4))
ax.barh(y,T3.Ds_raw,label=r'Raw $D_s$'); ax.barh(y,T3.Ds_corr,height=.45,label=r'Noise-aware $D_{s,\mathrm{corr}}$')
ax.set_yticks(y,labels=[short(c) for c in T3.cluster]); ax.invert_yaxis(); ax.set_xlim(0,4.2); ax.set_xlabel('Anisotropy-profile scatter diagnostic'); ax.legend(); ax.grid(axis='x',alpha=.3)
save(fig,'Fig03_Ds_raw_vs_corrected')
# Figure B1
clusters=sorted(P.cluster.unique()); fig,axs=plt.subplots(5,4,figsize=(8.3,10.1))
for ax,c in zip(axs.flat,clusters):
    d=P[P.cluster.eq(c)].sort_values('R_arcsec'); rh=float(np.median(d.R_arcsec/d.R_over_rh_l))
    ax.errorbar(d.R_arcsec,d.sigma,yerr=d.err_sigma,fmt='.-',ms=2,lw=.7,label=r'$\sigma$')
    ax.errorbar(d.R_arcsec,d.sigma_r,yerr=d.err_sigma_r,fmt='o-',ms=2,lw=.7,label=r'$\sigma_r$')
    ax.errorbar(d.R_arcsec,d.sigma_t,yerr=d.err_sigma_t,fmt='s-',ms=2,lw=.7,label=r'$\sigma_t$')
    ax.axvline(rh,ls='--',lw=.7); ax.set_xscale('log'); ax.set_title(short(c),fontsize=8); ax.tick_params(labelsize=7); ax.grid(alpha=.25)
    ax.set_xlabel('Radius (arcsec)',fontsize=7); ax.set_ylabel(r'Dispersion (mas yr$^{-1}$)',fontsize=7)
handles,labels=axs.flat[0].get_legend_handles_labels(); fig.legend(handles,labels,loc='upper center',ncol=3,frameon=False); fig.tight_layout(rect=(0,0,1,.97))
save(fig,'FigB1_dispersion_profiles_all20')
# Figure B2
fig,axs=plt.subplots(5,4,figsize=(8.3,10.1),sharey=True)
for ax,c in zip(axs.flat,clusters):
    d=P[P.cluster.eq(c)].sort_values('R_arcsec'); rh=float(np.median(d.R_arcsec/d.R_over_rh_l))
    beta=1-d.sigma_t**2/d.sigma_r**2
    eb=np.sqrt((2*d.sigma_t*d.err_sigma_t/d.sigma_r**2)**2+(2*d.sigma_t**2*d.err_sigma_r/d.sigma_r**3)**2)
    ax.errorbar(d.R_arcsec,beta,yerr=eb,fmt='o-',ms=2,lw=.7); ax.axhline(0,lw=.7); ax.axvline(rh,ls='--',lw=.7)
    ax.set_xscale('log'); ax.set_title(short(c),fontsize=8); ax.tick_params(labelsize=7); ax.grid(alpha=.25); ax.set_xlabel('Radius (arcsec)',fontsize=7); ax.set_ylabel(r'$\beta(R)$',fontsize=7)
fig.tight_layout(); save(fig,'FigB2_beta_profiles_all20')
# Figure B3: relation to normalized anisotropy contrast, full range.
fig,axs=plt.subplots(1,2,figsize=(7.2,3.45))
axs[0].scatter(F.minus_beta_norm_wmean,F.KAP); identity(axs[0],np.r_[F.minus_beta_norm_wmean,F.KAP]); axs[0].set_xlabel(r'$-\langle\beta_{\rm norm}\rangle_w$'); axs[0].set_ylabel('KAP'); axs[0].grid(alpha=.3)
axs[1].scatter(F.minus_beta_norm_dispersionweighted,F.KAP); identity(axs[1],np.r_[F.minus_beta_norm_dispersionweighted,F.KAP]); axs[1].set_xlabel(r'Dispersion-scale-weighted $-\beta_{\rm norm}$'); axs[1].set_ylabel('KAP'); axs[1].grid(alpha=.3)
md=float(np.max(np.abs(F.KAP-F.minus_beta_norm_dispersionweighted))); axs[1].text(.04,.94,f'max |difference| = {md:.1e}',transform=axs[1].transAxes,va='top',fontsize=8)
fig.tight_layout(); save(fig,'FigB3_KAP_beta_norm_identity')
# Figure B4: interval sensitivity.
M=F[['cluster','KAP','KAP_err_analytic','KAP_class','GKI','GKI_err']].merge(N[['cluster','KAP','KAP_err_analytic','KAP_class','GKI','GKI_err']],on='cluster',suffixes=('_full','_primary'))
changed=M.KAP_class_full.ne(M.KAP_class_primary)
fig,axs=plt.subplots(1,2,figsize=(7.2,3.45))
for ax,xv,yv,xe,ye,xlab,ylab in [
    (axs[0],M.KAP_full,M.KAP_primary,M.KAP_err_analytic_full,M.KAP_err_analytic_primary,'Full-range KAP',r'KAP in $R\leq R_{\rm h,l}$'),
    (axs[1],M.GKI_full,M.GKI_primary,M.GKI_err_full,M.GKI_err_primary,'Full-range GKI',r'GKI in $R\leq R_{\rm h,l}$')]:
    ax.errorbar(xv,yv,xerr=xe,yerr=ye,fmt='none',alpha=.5)
    if ax is axs[0]:
        ax.scatter(xv[~changed],yv[~changed],label='Same KAP significance status')
        ax.scatter(xv[changed],yv[changed],marker='s',label='Radial only over full HST range')
    else: ax.scatter(xv,yv)
    identity(ax,np.r_[xv,yv]); ax.set_xlabel(xlab); ax.set_ylabel(ylab); ax.grid(alpha=.3)
for c in ['NGC6388','NGC6441']:
    i=M.index[M.cluster.eq(c)][0]
    for ax,xv,yv in [(axs[0],M.KAP_full,M.KAP_primary),(axs[1],M.GKI_full,M.GKI_primary)]: ax.annotate(short(c),(xv[i],yv[i]),xytext=(3,4),textcoords='offset points',fontsize=7)
axs[0].legend(fontsize=7); fig.tight_layout(); save(fig,'FigB4_radial_interval_sensitivity')
print('Wrote manuscript PDF figures to',OUT)
