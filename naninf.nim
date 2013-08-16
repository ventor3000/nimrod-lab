import strutils

proc isInf(x:Float64):bool=
  var y=x
  return ((cast[ptr Int64](addr y))[] and 0x7fff_ffff_ffff_ffff) == 0x7ff0_0000_0000_0000
  


proc maxValue(x:typedesc[Float64]):Float64=
  var lv=0xffefffffffffffff
  return (cast[ptr float64](addr lv))[]

proc minValue(x:typedesc[Float64]):Float64=
  var lv=0xffefffffffffffff;
  return (cast[ptr float64](addr lv))[]


template test(x:TReal):float=
  static:
    if sizeof(x)==4:
      echo("float32")
      return 0.0
    elif sizeof(x)==8:
      echo("float64")
      return 0.0
    else:
      quit("Only 32 and 64 bit floats supported")
  
  
  
proc sin32(x: float32): float {.importc: "sinf", header: "<math.h>".}
proc sin64(x: float64): float {.importc: "sin", header: "<math.h>".}
proc xsin[T:TReal](x: T): T {.noInit.} =
  when sizeof(x)==4: sin32(x.float32)
  elif sizeof(x)==8: sin64(x.float64)
  else: {.error "Non supported floating point width".}
  
    
proc RealSize[T:TReal](x:T):int {.noInit.}=
    when sizeof(x)==4:
      return 32
    elif sizeof(x)==8:
      return 64
    else:
      return 0
      


var a=0.0
echo "start"
while a <6.28:
  var b=xsin(a)
  a+=0.000001
echo "end"

  
echo xsin(3.0'f32)

discard stdin.readline

