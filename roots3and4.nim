import math
import xmath
import strutils
import poly






proc isZero(x:Float,tol=1.0e-9):Bool {.inline,noInit,noSideEffect.}=
  return abs(x)<tol
  
  
    

proc solveCubic*(c3,c2,c1,c0:float , zerotol=1.0e-9):seq[float]=
  
  if isZero(c3): # is this actually a quadric equation or less?
    return solveQuadric(c2,c1,c0,zerotol)
  
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
        
  if isZero(d,zerotol):
    if isZero(q,zerotol): #one triple solution
      result= @[0.0]
    else: #one single and one double solution
      let u=nthRoot(3,-q)
      result= @[2.0*u,-u]
  elif d<0.0: # casus irreducibilis: three real solutions
    let
      phi=1.0/3.0*arccos(-q/sqrt(-cb_p))
      t=2.0*sqrt(-p)
    result= @[t*cos(phi),-t*cos(phi+PI/3.0),-t*cos(phi-PI/3.0)]
  else: # d>0.0 , one real solution
    let
      sqrtd=sqrt(d)
      u= nthRoot(3,sqrtd-q)
      v= -nthRoot(3,sqrtd+q)
    result= @[u+v]

  
  # resubstitute
  for i in 0..high(result):
    result[i]-=sub

proc solveNormQuad(a,b:float,sol:var seq[float],ztol:float)=
  ## Private helper function for solveQuartic, solves
  ## a normalized quadric: x^2+ax+b and puts the
  ## result in `sol`
  let
    p = -0.5*a
    d = p * p - b;

  if isZero(d,ztol):
    sol.add(p) #merge close solutions or find 'near zero' solution
  elif d<0.0:
    return
  else: # d>0.0
    let sqrtd=sqrt(d)
    sol.add(p-sqrtd)
    sol.add(p+sqrtd)


proc solveQuartic*(c4,c3,c2,c1,c0:float , zerotol=1.0e-9):seq[float]=

  if isZero(c4): # is this actually a cubic equation or less?
    return solveQuadric(c2,c1,c0,zerotol)

  let  # normal form: x^4 + Ax^3 + Bx^2 + Cx + D = 0
    a=c3/c4
    b=c2/c4
    c=c1/c4
    d=c0/c4
    sqa=a*a
    p= -3.0/8.0*sqa+b
    q = sqa*a/8-a*b/2+c
    r= -3.0*sqa*sqa/256+sqa*b/16-a*c/4+d
    sub=0.25*a
  
  if isZero(r,zerotol):
    # no absolute term: y(y^3 + py + q) = 0
    result=solveCubic(1.0,0.0,p,q)
    result.add(0.0) 
  else:
    let
      crt=solveCubic(1,-1.0/2.0*p,-r,1.0/2.0*r*p-1.0/8.0*q*q) # solve the resolvent cubic...
      z=crt[0] # ... and take the one real solution ...
      # ... to build two quadric equations:
    
    var    
      u = z * z - r
      v = 2.0 * z - p
    
    result= @[]


    if (u.isZero):
        u = 0.0
    elif u > 0.0:
        u = sqrt(u)
    else:
        return

    if v.isZero:
        v = 0.0
    elif v > 0.0:
        v = sqrt(v)*sgn(q)
    else:
        return
    
    solveNormQuad(v,z-u,result,zerotol)
    solveNormQuad(-v,z+u,result,zerotol)

  # resubstitute
  for i in 0..high(result):
    result[i]-=sub
    


when isMainModule:
  
  
  
  
  
  var s=solveQuartic(0,0,0,1,-1)
  
  echo "<start>"
  for i in s.items:
    echo formatFloat(i,ffDefault,0)
  echo "<end>"


  echo nthRoot(2,27)*nthRoot(2,27)
  
  
  
  discard stdin.readline
  
