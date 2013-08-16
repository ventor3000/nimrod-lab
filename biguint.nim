import unsigned

type
  TBigDigit=UInt64 # we use the 32 lower bits of this
let
  base:TBigDigit=0x100000000'u64
  digitMask:TBigDigit=0xFFFF_FFFF'u64
  digitBits:TBigDigit=32 #we use lower 32 bits of digit to store actual value for each digit
    
  
type 
  TBigUInt* =object
    digits: seq[TBigDigit]


proc initBigUInt*(numDigits:Int):TBigUInt=
  result.digits=newSeq[TBigDigit](numDigits) # keep length at least one
  
proc initBigUInt*(val:UInt32):TBigUInt=
  result.digits = @[ val.TBigDigit ]

proc initBigUInt*(val:UInt64):TBigUInt=
  result.digits= @[ val and digitMask ]
  if val>=base: #big enough for two digits?
    result.digits.add(val shr digitBits)
    


proc `$` *(x:TBigUInt):string=
  for a in x.digits:
    echo($a)
  return ""

proc len(x:TBigUInt):int =
  return x.digits.len
  
  
proc `+`(x:TBigUInt,y:TBigUInt):TBigUInt=
  let 
    xl=x.len
    yl=y.len
    n=max(xl,yl)
  var
    carry:TBigDigit=0
    a:TBigDigit
    b:TBigDigit
    digiSum:TBigDigit
    
  result=initBigUInt(n)
  
  for i in 0.. <n:
    if i<xl: a=x.digits[i] else: a=0
    if i<yl: b=y.digits[i] else: b=0
    digiSum=a+b+carry
    result.digits[i]=digiSum and digitMask
    carry=digiSum shr digitBits

  if carry>0'u64: result.digits.add(carry)
    
  


when isMainModule:
  #var bi:TBigUInt
  
  var x:UInt64=2000000000;
  
  var bi1=initBigUInt(x*13443432423423432)
  var bi2=initBigUInt(x*13344443423423)
  
  echo bi1+bi2
  
  
  
  discard stdin.readline
  

  
  
  
  
  
  
  

