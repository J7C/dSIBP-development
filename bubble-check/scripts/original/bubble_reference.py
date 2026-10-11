"""Independent fixed-momentum SK time integral, implemented this session.
No MadStree/FlintNDE imports. Rotate t=-tau to -i*u at + vertices,
+i*u at - vertices. Expand Hankel functions into J_{+nu}, J_{-nu};
integrate each coefficient over the positive quadrant or ordered simplex.
Absolute interchange valid for rho > x1+x2; this includes [2.8,10].
Tail remains to be controlled separately: reported Acb balls bound rounding only.
"""
import argparse,json,pathlib,time,math
from flint import acb,arb,ctx

def ordered_moment(a,b,rho):
    # ∫v=0∞ ∫u=0^v u^a v^b exp[-rho(u+v)] du dv.
    aa=a+1;bb=b+1;z=acb(1)/2
    return (aa+bb).gamma()/rho**(aa+bb)*z**aa/aa*z.hypgeom_2f1(aa,1-bb,aa+1)

def hankel_pair(branch,rotation,nmax,nu,x1,x2):
    ii=acb(0,1);pi=acb.pi();den=ii*(pi*nu).sin()
    weights={-1:1/den,1:-( -ii*pi*nu).exp()/den} if branch==1 else {-1:-1/den,1:(ii*pi*nu).exp()/den}
    js={}
    for k,x in enumerate((x1,x2)):
        for sign in (-1,1):
            order=sign*nu;z=rotation*x
            seq=[(z/2)**order/(order+1).gamma()]
            for n in range(1,nmax+1):seq.append(seq[-1]*(-z*z/4)/(n*(order+n)))
            js[k,sign]=seq
    coeff={s:[acb(0) for _ in range(nmax+1)] for s in (-2,0,2)}
    for s1 in (-1,1):
        for s2 in (-1,1):
            for n in range(nmax+1):
                coeff[s1+s2][n]+=weights[s1]*weights[s2]*sum((js[0,s1][j]*js[1,s2][n-j] for j in range(n+1)),acb(0))
    return coeff

def kernel_tail_bound(rho,nmax):
    """Absolute tail majorant for the four-branch K, not just adjacent-order change.
    |(1+i*mu)_n| >= n!. Convolution is bounded by (x1+x2)^(2n)/(n!)^2.
    Integrated majorant T_n=P*(2n+1)!/(n!)^2*(S/(2rho))^(2n)/rho^2.
    T_(n+1)/T_n=(1+1/(2(n+1)))*(S/rho)^2 decreases. Ordered
    domains are bounded by the full quadrant. Both omitted index tails counted.
    """
    rho=arb(rho);x1=acb(1);x2=acb(2).sqrt();nu=acb(0,1)/4;ii=acb(0,1);pi=acb.pi()
    z=((x1+x2).real/rho)**2
    if not z<1:raise ValueError('absolute convergence requires rho>x1+x2')
    n=nmax+1;ratio=z*(1+arb(1)/(2*(n+1)))
    if not ratio<1:raise ValueError('increase truncation to bound geometric tail')
    unit_tail=arb(math.factorial(2*n+1))/arb(math.factorial(n))**2*(z/4)**n/rho**2/(1-ratio)
    unit_full=(1-z)**(-arb(3)/2)/rho**2
    def pref(branch,c):
        den=ii*(pi*nu).sin()
        weights={-1:1/den,1:-(-ii*pi*nu).exp()/den} if branch==1 else {-1:-1/den,1:(ii*pi*nu).exp()/den}
        return sum((abs(weights[a]*weights[b]*(c*x1/2)**(a*nu)*(c*x2/2)**(b*nu)/(1+a*nu).gamma()/(1+b*nu).gamma()) for a in (-1,1) for b in (-1,1)),arb(0))
    pp1,pp2,mm1,mm2=pref(1,-ii),pref(2,-ii),pref(2,ii),pref(1,ii)
    # Each same-sign branch has two chambers; pm,mp factorize.
    return (4*pp1*pp2+4*mm1*mm2+4*pp2*mm2)*unit_tail*unit_full

def evaluate(rho,nmax,dps=80):
    ctx.dps=dps;ctx.threads=1;rho=acb(rho);nu=acb(0,1)/4;ii=acb(0,1)
    x1=acb(1);x2=acb(2).sqrt();constant=(x1*x2)**(-2*nu)
    hm=hankel_pair(2,-ii,nmax,nu,x1,x2)
    hp=hankel_pair(1,ii,nmax,nu,x1,x2)
    hpp=hankel_pair(1,-ii,nmax,nu,x1,x2)
    hmm=hankel_pair(2,ii,nmax,nu,x1,x2)
    def single(c):
        return sum((v*(2+s*nu+2*n).gamma()/rho**(2+s*nu+2*n) for s,seq in c.items() for n,v in enumerate(seq)),acb(0))
    cross=constant*single(hm)*single(hp)
    pp=acb(0);mm=acb(0)
    for s in (-2,0,2):
        for t in (-2,0,2):
            for n in range(nmax+1):
                for m in range(nmax+1):
                    moment=ordered_moment(1+s*nu+2*n,1+t*nu+2*m,rho)
                    pp+=hpp[s][n]*hm[t][m]*moment
                    mm+=hmm[s][n]*hp[t][m]*moment
    pp*=2*constant;mm*=2*constant
    return dict(pp=pp,pm=cross,mp=cross,mm=mm,K=-pp+2*cross-mm)

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--rho',default='10');ap.add_argument('--order',type=int,default=16);ap.add_argument('--dps',type=int,default=80);ap.add_argument('--output',required=True);args=ap.parse_args()
    st=time.perf_counter();vals=evaluate(args.rho,args.order,args.dps)
    bound=kernel_tail_bound(args.rho,args.order)
    d=dict(rho=args.rho,order=args.order,dps=args.dps,seconds=time.perf_counter()-st,rounding_only_balls={k:str(v) for k,v in vals.items()},absolute_K_truncation_bound=str(bound),truncation_certified=all(v.is_finite() for v in vals.values()),method='Own Wick-rotated time integral via Hankel/Bessel series and exact ordered moments')
    pathlib.Path(args.output).write_text(json.dumps(d,indent=2),encoding='utf-8');print(json.dumps(d,indent=2))
