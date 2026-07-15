#!/usr/bin/env python3
"""Fast fixed-seed parametric Gaussian rerun; reported article summaries are not overwritten."""
from pathlib import Path
import argparse
import numpy as np
import pandas as pd
ROOT=Path(__file__).resolve().parents[2]

def positive_draw(mu,err,n,rng):
    x=mu[None,:]+rng.normal(size=(n,len(mu)))*err[None,:]
    bad=x<=0
    while np.any(bad):
        ii,jj=np.where(bad); x[ii,jj]=mu[jj]+rng.normal(size=len(ii))*err[jj]; bad=x<=0
    return x

def simulate(df,n,rng):
    R=df.R_arcsec.to_numpy(float); x=np.log(R)
    s0=df.sigma.to_numpy(float); es=df.err_sigma.to_numpy(float)
    r0=df.sigma_r.to_numpy(float); er=df.err_sigma_r.to_numpy(float)
    t0=df.sigma_t.to_numpy(float); et=df.err_sigma_t.to_numpy(float)
    s=positive_draw(s0,es,n,rng); r=positive_draw(r0,er,n,rng); t=positive_draw(t0,et,n,rng)
    a=t*t-r*r; b=t*t+r*r; va=(2*t*et)**2+(2*r*er)**2; w=1/va
    kap=(w*a).sum(1)/(w*b).sum(1)
    y=np.log(s); wg=(s/es)**2; S=wg.sum(1); Sx=(wg*x).sum(1); Sy=(wg*y).sum(1); Sxx=(wg*x*x).sum(1); Sxy=(wg*x*y).sum(1)
    gki=(S*Sxy-Sx*Sy)/(S*Sxx-Sx*Sx)
    beta=1-t*t/(r*r); vb=np.var(beta,axis=1,ddof=1); eb2=(2*t*et/r**2)**2+(2*t*t*er/r**3)**2
    ds=vb/(np.abs(kap)+.01); dsc=np.maximum(vb-eb2.mean(1),0)/(np.abs(kap)+.01)
    out={}
    for key,arr in [('KAP',kap),('GKI',gki),('Ds_raw',ds),('Ds_corr',dsc)]:
        out[key+'_rerun_std']=np.std(arr,ddof=1); out[key+'_rerun_p16']=np.quantile(arr,.16); out[key+'_rerun_p84']=np.quantile(arr,.84); out[key+'_rerun_p2p5']=np.quantile(arr,.025); out[key+'_rerun_p97p5']=np.quantile(arr,.975)
    return out

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--n',type=int,default=10000); ap.add_argument('--seed',type=int,default=20260715); args=ap.parse_args()
    P=pd.read_csv(ROOT/'data/derived/profiles_hacks_20clusters.csv'); outdir=ROOT/'results/validation/parametric_resampling/fixed_seed_rerun'; outdir.mkdir(parents=True,exist_ok=True)
    rng=np.random.default_rng(args.seed)
    for label,mask in [('primary_R_le_Rh',P.R_over_rh_l<=1),('full_HST',np.ones(len(P),dtype=bool))]:
        rows=[]
        for c,d in P[mask].groupby('cluster',sort=True):
            row={'cluster':c,'n_realisations':args.n,'seed':args.seed,'status':'independent_fixed_seed_rerun'}; row.update(simulate(d.sort_values('R_arcsec'),args.n,rng)); rows.append(row)
        pd.DataFrame(rows).to_csv(outdir/f'{label}.csv',index=False)
    print('Wrote fixed-seed rerun to',outdir)
if __name__=='__main__': main()
