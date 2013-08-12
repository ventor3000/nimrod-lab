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
  
  
  



echo Float64.maxValue


echo FormatFloat(Float64.MinValue,ffDefault,0)
echo FormatFloat(Float64.MaxValue,ffDefault,0)

var f=9.8

echo sizeof(float)
discard readline(stdin)
