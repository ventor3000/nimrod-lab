
import unsigned

type 
  TBigIntDigit=uint32   #the type of a single big int digit
  TBigIntDigits=seq[TBigIntDigit] #a sequence of digits used for a big integer
  TLongDigit=uint64  #type that fits two big int digits multiplied

  TBigInt* =object
    digits:TBigIntDigits  #posetive digits in base maxvalue(uint)+1
    neg:bool #true if negative, false if zero or posetive

const
  digitmask:TLongDigit=TLongDigit(0xffffffff)
  superzero=TLongDigit(0)
  superbase=TLongDigit(0x100000000)
  maxdigit=TBigIntDigit(0xffffffff)
  


proc unsignedAdd(a,b:TBigIntDigits):TBigIntDigits=
  ## adds two sequences of digits, a must
  ## have more or equal digits as b
  
  var numa=a.len
  var numb=b.len
  var numres=max(numa,numb) #number of digits in result, might possibly grow by one if carry left
  newSeq(result,numres)
  var carry:TLongDigit=0
  
  for idx in 0.. <numres:
    if idx<numa: carry=carry+a[idx]
    if idx<numb: carry=carry+b[idx]
    result[idx]=(TBigIntDigit(carry and digitmask))
    carry=carry shr 32 #now the carry really is a carry for the next turn

  if carry>superzero:
    result.add(TBigIntDigit(carry))
    
proc unsignedSubtract(a,b:TBigIntDigits):TBigIntDigits=
  ## subtract a sequence with b,
  ## a must be >= b, so that the result is posetive
  
  var numa=a.len
  var numb=b.len
  var adig,bdig:TBigIntDigit
  var numres=max(numa,numb) #maximum number of digits in result
  newSeq(result,numres)
  var carry=false
  
  for idx in 0.. <numres:
    if idx<numa: adig=a[idx]
    else: adig=0
    if idx<numb: bdig=b[idx]
    else:bdig=0
    
    if carry:
      if adig==0: 
        adig=maxdigit
        carry=true
      else: 
        dec adig
        carry=false
    carry=bdig>adig
    result[idx]=adig-bdig
    
  
  #TODO: raise exception if any carry left, which means b>a which is not allowed
  #TODO: clean
  
proc `+` *(a,b:TBigInt):TBigInt=
  result.digits=unsignedAdd(a.digits,b.digits)
  result.neg=false
  
proc `-` *(a,b:TBigInt):TBigInt=
  result.digits=unsignedSubtract(a.digits,b.digits)
  result.neg=false

proc initBigInt*(val:int32):TBigInt=
  result.digits = @[TBigIntDigit(abs(val))]
  result.neg = (val<0)
  
proc initBigInt*(val:uint32):TBigInt=
  result.digits = @[val]
  result.neg = false

proc `$`(bi:TBigInt):string=
  for a in bi.digits:
    echo a
  result =""



proc divide(bi:var TBigInt,n:TBigIntDigit):TLongDigit=
  var tmp:TLongDigit=0
  
  #TODO: handle division by zero
  
  bi.neg=bi.neg and n>TBigIntDigit(0) or not bi.neg and n<TBigIntDigit(0)
    
  for i in countdown(high(bi.digits),0):
    tmp=tmp*65536
    tmp=tmp or bi.digits[i]
    bi.digits[i]=TBigIntDigit(tmp div n)
    tmp=tmp-bi.digits[i]*n
    
  # TODO: clean

  result=tmp
    
#    
#proc divide(bi:var TBigInt,n:TBigInt):TBigInt=
#    
#    #TODO: handle division by zero
#
#
#    var tmp=initBigInt(0'i32)
#    for i in countdown(high(bi.digits),0):
#      tmp = tmp * 10
#      tmp = tmp + digits[i]
#      digits[i] = 0;
#      while tmp>n:
#        tmp=tmp-n
#        inc bi.digits[n]
#
#    #TODO: clean
#    return tmp
#

  

when isMainModule:
  var bi=initBigInt(uint32(10000))
  echo bi
  
  echo divide(bi,9)
  echo bi
  
  
  
  discard readline(stdin)
    
  
