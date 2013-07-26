import basic3d
import basic2d
import math

var
  v1=vector3d(5,7,0)
  p1=point3d(5,7,0)
  m= rotateZ(DEG90) & move(100,200,300)
 

v1&=m
p1=p1&m
  
  


echo v1
echo p1


discard readline(stdin)

