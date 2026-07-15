#!/usr/bin/env python3
from pathlib import Path
import sys, json
import pandas as pd
import numpy as np
ROOT=Path(__file__).resolve().parents[2]
P=pd.read_csv(ROOT/'data/derived/profiles_hacks_20clusters.csv')
N=pd.read_csv(ROOT/'results/tables/csv/metrics_primary_R_le_Rh.csv')
F=pd.read_csv(ROOT/'results/tables/csv/metrics_full_HST.csv')
I=pd.read_csv(ROOT/'data/source_inventory/hacks_parent_vdisp_inventory.csv')
checks=[]; warnings=[]
def ck(name,cond,detail): checks.append((name,bool(cond),detail))
ck('version',(ROOT/'VERSION').read_text().strip()=='1.1.0',(ROOT/'VERSION').read_text().strip())
ck('cluster_count',P.cluster.nunique()==20,P.cluster.nunique())
ck('profile_rows',len(P)==395,len(P))
ck('parent_target_inventory',I.cluster.nunique()==57,I.cluster.nunique())
ck('ngc6388_full_bins',sum(P.cluster.eq('NGC6388'))==31,sum(P.cluster.eq('NGC6388')))
ck('ngc6388_primary_bins',sum(P.cluster.eq('NGC6388')&(P.R_over_rh_l<=1))==13,sum(P.cluster.eq('NGC6388')&(P.R_over_rh_l<=1)))
for label,df,exp in [('primary',N,(5,15,0)),('full',F,(7,13,0))]:
    got=(sum(df.KAP_class.eq('RADIAL')),sum(df.KAP_class.eq('ISOTROPIC')),sum(df.KAP_class.eq('TANGENTIAL'))); ck(label+'_KAP_counts',got==exp,got)
got=(sum(N.GKI_sign_class.eq('NEGATIVE')),sum(N.GKI_sign_class.eq('CONSISTENT_WITH_ZERO'))); ck('primary_GKI_counts',got==(18,2),got)
got=(int(np.isclose(N.Ds_corr,0).sum()),int((N.Ds_corr>0).sum())); ck('primary_Ds_corr_counts',got==(11,9),got)
changes=set(F.loc[F.KAP_class.eq('RADIAL'),'cluster'])-set(N.loc[N.KAP_class.eq('RADIAL'),'cluster']); ck('interval_changes',changes=={'NGC6388','NGC6441'},sorted(changes))
ck('KAP_beta_norm_identity',np.nanmax(np.abs(F.KAP-F.minus_beta_norm_dispersionweighted))<1e-12,float(np.nanmax(np.abs(F.KAP-F.minus_beta_norm_dispersionweighted))))
expected_figs={'Fig01_KAP_primary.pdf','Fig02_GKI_primary.pdf','Fig03_Ds_raw_vs_corrected.pdf','FigB1_dispersion_profiles_all20.pdf','FigB2_beta_profiles_all20.pdf','FigB3_KAP_beta_norm_identity.pdf','FigB4_radial_interval_sensitivity.pdf'}
got_figs={p.name for p in (ROOT/'results/figures/pdf').glob('*.pdf')}; ck('figure_pdf_set',got_figs==expected_figs,sorted(got_figs))
other=list((ROOT/'results/figures').glob('png'))+list((ROOT/'results/figures').glob('eps')); ck('no_duplicate_figure_formats',len(other)==0,[str(x) for x in other])
manuscript_files=[p for p in ROOT.rglob('*') if p.is_file() and (p.suffix.lower()=='.tex' and 'tables/latex' not in p.as_posix() and p.name not in {'DATA_AVAILABILITY_TEXT.tex','FIGURE_CAPTIONS.tex'})]
# LaTeX snippets are allowed; manuscript source names are not.
blocked=[p for p in ROOT.rglob('*') if p.is_file() and ('manuscript' in p.name.lower() and p.suffix.lower() in {'.pdf','.tex'})]
ck('no_manuscript_pdf_or_source',len(blocked)==0,[str(p.relative_to(ROOT)) for p in blocked])
for p in (ROOT/'results/figures/pdf').glob('*.pdf'): ck('nonempty_'+p.stem,p.stat().st_size>5000,p.stat().st_size)
# Historical synthetic references are declared, not silently treated as reproduced.
for p in (ROOT/'results/validation/synthetic_validation').glob('*.csv'):
    d=pd.read_csv(p); ck('declared_'+p.stem,'reproducibility_status' in d.columns and d.reproducibility_status.str.contains('reported_reference_only').all(),p.name)
warnings.append('Synthetic Test A-F rounded reference summaries are not bitwise reproducible because the original random-state arrays were unavailable.')
lines=[f"{'PASS' if ok else 'FAIL'}\t{name}\t{detail}" for name,ok,detail in checks]
lines += [f'WARN\t{w}' for w in warnings]
text='\n'.join(lines)+'\n'; (ROOT/'results/validation/release_validation_report.txt').write_text(text,encoding='utf-8'); print(text,end='')
if not all(ok for _,ok,_ in checks): sys.exit(1)
