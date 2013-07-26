#
#
#            Nimrod's Runtime Library
#        (c) Copyright 2013 Robert Persson
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

import math
import strutils

type 
  TMatrix3d=object
    ## Implements a row major 3d matrix, which means
    ## transformations are applied the order they are concatenated.
    ## This matrix is stored as an 4x4 matrix:
    ## [ ax ay az aw ]
    ## [ bx by bz bw ]
    ## [ cx cy cz cw ]
    ## [ tx ty tz tw ]
    ax*,ay*,az*,aw*,  bx*,by*,bz*,bw*,  cx*,cy*,cz*,cw*,  tx*,ty*,tz*,tw*:float
  TPoint3d* = object
    ## Implements a non-homegeneous 2d point stored as 
    ## an `x` , `y` and `z` coordinate.
    x*,y*,z*:float
  TVector3d* = object 
    ## Implements a 3d **direction vector** stored as 
    ## an `x` , `y` and `z` coordinate. Direction vector means, 
    ## that when transforming a vector with a matrix, the translational
    ## part of the matrix is ignored.
    x*,y*,z*:float



# Some forward declarations...
proc matrix3d*(ax,ay,az,aw,bx,by,bz,bw,cx,cy,cz,cw,tx,ty,tz,tw:float):TMatrix3d {.noInit.}
  ## Creates a new 4x4 3d transformation matrix. 
  ## `ax`,`ay`,`az` is the local x axis
  ## `bx`,`by`,`bz` is the local y axis
  ## `tx`,`ty`,`tz` is the translation
proc vector3d*(x,y,z:float):TVector3d {.noInit,inline.}
  ## Returns a new 3d vector (`x`,`y`,`z`)
proc point3d*(x,y,z:float):TPoint3d {.noInit,inline.}
  ## Returns a new 4d point (`x`,`y`,`z`)



let
  IDMATRIX*:TMatrix3d=matrix3d(
    1.0,0.0,0.0,0.0, 
    0.0,1.0,0.0,0.0,
    0.0,0.0,1.0,0.0,
    0.0,0.0,0.0,1.0)
    ## Quick access to a 3d identity matrix
  ORIGO*:TPoint3d=point3d(0.0,0.0,0.0)
    ## Quick access to point (0,0)
  XAXIS*:TVector3d=vector3d(1.0,0.0,0.0)
    ## Quick access to an 3d x-axis unit vector
  YAXIS*:TVector3d=vector3d(0.0,1.0,0.0)
    ## Quick access to an 3d y-axis unit vector
  ZAXIS*:TVector3d=vector3d(0.0,0.0,1.0)
    ## Quick access to an 3d z-axis unit vector



# ***************************************
#     Private utils
# ***************************************

proc rtos(val:float):string=
  return formatFloat(val,ffDefault,0)



# ***************************************
#     TVector3d implementation
# ***************************************
proc Vector3d*(x,y,z:float):TVector3d=
  result.x=x
  result.y=y
  result.z=z


proc sqrLen*(v:TVector3d):float {.inline.}=
  return v.x*v.x+v.y*v.y+v.z*v.z

proc len*(v:TVector3d):float=
  sqrt(v.sqrLen)

proc tryNormalize*(v:var TVector3d):bool= 
  ## Modifies `v` to have a length of 1.0, keeping its angle.
  ## If `v` has zero length (and thus no angle), it is left unmodified and false is
  ## returned, otherwise true is returned.
  let mag=v.len

  if mag==0.0:
    return false

  v.x/=mag
  v.y/=mag
  v.z/=mag
  
  return true


proc normalize*(v:var TVector3d) {.inline.}= 
  ## Modifies `v` to have a length of 1.0, keeping its angle.
  ## If  `v` has zero length, an EDivByZero will be raised.
  if not tryNormalize(v):
    raise newException(EDivByZero,"Cannot normalize zero length vector")

proc dot*(v1,v2:TVector3d):float {.inline.}=
  ## Computes the dot product of two vectors. 
  ## Returns 0.0 if the vectors are perpendicular.
  return v1.x*v2.x+v1.y*v2.y+v1.z*v2.z

proc cross*(v1,v2:TVector3d):TVector3d {.inline.}=
  ## Computes the cross product of two vectors.
  ## The result is a vector which is perpendicular
  ## to the plane of `v1` and `v2`, which means
  ## cross(xaxis,yaxis)=zaxis
  result.x = (v1.y * v2.z) - (v2.y * v1.z)
  result.y = (v1.z * v2.x) - (v2.z * v1.x)
  result.z = (v1.x * v2.y) - (v2.x * v1.y)

proc `&`*(v:TVector3d,m:TMatrix3d):TVector3d=
  let
    newx=m.cx*v.z+m.bx*v.y+m.ax*v.x
    newy=m.cy*v.z+m.by*v.y+m.ay*v.x
  result.z=m.cz*v.z+m.bz*v.y+m.az*v.x
  result.y=newy
  result.x=newx


# ***************************************
#     TPoint3d implementation
# ***************************************
proc Point3d*(x,y,z:float):TPoint3d=
  result.x=x
  result.y=y
  result.z=z
  
proc `&`*(p:TPoint3d,m:TMatrix3d):TPoint3d=
  let
    newx=m.cx*p.z+m.bx*p.y+m.ax*p.x+m.tx
    newy=m.cy*p.z+m.by*p.y+m.ay*p.x+m.ty
  result.z=m.cz*p.z+m.bz*p.y+m.az*p.x+m.tz
  result.y=newy
  result.x=newx

proc `$`*(p:TPoint3d):string=
  return rtos(p.x) & "," & rtos(p.y) & "," & rtos(p.z)
  

# ***************************************
#     TMatrix3d implementation
# ***************************************

proc setElements*(t:var TMatrix3d,ax,ay,az,aw,bx,by,bz,bw,cx,cy,cz,cw,tx,ty,tz,tw:float) {.inline.}=
  ## Sets arbitrary elements in an exisitng matrix.
  t.ax=ax
  t.ay=ay
  t.az=az
  t.aw=aw
  t.bx=bx
  t.by=by
  t.bz=bz
  t.bw=bw
  t.cx=cx
  t.cy=cy
  t.cz=cz
  t.cw=cw
  t.tx=tx
  t.ty=ty
  t.tz=tz
  t.tw=tw

proc matrix3d*(ax,ay,az,aw,bx,by,bz,bw,cx,cy,cz,cw,tx,ty,tz,tw:float):TMatrix3d =
  result.setElements(ax,ay,az,aw,bx,by,bz,bw,cx,cy,cz,cw,tx,ty,tz,tw)

proc `&`*(a,b:TMatrix3d):TMatrix3d {.noinit.} =
  result.setElements(
    a.aw*b.tx+a.az*b.cx+a.ay*b.bx+a.ax*b.ax,
    a.aw*b.ty+a.az*b.cy+a.ay*b.by+a.ax*b.ay,
    a.aw*b.tx+a.az*b.cz+a.ay*b.bz+a.ax*b.az,
    a.aw*b.tw+a.az*b.cw+a.ay*b.bw+a.ax*b.aw,

    a.bw*b.tx+a.bz*b.cx+a.by*b.bx+a.bx*b.ax,
    a.bw*b.ty+a.bz*b.cy+a.by*b.by+a.bx*b.ay,
    a.bw*b.tx+a.bz*b.cz+a.by*b.bz+a.bx*b.az,
    a.bw*b.tw+a.bz*b.cw+a.by*b.bw+a.bx*b.aw,

    a.cw*b.tx+a.cz*b.cx+a.cy*b.bx+a.cx*b.ax,
    a.cw*b.ty+a.cz*b.cy+a.cy*b.by+a.cx*b.ay,
    a.cw*b.tx+a.cz*b.cz+a.cy*b.bz+a.cx*b.az,
    a.cw*b.tw+a.cz*b.cw+a.cy*b.bw+a.cx*b.aw,

    a.tw*b.tx+a.tx*b.cx+a.ty*b.bx+a.tx*b.ax,
    a.tw*b.ty+a.tx*b.cy+a.ty*b.by+a.tx*b.ay,
    a.tw*b.tx+a.tx*b.cz+a.ty*b.bz+a.tx*b.az,
    a.tw*b.tw+a.tx*b.cw+a.ty*b.bw+a.tx*b.aw)


proc scale*(s:float):TMatrix3d {.noInit.} =
  ## Returns a new scaling matrix.
  result.setElements(s,0,0,0, 0,s,0,0, 0,0,s,0, 0,0,0,1)

proc scale*(s:float,org:TPoint3d):TMatrix3d {.noInit.} =
  ## Returns a new scaling matrix using, `org` as scale origin.
  result.setElements(s,0,0,0, 0,s,0,0, 0,0,s,0, 
    org.x-s*org.x,org.y-s*org.y,org.z-s*org.z,1.0)

proc stretch*(sx,sy,sz:float):TMatrix3d {.noInit.} =
  ## Returns new a stretch matrix, which is a
  ## scale matrix with non uniform scale in x and y.
  result.setElements(sx,0,0,0, 0,sy,0,0, 0,0,sz,0, 0,0,0,1)
    
proc stretch*(sx,sy,sz:float,org:TPoint3d):TMatrix3d {.noInit.} =
  ## Returns a new stretch matrix, which is a
  ## scale matrix with non uniform scale in x and y.
  ## `org` is used as stretch origin.
  result.setElements(sx,0,0,0, 0,sy,0,0, 0,0,sz,0, org.x-sx*org.x,org.y-sy*org.y,org.z-sz*org.z,1)
    
proc move*(dx,dy,dz:float):TMatrix3d {.noInit.} =
  ## Returns a new translation matrix.
  result.setElements(1,0,0,0, 0,1,0,0, 0,0,1,0, dx,dy,dz,1)

proc move*(v:TVector3d):TMatrix3d {.noInit.} =
  ## Returns a new translation matrix from a vector.
  result.setElements(1,0,0,0, 0,1,0,0, 0,0,1,0, v.x,v.y,v.z,1)


proc rotate*(axis:TVector3d,angle:float):TMatrix3d {.noInit.}=
  # see PDF document http://inside.mines.edu/~gmurray/ArbitraryAxisRotation/ArbitraryAxisRotation.pdf
  # for how this is computed

  var normax=axis
  if not normax.tryNormalize: #simplifies matrix computation below a lot
    raise newException(EDivByZero,"Cannot rotate around zero length axis")

  let
    cs=cos(angle)
    si=sin(angle)
    omc=1.0-cs
    usi=normax.x*si
    vsi=normax.y*si
    wsi=normax.z*si
    u2=normax.x*normax.x
    v2=normax.y*normax.y
    w2=normax.z*normax.z
    uvomc=normax.x*normax.y*omc
    uwomc=normax.x*normax.z*omc
    vwomc=normax.y*normax.z*omc
    
  result.setElements(
    u2+(1.0-u2)*cs, uvomc+wsi, uwomc-vsi, 0.0,
    uvomc-wsi, v2+(1.0-v2)*cs, vwomc+usi, 0.0,
    uwomc+vsi, vwomc-usi, w2+(1.0-w2)*cs, 0.0,
    0.0,0.0,0.0,1.0)


proc rotateX*(angle:float):TMatrix3d {.noInit.}=
  ## Creates a matrix that rotates around the x-axis with `angle` radians,
  ## which is also called a 'roll' matrix.
  let
    c=cos(angle)
    s=sin(angle)
  result.setElements(
    1,0,0,0,
    0,c,s,0,
    0,-s,c,0,
    0,0,0,1)

proc rotateY*(angle:float):TMatrix3d {.noInit.}=
  ## Creates a matrix that rotates around the y-axis with `angle` radians,
  ## which is also called a 'pitch' matrix.
  let
    c=cos(angle)
    s=sin(angle)
  result.setElements(
    c,0,-s,0,
    0,1,0,0,
    s,0,c,0,
    0,0,0,1)
    
proc rotateZ*(angle:float):TMatrix3d {.noInit.}=
  ## Creates a matrix that rotates around the z-axis with `angle` radians,
  ## which is also called a 'yaw' matrix.
  let
    c=cos(angle)
    s=sin(angle)
  result.setElements(
    c,s,0,0,
    -s,c,0,0,
    0,0,1,0,
    0,0,0,1)
    
proc isUniform*(m:TMatrix3d,tol=1.0e-6):bool=
  ## Checks if the transform is uniform, that is 
  ## perpendicular axes of equal lenght, which means (for example)
  ## it cannot transform a sphere into an ellipsoid.
  ## `tol` is used as tolerance for both equal length comparison 
  ## and perp. comparison.
  
  #dot product=0 means perpendicular coord. system, check xaxis vs yaxis and  xaxis vs zaxis
  if abs(m.ax*m.bx+m.ay*m.by+m.az*m.bz)<=tol and abs(m.ax*m.cx+m.ay*m.cy+m.az*m.cz)<=tol:
    #subtract squared lengths of axes to check if uniform scaling:
    let
      sqxlen=(m.ax*m.ax+m.ay*m.ay+m.az*m.az)
      sqylen=(m.bx*m.bx+m.by*m.by+m.bz*m.bz)
      sqzlen=(m.cx*m.cx+m.cy*m.cy+m.cz*m.cz)
    if abs(sqxlen-sqylen)<=tol and abs(sqxlen-sqzlen)<=tol:
      return true
  return false


proc rotate*(axis:TVector3d,org:TPoint3d,angle:float):TMatrix3d {.noInit.}=
  
  # see PDF document http://inside.mines.edu/~gmurray/ArbitraryAxisRotation/ArbitraryAxisRotation.pdf
  # for how this is computed
  
  var normax=axis
  if not normax.tryNormalize: #simplifies matrix computation below a lot
    raise newException(EDivByZero,"Cannot rotate around zero length axis")
  
  let
    u=normax.x
    v=normax.y
    w=normax.z
    u2=u*u
    v2=v*v
    w2=w*w
    cs=cos(angle)
    omc=1.0-cs
    si=sin(angle)
    a=org.x
    b=org.y
    c=org.z
    usi=u*si
    vsi=v*si
    wsi=w*si
    uvomc=normax.x*normax.y*omc
    uwomc=normax.x*normax.z*omc
    vwomc=normax.y*normax.z*omc
    
  result.setElements(
    u2+(v2+w2)*cs, uvomc+wsi, uwomc-vsi, 0.0,
    uvomc-wsi, v2+(u2+w2)*cs, vwomc+usi, 0.0,
    uwomc+vsi, vwomc-usi, w2+(u2+v2)*cs, 0.0,
    (a*(v2+w2)-u*(b*v+c*w))*omc+(b*w-c*v)*si,
    (b*(u2+w2)-v*(a*u+c*w))*omc+(c*u-a*w)*si,
    (c*(u2+v2)-w*(a*u+b*v))*omc+(a*v-b*u)*si,1.0)
    
proc mirror*(planeperp:TVector3d):TMatrix3d {.noInit.}=
  
  # https://en.wikipedia.org/wiki/Transformation_matrix
  var n=planeperp
  if not n.tryNormalize:
    raise newException(EDivByZero,"Cannot mirror over a plane with a zero length normal")
  
  let
    a=n.x
    b=n.y
    c=n.z
    ab=a*b
    ac=a*c
    bc=b*c
  
  result.setElements(
    1-2*a*a , -2*ab,-2*ac,0,
    -2*ab , 1-2*b*b, -2*bc, 0,
    -2*ac, -2*bc, 1-2*c*c,0,
    0,0,0,1)


proc mirror*(planeperp:TVector3d,org:TPoint3d):TMatrix3d {.noInit.}=
  # constructs a mirror M like the simpler mirror matrix constructor
  # above but premultiplies with the inverse traslation of org
  # and postmultiplies with the translation of org.
  # With some fiddling this becomes reasonably simple:
  var n=planeperp
  if not n.tryNormalize:
    raise newException(EDivByZero,"Cannot mirror over a plane with a zero length normal")
  
  let
    a=n.x
    b=n.y
    c=n.z
    ab=a*b
    ac=a*c
    bc=b*c
    aa=a*a
    bb=b*b
    cc=c*c
    tx=org.x
    ty=org.y
    tz=org.z
  
  result.setElements(
    1-2*aa , -2*ab,-2*ac,0,
    -2*ab , 1-2*bb, -2*bc, 0,
    -2*ac, -2*bc, 1-2*cc,0,
    2*(ac*tz+ab*ty+aa*tx),
    2*(bc*tz+bb*ty+ab*tx),
    2*(cc*tz+bc*ty+ac*tx) ,1)


proc determinant*(m:TMatrix3d):float=
  ## Computes the determinant of matrix `m`.
  
  # This computation is gotten from ratsimp(optimize(determinant(m))) in maxima CAS
  let
    O1=m.cx*m.tw-m.cw*m.tx
    O2=m.cy*m.tw-m.cw*m.ty
    O3=m.cx*m.ty-m.cy*m.tx
    O4=m.cz*m.tw-m.cw*m.tz
    O5=m.cx*m.tz-m.cz*m.tx
    O6=m.cy*m.tz-m.cz*m.ty

  return (O1*m.ay-O2*m.ax-O3*m.aw)*m.bz+
    (-O1*m.az+O4*m.ax+O5*m.aw)*m.by+
    (O2*m.az-O4*m.ay-O6*m.aw)*m.bx+
    (O3*m.az-O5*m.ay+O6*m.ax)*m.bw


proc inverse*(m:TMatrix3d):TMatrix3d {.noInit.}=
  ## Computes the inverse of matrix `m`. If the matrix
  ## determinant is zero, thus not invertible, a EDivByZero
  ## will be raised.
  
  # this computation comes from omtimize(invert(m)) in maxima CAS
  # trying to read this code can cause brain damage
  
  let 
    det=m.determinant
    O2=m.cy*m.tw-m.cw*m.ty
    O3=m.cz*m.tw-m.cw*m.tz
    O4=m.cy*m.tz-m.cz*m.ty
    O5=m.by*m.tw-m.bw*m.ty
    O6=m.bz*m.tw-m.bw*m.tz
    O7=m.by*m.tz-m.bz*m.ty
    O8=m.by*m.cw-m.bw*m.cy
    O9=m.bz*m.cw-m.bw*m.cz
    O10=m.by*m.cz-m.bz*m.cy
    O11=m.cx*m.tw-m.cw*m.tx
    O12=m.cx*m.tz-m.cz*m.tx
    O13=m.bx*m.tw-m.bw*m.tx
    O14=m.bx*m.tz-m.bz*m.tx
    O15=m.bx*m.cw-m.bw*m.cx
    O16=m.bx*m.cz-m.bz*m.cx
    O17=m.cx*m.ty-m.cy*m.tx
    O18=m.bx*m.ty-m.by*m.tx
    O19=m.bx*m.cy-m.by*m.cx

  if det==0.0:
    raise newException(EDivByZero,"Cannot normalize zero length vector")

  result.setElements(
    (m.bw*O4+m.by*O3-m.bz*O2)/det    , (-m.aw*O4-m.ay*O3+m.az*O2)/det,
    (m.aw*O7+m.ay*O6-m.az*O5)/det    , (-m.aw*O10-m.ay*O9+m.az*O8)/det,
    (-m.bw*O12-m.bx*O3+m.bz*O11)/det , (m.aw*O12+m.ax*O3-m.az*O11)/det,
    (-m.aw*O14-m.ax*O6+m.az*O13)/det , (m.aw*O16+m.ax*O9-m.az*O15)/det,
    (m.bw*O17+m.bx*O2-m.by*O11)/det  , (-m.aw*O17-m.ax*O2+m.ay*O11)/det,
    (m.aw*O18+m.ax*O5-m.ay*O13)/det  , (-m.aw*O19-m.ax*O8+m.ay*O15)/det,
    (-m.bx*O4+m.by*O12-m.bz*O17)/det , (m.ax*O4-m.ay*O12+m.az*O17)/det,
    (-m.ax*O7+m.ay*O14-m.az*O18)/det , (m.ax*O10-m.ay*O16+m.az*O19)/det)


proc equals*(m1:TMatrix3d,m2:TMatrix3d,tol=1.0e-6):bool=
  ## Checks if all elements of `m1`and `m2` is equal within
  ## a given tolerance `tol`.
  return 
    abs(m1.ax-m2.ax)<=tol and
    abs(m1.ay-m2.ay)<=tol and
    abs(m1.az-m2.az)<=tol and
    abs(m1.aw-m2.aw)<=tol and
    abs(m1.bx-m2.bx)<=tol and
    abs(m1.by-m2.by)<=tol and
    abs(m1.bz-m2.bz)<=tol and
    abs(m1.bw-m2.bw)<=tol and
    abs(m1.cx-m2.cx)<=tol and
    abs(m1.cy-m2.cy)<=tol and
    abs(m1.cz-m2.cz)<=tol and
    abs(m1.cw-m2.cw)<=tol and
    abs(m1.tx-m2.tx)<=tol and
    abs(m1.ty-m2.ty)<=tol and
    abs(m1.tz-m2.tz)<=tol and
    abs(m1.tw-m2.tw)<=tol

proc `=~`*(m1,m2:TMatrix3d):bool=
  ## Checks if `m1`and `m2` is aproximately equal, using a
  ## tolerance of 1e-6.
  equals(m1,m2)
  
proc transpose*(m:TMatrix3d):TMatrix3d {.noInit.}=
  ## Returns the transpose of `m`
  result.setElements(m.ax,m.bx,m.cx,m.tx,m.ay,m.by,m.cy,m.ty,m.az,m.bz,m.cz,m.tz,m.aw,m.bw,m.cw,m.tw)
  
proc getXAxis*(m:TMatrix3d):TVector3d {.noInit.}=
  ## Gets the local x axis of `m`
  result.x=m.ax
  result.y=m.ay
  result.z=m.az

proc getYAxis*(m:TMatrix3d):TVector3d {.noInit.}=
  ## Gets the local y axis of `m`
  result.x=m.bx
  result.y=m.by
  result.z=m.bz

proc getZAxis*(m:TMatrix3d):TVector3d {.noInit.}=
  ## Gets the local y axis of `m`
  result.x=m.cx
  result.y=m.cy
  result.z=m.cz

    
proc `$`*(m:TMatrix3d):string=
  return rtos(m.ax) & "," & rtos(m.ay) & "," &rtos(m.az) & "," & rtos(m.aw) &
    "\n" & rtos(m.bx) & "," & rtos(m.by) & "," &rtos(m.bz) & "," & rtos(m.bw) &
    "\n" & rtos(m.cx) & "," & rtos(m.cy) & "," &rtos(m.cz) & "," & rtos(m.cw) &
    "\n" & rtos(m.tx) & "," & rtos(m.ty) & "," &rtos(m.tz) & "," & rtos(m.tw)
    


# ***************************************
#     Misc. 3d utilities
# ***************************************

proc arbitraryAxis*(norm:TVector3d):TMatrix3d {.noInit.}=
  ## Computes the rotation matrix that will transform
  ## world z vector into `norm`. The inverse of this matrix
  ## is usefull to tranform a planar 3d object to 2d space.
  ## This is the same algorithm used to interpret DXF files.
  const lim=1.0/64.0
  var ax,ay,az:TVector3d
  if abs(norm.x)<lim and abs(norm.y)<lim:
    ax=cross(YAXIS,norm)
  else:
    ax=cross(ZAXIS,norm)

  ax.normalize()
  ay=cross(norm,ax)
  ay.normalize()
  az=cross(ax,ay)
  
  result.setElements(
    ax.x,ax.y,ax.z,0.0,
    ay.x,ay.y,ay.z,0.0,
    az.x,az.y,az.z,0.0,
    0.0,0.0,0.0,1.0)


if isMainModule:
  var n=vector3d(2,2,2);
  
  #n.normalize()
  echo n
  
  
  var rm=n.arbitraryAxis

  var z=vector3d(0,0,1)
  
  echo z
  
  
  
  z=z&rm
  
  echo z
  
  echo z.len
  
  discard readline(stdin)
  
  