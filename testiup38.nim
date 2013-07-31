


import iup38
import gl
import cd
import colors
import basic2d
import math


iup38.open(nil,nil)



proc b1click(sender:PIHandle):cint {. cdecl .}=
  var ld=LayoutDialog(nil)
  ld.popup(100,100)


var drawarea:PIhandle
var cdcanvas:PCDCanvas
var tv=vector2d(50,50)
var org=point2d(100,100)
var rotpt=point2d(200,100)
var scl=0.01
var pts:seq[TPoint2d]= @ [point2d(100,100),point2d(323,321),point2d(123,322),point2d(232,213)]
var mousex=0
var mousey=0
var rot=0.0

proc drawVector(p:TPoint2d,v:TVector2d)=
  var q=p+v
  cdcanvas.line(p.x,p.y,q.x,q.y)

proc drawMotion(sender:PIHandle,x,y:cint,status:cstring):cint {.cdecl .}=
  
  var siz=cdcanvas.getSize()
  
  mousex=x
  mousey=siz.height-y-1
  
  redraw(drawarea,0)
  

proc drawScaledCircle(center:TPoint2d,rad:float,scale:float)=
  var prevpt=point2d(center.x+rad,center.y)
  var ang=0.0
  
  while(ang<6.29):
    ang+=0.1 
    var nextpt=point2d(center.x+cos(ang)*rad,center.y+sin(ang)*rad*scale)
    cdcanvas.line(prevpt.x,prevpt.y,nextpt.x,nextpt.y)
    prevpt=nextpt

  var norm=vector2d(cos(PI*0.25),sin(PI*0.25))
  
  norm.transformNorm(stretch(1.0,scale))
  var normpt=point2d(center.x+cos(PI*0.25)*rad,center.y+sin(PI*0.25)*rad*scale)
  
  drawVector(normpt,norm)
  
proc draw(p:TPoint2d)=
  cdcanvas.Line(p.x-2,p.y-2,p.x+2,p.y+2)
  cdcanvas.Line(p.x+2,p.y-2,p.x-2,p.y+2)
  

proc drawAction(sender:PIHandle,posx,posy:cfloat):cint {.cdecl .}=
  discard cdcanvas.activate
  
  
  cdcanvas.transform=IDMATRIX2d;
  cdcanvas.background=colBlack
  cdcanvas.clear
  
  
  var y:int32=5
  
  var test=cdcanvas.updateYAxis(y)
  
  
  cdcanvas.foreground=colGreen
  
  
  cdcanvas.arc(0,0,100,200,0,90)
  
  
  cdcanvas.transform=rotate(1.0) & move(150,150)
  
  

  cdcanvas.arc(0,0,100,0.1,0,90)
  cdcanvas.text(100,100,"Hello!")


  return IUP_DEFAULT
  





drawarea=Canvas(nil)


var dlg=Dialog(
  VBox(
    drawarea,
    Button("World",nil),
    Toggle("Ändra mig",nil),
    nil
  )
)

drawarea.setAttribute("RASTERSIZE","300x300")


dlg.map() #must be mapped to create cd context
cdcanvas=createCanvas(cdContextIup(),drawarea)
drawarea.setCallback("ACTION",cast[ICallback](drawAction))
drawarea.setCallback("MOTION_CB",cast[ICallback](drawMotion))

var v1=vector2d(10,0)
var v2=vector2d(-10,0.0001)
echo v1.turnAngle(v2)



dlg.Show()



#dlg.show()
mainLoop()
iup38.close()