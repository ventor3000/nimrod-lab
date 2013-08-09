import math
import sequtils
import sdl
import basic3d
import poly
import strutils

const 
  width  = 640 #1280
  height = 480 #720
  fov    = 45.0
  max_depth = 1 
  
type
  TRay {.pure, final.} = object
    start: TPoint3d
    dir: TVector3d
  TTraceObject = object of TObject
    color : TVector3d
    reflection: Float
    transparency: Float
  PTraceObject = ref TTraceObject
 
  TSphere {.pure, final.} = object of TTraceObject
    center : TPoint3d
    radius : Float
  PSphere = ref TSphere
  
  TTorus {.pure,final.} = object of TTraceObject
    #majorRadius:Float
    minorRadius:float # minor radius in unit space, major radius is always one
    matrix:TMatrix3d
    invmat:TMatrix3d  # inverse matrix, to save time for computation
  PTorus = ref TTorus
  
  TLight {.pure, final.} = object
    position: TPoint3d
    color: TVector3d
  TScene {.pure, final.} = object
    objects: seq[PTraceObject]
    lights: seq[ref TLight]


proc newRay(start:TPoint3d, dir: TVector3d): TRay {.noInit, inline.} =
  result.start = start
  result.dir = dir
  
proc newLight(position:TPoint3d, color: TVector3d): ref TLight =
  new result
  result.position = position
  result.color = color
    

# ************Abstract TraceObject impl.************  
method intersect(me:PTraceObject,ray:TRay,distance:var float):Bool=quit("Intersection not implemented for this")
method isIntersecting(me: PTraceObject, ray: TRay) : Bool = quit("isIntersecting not implemented for this object")
method getNormal(me: PTraceObject, v: TPoint3d): TVector3d {.noInit.} = quit("getNormal not implemented fo this object")

# ************Sphere impl.************
proc newSphere(center: TPoint3d, radius: Float, color: TVector3d, reflection: Float = 0.0, transparency: Float = 0.0): PSphere =
  new(result)
  result.center = center
  result.radius = radius
  result.color = color
  result.reflection = reflection
  result.transparency = transparency
  
method getNormal(me: PSphere, v: TPoint3d): TVector3d {.noInit.} = 
  result=v-me.center
  normalize(result)


template intersectImpl(me: ref TSphere, ray: expr) : expr {.immediate, dirty.} = 

  var vl = me.center - ray.start
  var a = dot(vl, ray.dir)
  if (a < 0) :             # opposite direction
    return false
  var b2 = dot(vl, vl) - a * a
  var r2 = me.radius * me.radius
  if (b2 > r2) :           # perpendicular > r
    return false

method isIntersecting(me: PSphere, ray: TRay) : Bool = 
  intersectImpl(me, ray)
  return true


method intersect(me: PSphere, ray: TRay, distance: var Float) : Bool  = 
  intersectImpl(me, ray)
  var c = sqrt(r2 - b2)
  var near = a - c
  var far  = a + c
  distance = if (near < 0) : far else : near
  return true

# ************Torus impl.************
proc newTorus(pos:TMatrix3d,rmajor,rminor:float,color: TVector3d, reflection: Float = 0.0, transparency: Float = 0.0) : PTorus =
  new(result)
  result.color = color
  result.reflection = reflection
  result.transparency = transparency
  
  let scale=1.0/rmajor
  
  result.minorradius=rminor*scale
  result.matrix = scale(rmajor) & pos
  result.invmat=result.matrix.inverse
  
method intersectOld(me:PTorus,ray:TRay,distance:var float):bool=

  var
    eye=ray.start
    dir=ray.dir
    
  eye= eye & me.invmat
  dir= dir & me.invmat
    
  
  let
    dx=dir.x
    dy=dir.y
    dz=dir.z
    x0=eye.x
    y0=eye.y
    z0=eye.z
    rmin=me.MinorRadius
    x02=x0*x0
    y02=y0*y0
    y04=y02*y02
    z02=z0*z0
    z04=z02*z02
    dx2=dx*dx
    dy2=dy*dy
    dz2=dz*dz
    rmin2=rmin*rmin
    t1= -4*dz*z02*z0+(-4*dy*y0-4*dx*x0)*z02+(-4*dz*y02-4*dz*x02+4*dz*rmin2-4*dz)*z0-4*dy*y02*y0-4*dx*x0*y02+(-4*dy*x02+4*dy*rmin2+4*dy)*
      y0-4*dx*x02*x0+(4*dx*rmin2+4*dx)*x0
    t2=(-6*dz2-2*dy2-2*dx2)*z02+(-8*dy*dz*y0-8*dx*dz*x0)*z0+(-2*dz2-6*dy2-2*dx2)*y02-8*dx*dy*x0*y0+
      (-2*dz2-2*dy2-6*dx2)*x02+(2*dz2+2*dy2+2*dx2)*rmin2-2*dz2+2*dy2+2*dx2
    t3=((-4*dy2-4*dx2)*dz-4*dz2*dz)*z0+(-4*dy*dz2-4*dy2*dy-4*dx2*dy)*y0+(-4*dx*dz2-4*dx*dy2-4*dx2*dx)*x0
    t4= -(dz2*dz2)+(-2*dy2-2*dx2)*dz2-dy2*dy2-2*dx2*dy2-dx2*dx2
    t0= -z04+(-2*y02-2*x02+2*rmin2-2)*z02-y04+(-2*x02+2*rmin2+2)*y02-x02*x02+(2*rmin2+2)*x02-rmin2*rmin2+2*rmin2-1
    
    p=initPoly(t4,t3,t2,t1,t0)
    
    ts=p.roots
    
  result=false
  distance=1.0e300
  for t in ts:
    if t>0.0 and t<distance:
      result=true
      distance=t
  
  
method intersect(me:PTorus,ray:TRay,distance:var float):bool=

  
  var
    eye=ray.start
    dir=ray.dir
    
  eye= eye & me.invmat
  dir= dir & me.invmat

  let
    dx=eye.x
    dy=eye.y
    dz=eye.z
    ex=dir.x
    ey=dir.y
    ez=dir.z
    r=me.minorradius
    G=4*(ex*ex+ey*ey)
    H=8*(dx*ex+dy*ey)
    I=4*(dx*dx+dy*dy)
    J=ex*ex+ey*ey+ez*ez
    K=2*(dx*ex+dy*ey+dz*ez)
    L=dx*dx+dy*dy+dz*dz+1-r*r
    x4=J*J
    x3=2*J*K
    x2=2*J*L+K*K-G
    x1=2*K*L-H
    x0=L*L-I
    ply=initPoly(x4,x3,x2,x1,x0)
  
  
  
  
  var ts=ply.roots()
    
  
  
    
  result=false
  distance=1.0e300
  for t in ts:
    
    if t>0.0 and t<distance:
      result=true
      distance=t   
  
  
    
   
    
    
  
method getNormal(me: PTorus, pt: TPoint3d): TVector3d {.noInit.} = 
  #let r=me.minorradius
  
  when false:
    var
      ploc=p
    
    ploc&=me.invmat
    let 
      x=ploc.x
      y=ploc.y
      z=ploc.z
      r=me.minorRadius
    
    result.x=x*z*z+x*y*y+x*x*x-r*r*x-x
    result.y=y*z*z+y*y*y+x*x*y-r*r*y-y
    result.z=z*z*z+y*y*z+x*x*z-r*r*z+z
    
    result.transformNorm(me.invmat)
    result.normalize
  
  
  var
    p=pt
  p&=me.invmat
  
  let
    srt=1.0/(p.x*p.x+p.y*p.y)
    clp=point3d(p.x*srt,p.y*srt,0.0)
  
  result=clp-p
  result.transformNorm(me.invmat)
  result.normalize()
    
  

method isIntersecting(me: PTorus, ray: TRay) : Bool = 
  var f:float
  return intersect(me,ray,f)




  

proc trace(ray: TRay, scene: TScene, depth: int): TVector3d =
  var nearest = inf
  var obj : PTraceObject

  # // search the scene for nearest intersection
  for o in scene.objects :
    var distance = inf
    if o.intersect(ray, distance) :
      if distance < nearest :
        nearest = distance
        obj = o

  if obj.isNil : return #newVec3(0)

  #let ambient=0.5
  #result.x=obj.color.x*ambient
  #result.y=obj.color.y*ambient
  #result.z=obj.color.z*ambient
  
  var point_of_hit = ray.start+ray.dir * nearest
  #point_of_hit += ray.start 
  var normal = obj.getNormal(point_of_hit)
  var inside = false

  var dot_normal_ray = dot(normal, ray.dir)
  if dot_normal_ray > 0 :
    inside = true
    normal = -normal
    dot_normal_ray = -dot_normal_ray

  var reflection_ratio = obj.reflection
  let normE5 = normal * 1.0e-5
  for lgt in scene.lights :
    var light_direction=lgt.position - point_of_hit
    normalize(light_direction)
    #let light_direction = normalize(lgt.position - point_of_hit)
    let r = newRay(point_of_hit + normE5, light_direction)

    # go through the scene check whether we're blocked from the lights
    
    var blocked = false
    for it in scene.objects:
      blocked = it.isIntersecting(r)
      if blocked: break
    
    if not blocked :
      when true :
        var temp = lgt.color
        temp *= max(0.0, dot(normal, light_direction))
        temp *= obj.color
        temp *= (1.0 - reflection_ratio)
        result += temp
      else : 
        result += lgt.color * 
          max(0.0, dot(normal, light_direction)) * 
          obj.color * (1.0 - reflection_ratio)
  

  var facing = max(0.0, - dot_normal_ray)
  var fresneleffect = reflection_ratio + (1.0 - reflection_ratio) * pow((1.0 - facing), 5.0)

  # compute reflection
  if depth < max_depth and reflection_ratio > 0 :
      var reflection_direction = ray.dir - normal * 2.0 * dot_normal_ray 
      var reflection = trace(newRay(point_of_hit + normE5, reflection_direction), scene, depth + 1)
      result += reflection * fresneleffect


  # compute refraction
  if depth < max_depth and (obj.transparency > 0.0) :
    var ior = 1.5
    let CE = ray.dir.dot(normal) * -1.0
    ior = if inside : 1.0 / ior else: ior
    let eta = 1.0 / ior
    let GF = (ray.dir + normal * CE) * eta
    let sin_t1_2 = 1.0 - CE * CE
    let sin_t2_2 = sin_t1_2 * (eta * eta)
    if sin_t2_2 < 1.0 :
        let GC = normal * sqrt(1 - sin_t2_2)
        let refraction_direction = GF - GC
        let refraction = trace(newRay(point_of_hit - normal * 1.0e-4, refraction_direction),
                                scene, depth + 1)
        result += refraction * (1.0 - fresneleffect) * obj.transparency
  

proc render (scene: TScene, surface: PSurface) =
  discard LockSurface(surface)

  let eye = point3d(0,0,0)
  var h = tan(fov / 360.0 * 2.0 * PI / 2.0) * 2.0
  var 
    w = h * width.float / height.float
  const    
    ww = width.float
    hh = height.float

  for y in 0 .. < height :
    let yy = y.float
    var row: ptr int32 = cast[ptr int32](cast[TAddress](surface.pixels) + surface.pitch.int32 * y)
    for x in 0 .. < width :
      let xx = x.float
      var dir=vector3d((xx - ww / 2.0) / ww  * w,
                           (hh/2.0 - yy) / hh * h,
                           -1.0)
      normalize(dir)
      let pixel = trace(newRay(eye, dir), scene, 0)
      #macFor x -> [0,1,2], col -> [r,g,b] :
      let r = min(255, round(pixel.x * 255.0)).byte
      let g = min(255, round(pixel.y * 255.0)).byte
      let b = min(255, round(pixel.z * 255.0)).byte

      row[] = MapRGB(surface.format, r, g, b)
      row = cast[ptr int32](cast[TAddress](row) + sizeof(int32))
  UnlockSurface(surface)
  UpdateRect(surface, 0, 0, 0, 0)

proc test() =
  if init(INIT_VIDEO) != 0:
    quit "SDL failed to initialize!"

  var screen = SetVideoMode(width, height, 32, SWSURFACE or ANYFORMAT)
  if screen.isNil:
    quit($sdl.getError())
  var scene: TScene
  
  scene.objects= @[]
  #scene.objects.add(newSphere(point3d(0.0, -10002.0, -20.0), 10000.0, vector3d(0.8, 0.8, 0.8)))
  #scene.objects.add(newSphere(point3d(0.0, 2.0, -20.0), 4.0, vector3d(0.8, 0.5, 0.5), 0.5))
  #scene.objects.add(newSphere(point3d(5.0, 0.0, -15.0), 2.0, vector3d(0.3, 0.8, 0.8), 0.2))
  #scene.objects.add(newSphere(point3d(-5.0, 0.0, -15.0), 2.0, vector3d(0.3, 0.5, 0.8), 0.2))
  #scene.objects.add(newSphere(point3d(-2.0, -1.0, -10.0), 1.0, vector3d(0.1, 0.1, 0.1), 0.1, 0.8))
  scene.objects.add(newTorus(stretch(2.0,1.0,1.0) & rotateY(1.58) & move(2,2,-10),2.0,0.4,vector3d(0.5,0.0,0.0),0.1 ))
  scene.lights = @[newLight(point3d(-10.0, 20.0, 30.0), vector3d(2.0, 2.0, 2.0)) ]
  render(scene, screen)

when isMainModule :  

  #  import benchmark
  #  bench("duration"):
  test()
  

  echo("done!")
  
  
  discard stdin.readline
