#!/usr/bin/env python3
"""Recompute point diagnostics from the packaged 20-cluster profile table."""
from pathlib import Path
import argparse, math
import numpy as np
import pandas as pd
from scipy.stats import spearmanr

EPS=0.01

def kap(df):
    sr=df.sigma_r.to_numpy(float); st=df.sigma_t.to_numpy(float)
    er=df.err_sigma_r.to_numpy(float); et=df.err_sigma_t.to_numpy(float)
    a=st**2-sr**2; b=st**2+sr**2
    va=(2*st*et)**2+(2*sr*er)**2; w=1/va
    k=np.sum(w*a)/np.sum(w*b); A=np.sum(w*a); B=np.sum(w*b)
    vA=np.sum(w*w*va); vB=vA
    cAB=np.sum(w*w*((2*st*et)**2-(2*sr*er)**2))
    vk=vA/B**2+k*k*vB/B**2-2*k*cAB/B**2
    return k,math.sqrt(max(vk,0.0))

def gki(df):
    R=df.R_arcsec.to_numpy(float); s=df.sigma.to_numpy(float); e=df.err_sigma.to_numpy(float)
    x=np.log(R); y=np.log(s); dy=e/s; w=1/dy**2
    X=np.column_stack([np.ones(len(x)),x]); M=(X.T*w)@X
    th=np.linalg.solve(M,(X.T*w)@y); cov=np.linalg.inv(M)
    yh=X@th; resid=y-yh; chi2=np.sum(w*resid**2); dof=max(len(x)-2,1)
    ybar=np.average(y,weights=w); ss=np.sum(w*(y-ybar)**2); rss=np.sum(w*resid**2)
    r2=1-rss/ss if ss>0 else np.nan; dbic=(chi2+2*np.log(len(x)))-(ss+np.log(len(x)))
    return th[1],math.sqrt(cov[1,1]),r2,chi2/dof,dbic

def metrics(df):
    df=df.sort_values('R_arcsec'); k,ke=kap(df); g,ge,r2,c2,db=gki(df)
    sr=df.sigma_r.to_numpy(float); st=df.sigma_t.to_numpy(float)
    er=df.err_sigma_r.to_numpy(float); et=df.err_sigma_t.to_numpy(float)
    beta=1-st**2/sr**2
    eb=np.sqrt((2*st*et/sr**2)**2+(2*st**2*er/sr**3)**2)
    vb=np.var(beta,ddof=1)
    ds=vb/(abs(k)+EPS); dsc=max(vb-np.mean(eb**2),0)/(abs(k)+EPS)
    return dict(n_bins=len(df),Rmin_arcsec=df.R_arcsec.min(),Rmax_arcsec=df.R_arcsec.max(),
      Rmin_Rh=df.R_over_rh_l.min(),Rmax_Rh=df.R_over_rh_l.max(),KAP=k,KAP_err_analytic=ke,
      KAP_SNR=abs(k)/ke,KAP_class='RADIAL' if k<=-2*ke else ('TANGENTIAL' if k>=2*ke else 'ISOTROPIC'),
      GKI=g,GKI_err=ge,GKI_SNR=abs(g)/ge,GKI_sign_class='NEGATIVE' if g<=-2*ge else ('POSITIVE' if g>=2*ge else 'CONSISTENT_WITH_ZERO'),
      R2_GKI=r2,chi2nu_GKI=c2,delta_BIC_slope_minus_const=db,beta_min=beta.min(),beta_max=beta.max(),
      beta_var=vb,mean_beta_err2=np.mean(eb**2),Ds_raw=ds,Ds_corr=dsc)

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--root',default=str(Path(__file__).resolve().parents[2])); args=ap.parse_args()
    root=Path(args.root); data=pd.read_csv(root/'data/derived/profiles_hacks_20clusters.csv')
    out=root/'results/validation/recomputed_point_metrics'; out.mkdir(parents=True,exist_ok=True)
    masks={'full_HST':np.ones(len(data),dtype=bool),'primary_R_le_Rh':data.R_over_rh_l<=1,
           'sensitivity_R_0p1_to_Rh':(data.R_over_rh_l>=0.1)&(data.R_over_rh_l<=1)}
    for label,mask in masks.items():
        rows=[]
        for c,d in data[mask].groupby('cluster',sort=True):
            m=metrics(d); m['cluster']=c; rows.append(m)
        pd.DataFrame(rows).to_csv(out/f'{label}.csv',index=False)
    print('Point diagnostics written to',out)
if __name__=='__main__': main()
