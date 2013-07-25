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
  ## Creates a new matrix. 
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

proc `&`(a,b:TMatrix3d):TMatrix3d {.noinit.} =
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


proc rotate(axis:TVector3d,org:TPoint3d,angle:float):TMatrix3d {.noInit.}=
  
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
    uvomc-wsi, v2+(u2*w2)*cs, vwomc+usi, 0.0,
    uwomc+vsi, vwomc-usi, w2+(u2+v2)*cs, 0.0,
    (a*(v2+w2)-u*(b*v+c*w))*omc+(b*w-c*v)*si,
    (b*(u2+w2)-v*(a*u+c*w))*omc+(c*u-a*w)*si,
    (c*(u2+v2)-w*(a*u+b*v))*omc+(a*v-b*u)*si,1.0)
    
    
proc mirror(planeperp:TVector3d):TMatrix3d {.noInit.}=
  
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


proc mirror(planeperp:TVector3d,org:TPoint3d):TMatrix3d {.noInit.}=


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

  
    
proc `$`(m:TMatrix3d):string=
  return rtos(m.ax) & "," & rtos(m.ay) & "," &rtos(m.az) & "," & rtos(m.aw) &
    "\n" & rtos(m.bx) & "," & rtos(m.by) & "," &rtos(m.bz) & "," & rtos(m.bw) &
    "\n" & rtos(m.cx) & "," & rtos(m.cy) & "," &rtos(m.cz) & "," & rtos(m.cw) &
    "\n" & rtos(m.tx) & "," & rtos(m.ty) & "," &rtos(m.tz) & "," & rtos(m.tw)
    

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

proc `$`(p:TPoint3d):string=
  return rtos(p.x) & "," & rtos(p.y) & "," & rtos(p.z)
  


if isMainModule:
  var p=Point3d(10.0,4,0);
  
  #echo(rotate(ZAXIS,point3d(0,0,0),PI*0.5))
  
  p = p&mirror(YAXIS,Point3d(5,5,0))
  
  echo p
  
  discard readline(stdin)
  
  