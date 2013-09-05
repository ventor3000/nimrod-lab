
import strutils
import basic3d
import times


###########################################################
## Implementation of 'new' matrix, needs to be array based 
## to allow for loop multiplication
###########################################################

type 
  TRow = array[0..4,float]
  TGrid=object
    rows:array[0..4,TRow]
    
    
proc rtos(v:float):string=
  return FormatFloat(v,ffDefault,0)

proc `$` *(m:TRow):string=
  return rtos(m[0]) & " , " & rtos(m[1]) & " , " & rtos(m[2]) & " , " & rtos(m[3])
  
proc `$` *(m:TGrid):string=
  return $m.rows[0] & "\n" & $m.rows[1] & "\n" & $m.rows[2] & "\n" & $m.rows[3]
  
  
proc `&` *(m1,m2:TGrid):TGrid = 
  ## Concatenate two new matrices with looping
  
  # Note that we use that the grid is initiated with zeroes from start thus no 'noInit' pragma
  for c in 0..4:
    for d in 0..4:
      for k in 0..4:
        result.rows[c][d] += m1.rows[c][k]*m2.rows[k][d]


## Which multiplication method is the fastest? We try here:
echo "Benchmark of matrix multiplication with loop multiplication"
echo "vs. inlined matrices without arrays (aka. current basic3d)..."
echo ""

# benchmark loop multiplication:
var t0=cpuTime()
var mat,mres:TGrid
for a in 1..100000000:
  mat = mat&mres #incrementally cascade matrices...
echo "Time for loop matrix multiplication: " & rtos(cpuTime()-t0)  
echo mat #...and output it to disable elimination by optimizer



# benchmark current basic3d matrices multiplication
t0=cpuTime()
var mat2,mres2:TMatrix3d
for a in 1..100000000:
  mat2 = mat2&mres2 #incrementally cascade matrices...
echo "Time for unrolled direct access matrix multiplication (current basic3d): " & rtos(cpuTime()-t0)
echo mat2 #...and output it to disable elimination by optimizer



discard stdin.readline





    
    
  