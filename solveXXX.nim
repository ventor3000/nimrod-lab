import math


const EPS=1.0e-9


proc cbrt(x:Float):Float= #TODO: implement
  return 0.0

proc isZero(x:Float,tol=1.0e-9):Float {.inline,noInit.}=
  return abs(x)<tol
  

proc solveNormalizedQuadric(c1,c0:float,sol:var seq[float],ztol:float)=
    double p, q, D;

    # normal form: x^2 + px + q = 0
    let
      p = 0.5*c1
      q = c0
      d = p * p - q;

    if isZero(d,ztol):
      sol.add(-p)
    elif d<0.0:
      return
    else: # d>0.0
      let sqrtd=sqrt(d)
      sol.add(-p+sqrtd)
      sol.add(-p-sqrtd)
      


proc solveCubic(c3,c2,c1,c0:float):seq[float]= #TODO: implement
  
  let
    a=c2/c3
    b=c1/c3
    c=c0/c3
    sqa=a*a
    p=1.0/3.0*(-1.0/3.0*sqa+b)
    q=1.0/2.0*(2.0/27.0*a*sqa-1.0/3.0*a*b+c)
    cbp=p*p*p
    d=q*q+cbp
    sub=1.0/3.0*a
        
  if abs(d)<EPS:
    if abs(q)<EPS: #one triple solution
      result= @[0.0]
    else: #one single and one double solution
      let u=cbrt(-q)
      result= @[2.0*u,-u]
  elif d<0.0: # casus irreducibilis: three real solutions
    let
      phi=1.0/3.0*arccos(-q/sqrt(-cb_p))
      t=2.0*sqrt(-p)
    result= @[t*cos(phi),-t*cos(phi+PI/3.0),-t*cos(phi-PI/3.0)]
  else: # d>0.0 , one real solution
    let
      sqrtd=sqrt(d)
      u= cbrt(sqrtd-q)
      v= -cbrt(sqrtd+q)
    result= @[u+v]

  
  # resubstitute
  for i in 0..high(result):
    result[i]-=sub

      
proc solveQuartic(c4,c3,c2,c1,c0:float):seq[float]=

  #double  coeffs[ 4 ];
  #double  z, u, v, sub;
  #double  A, B, C, D;
  #double  sq_A, p, q, r;
  #int     i, num;

  # normal form: x^4 + Ax^3 + Bx^2 + Cx + D = 0
  let
    a=c3/c4
    b=c2/c4
    c=c1/c4
    d=c0/c4
    sqa=a*a
    p= -3.0/8.0*sqa+b
    q= 1.0/8.0*sqa*a-1.0/2.0*a*b+c
    r= -3.0/256.0*sqa*sqa+1.0/16.0*sqa*b-1.0/4.0*a*c+d
    sub=0.25*a
    
  if abs(r)<EPS:
    # no absolute term: y(y^3 + py + q) = 0
    result=solveCubic(1.0,0.0,p,q)
    s.add(0.0) # TODO: ??sure about this??
  else:
    let
      crt=solveCubic(1,-1.0/2.0*p,-r,1.0/2.0*r*p-1.0/8.0*q*q) # solve the resolvent cubic...
      z=crt[0] # ... and take the one real solution ...
      # ... to build two quadric equations:
      u = z * z - r;
      v = 2.0 * z - p;
    
    result=@[]

    if (u.isZero)
        u = 0.0;
    elif u > 0.0:
        u = sqrt(u)
    else
        return

    if isZero(v):
        v = 0.0
    elif v > 0.0:
        v = sqrt(v);
    else
        return
    
    solveQuadric(1.0, if q<0.0 -v else: v,z-u,result)
    solveQuadric(1.0, if q<0.0 -v else: v,z+u,result)

  # resubstitute
  for i in 0..high(result):
    result[i]-=sub
    

