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
  ## Returns a new vector (`x`,`y`,`z`)
proc point3d*(x,y,z:float):TPoint3d {.noInit,inline.}
  ## Returns a new point (`x`,`y`,`z`)



let
  IDMATRIX3D*:TMatrix3d=matrix3d(
    1.0,0.0,0.0,0.0, 
    0.0,1.0,0.0,0.0,
    0.0,0.0,1.0,0.0,
    0.0,0.0,0.0,1.0)
    ## Quick access to a 3d identity matrix
  ORIGO3D*:TPoint3d=point3d(0.0,0.0,0.0)
    ## Quick access to point (0,0)
  XAXIS3D*:TVector3d=vector3d(1.0,0.0,0.0)
    ## Quick access to an 3d x-axis unit vector
  YAXIS3D*:TVector3d=vector3d(0.0,1.0,0.0)
    ## Quick access to an 3d y-axis unit vector
  ZAXIS3D*:TVector3d=vector3d(0.0,0.0,1.0)
    ## Quick access to an 3d z-axis unit vector



# ***************************************
#     Private utils
# ***************************************

proc rtos(val:float):string=
  return formatFloat(val,ffDefault,0)



# ***************************************
#     TMatrix2d implementation
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
