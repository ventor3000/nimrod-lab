import math
import strutils

const 
    EPSILON* =1.0E-7
    DEG15* = PI/12.0
    DEG30* = PI/6.0
    DEG45* = PI/4.0
    DEG90* = PI/2.0
    DEG180* =PI
    DEG270* =PI*1.5
    DEG360* =PI*2.0
    
    
proc sgn*(x:float):float {.noInit,inline,nosideeffect.} =
    if x>0.0:
        result= 1.0
    elif x<0.0:
        result= -1.0
    else:
        result=0.0

proc isInf*(x:float):bool=
  var y=x
  return ((cast[ptr Int64](addr y))[] and 0x7fff_ffff_ffff_ffff) == 0x7ff0_0000_0000_0000

        
proc isOdd*(x:int):bool {.inline,noInit,nosideeffect.} =
    ## Returns true if `x` is an odd integer,
    ## otherwise false.
    return x mod 2!=0
    
proc isEven*(x:int):bool {.inline,noInit,nosideeffect.} =
    ## Returns true if `x` is an even integer,
    ## otherwise false.
    return x mod 2==0

proc nthRoot*(nth:int;x:float):float =
  ## Computes the `nth` root of `x`. If `x` is negative and `nth` is even
  ## nan is returned. 
  if x<0.0:
    if nth.isEven: return nan #even root of a negative number is not possible
    return -pow(-x,1.0/nth.float)
  else:
    return pow(x,1.0/nth.float)
    
proc equals*(x,y:float;tol=EPSILON):bool {.nosideeffect.}= 
    return abs(x-y)<=tol

proc isZero*(x:float;tol=EPSILON):bool = 
    return abs(x)<=tol

proc roundTo*(num:float;ndec:int):float=
    ## Computes the value `num` rounded to `ndec` decimals.
    ## If ndec is posetive, result is the number of decimals kept after
    ## the decimal separator. If ndec is negative, result is the number of
    ## digits trucated before the decimal separator.
    var tenpow=pow(10.0,cast[float](ndec))
    if num>0.0:
        result=trunc(num*tenpow+0.5)/tenpow
    else:
        result=trunc(num*tenpow-0.5)/tenpow
        
    if result== -0.0: #avoid negative zero after rounding
      result=0.0
    
# TODO: max value for a floating point type


when isMainModule:
  echo(isInf(4/0.0000000001))
  discard stdin.readline
  
