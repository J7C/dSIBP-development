"""Independent fixed Gauss-Legendre check, limited by binary64 node generation.

This is a diagnostic of order-one discrepancies, NOT an arbitrary-precision
certificate. No Bessel series, exact moments, native DE or boundary are used.
Changes of variables v=y^4, s=w^4 smooth the integrable logarithmic endpoints.
"""
import json,pathlib,time,argparse
import numpy as np
import mpmath as m

def integrate(n,rho=10):
    m.mp.dps=25
    nodes,weights=np.polynomial.legendre.leggauss(n)
    pts=[(m.mpf(str((x+1)/2)),m.mpf(str(w/2))) for x,w in zip(nodes,weights)]
    vmax=m.mpf(12);ym=vmax**m.mpf('.25');nu=m.j/4;x2=m.sqrt(2);phase=x2**(-2*nu)
    ans=0;control=0
    for yn,wy in pts:
        y=ym*yn;v=y**4;jv=4*y**3*ym
        large=m.hankel2(nu,-m.j*v)*m.hankel2(nu,-m.j*x2*v)
        for w,ww in pts:
            s=w**4;js=4*w**3;t=s*v
            weight=wy*ww*jv*js*2*v**3*s*m.exp(-rho*v*(1+s))
            control+=weight
            ans+=weight*m.hankel1(nu,-m.j*t)*m.hankel1(nu,-m.j*x2*t)*large
    return phase*ans,control

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--orders',nargs='+',type=int,default=[32,64]);args=ap.parse_args();records=[]
    for n in args.orders:
        st=time.perf_counter();v,c=integrate(n)
        row=dict(order=n,seconds=time.perf_counter()-st,pp=dict(real=m.nstr(v.real,20),imag=m.nstr(v.imag,20)),control=m.nstr(c,20),control_absolute_error=m.nstr(abs(c-m.mpf('0.0001')),12),node_precision='binary64; no >14-digit certification',v_cutoff='12')
        records.append(row);print(json.dumps(row),flush=True)
        (pathlib.Path(__file__).resolve().parents[1]/'results/bubble_fixed_quadrature.json').write_text(json.dumps(records,indent=2),encoding='utf-8')
