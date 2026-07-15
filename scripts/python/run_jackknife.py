#!/usr/bin/env python3
"""Leave-one-bin-out sensitivity analysis for KAP and GKI."""
from pathlib import Path
import numpy as np
import pandas as pd
from recompute_point_metrics import metrics
ROOT=Path(__file__).resolve().parents[2]
P=pd.read_csv(ROOT/'data/derived/profiles_hacks_20clusters.csv')
outdir=ROOT/'results/validation/jackknife'; outdir.mkdir(parents=True,exist_ok=True)
for label,mask in [('primary_R_le_Rh',P.R_over_rh_l<=1),('full_HST',np.ones(len(P),dtype=bool))]:
    rows=[]; summary=[]
    for c,d in P[mask].groupby('cluster',sort=True):
        d=d.sort_values('R_arcsec').reset_index(drop=True); base=metrics(d); kval=[]; gval=[]
        for j in range(len(d)):
            m=metrics(d.drop(index=j)); kval.append(m['KAP']); gval.append(m['GKI'])
            rows.append({'cluster':c,'omitted_bin':int(d.loc[j,'bin']),'KAP':m['KAP'],'GKI':m['GKI']})
        kval=np.array(kval); gval=np.array(gval); n=len(d)
        kse=np.sqrt((n-1)/n*np.sum((kval-kval.mean())**2)); gse=np.sqrt((n-1)/n*np.sum((gval-gval.mean())**2))
        summary.append({'cluster':c,'n_bins':n,'KAP_full_bin':base['KAP'],'KAP_jackknife_se':kse,'KAP_max_abs_change':np.max(np.abs(kval-base['KAP'])),'GKI_full_bin':base['GKI'],'GKI_jackknife_se':gse,'GKI_max_abs_change':np.max(np.abs(gval-base['GKI']))})
    pd.DataFrame(rows).to_csv(outdir/f'{label}_realisations.csv',index=False); pd.DataFrame(summary).to_csv(outdir/f'{label}_summary.csv',index=False)
print('Jackknife outputs written to',outdir)
