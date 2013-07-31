import basic3d
import basic2d
import math
import strutils


var 
  a=point3d(10,10,0)
  b=point3d(20,25,0)
  c=point3d(30,21,0)
  
  aa=point2d(10,10)
  bb=point2d(20,25)
  cc=point2d(30,21)
  
  
echo formatFloat(area(a,b,c))
echo formatFloat(area(aa,bb,cc))

  
  
echo anyperp(vector3d(1,1,1))


discard readline(stdin)

