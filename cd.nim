import colors
import basic2d


when defined(windows):
  const
    cd_dll="cd.dll"
    cdcontextplus_dll="cdcontextplus.dll"
    iupcd_dll="iupcd.dll"
    
#TODO: dll refs add for linux and mac to

type 
  TCDContext {.pure.} = object
  PCDContext* = ptr TCDContext
  TCDCanvas {.pure.} = object
  PCDCanvas* = ptr TCDCanvas
  TCDState {.pure.} = object
  PCDState* = ptr TCDState
  TCDImage {.pure.} = object
  PCDImage* = ptr TCDImage
  
# client images using bitmap structure 
type 
  cdBitmap* {.pure, final.} = object 
    w*: cint
    h*: cint
    typ*: cint
    data*: pointer
    
# CD Values 
const 
  CD_QUERY* = - 1           # query value 
const                       # bitmap type 
  CD_RGB* = 0               # these definitions are compatible with the IM library 
  CD_MAP* = 1
  CD_RGBA* = 0x00000100
const                       # bitmap data 
  CD_IRED* = 0
  CD_IGREEN* = 1
  CD_IBLUE* = 2
  CD_IALPHA* = 3
  CD_INDEX* = 4
  CD_COLORS* = 5
const                       # status report 
  CD_ERROR* = - 1
  CD_OK* = 0
const                       # clip mode 
  CD_CLIPOFF* = 0
  CD_CLIPAREA* = 1
  CD_CLIPPOLYGON* = 2
  CD_CLIPREGION* = 3
const                       # region combine mode 
  CD_UNION* = 0
  CD_INTERSECT* = 1
  CD_DIFFERENCE* = 2
  CD_NOTINTERSECT* = 3
const                       # polygon mode (begin...end) 
  CD_FILL* = 0
  CD_OPEN_LINES* = 1
  CD_CLOSED_LINES* = 2
  CD_CLIP* = 3
  CD_BEZIER* = 4
  CD_REGION* = 5
  CD_PATH* = 6
const 
  CD_POLYCUSTOM* = 10
const                       # path actions 
  CD_PATH_NEW* = 0
  CD_PATH_MOVETO* = 1
  CD_PATH_LINETO* = 2
  CD_PATH_ARC* = 3
  CD_PATH_CURVETO* = 4
  CD_PATH_CLOSE* = 5
  CD_PATH_FILL* = 6
  CD_PATH_STROKE* = 7
  CD_PATH_FILLSTROKE* = 8
  CD_PATH_CLIP* = 9
const                       # fill mode 
  CD_EVENODD* = 0
  CD_WINDING* = 1
const                       # line join  
  CD_MITER* = 0
  CD_BEVEL* = 1
  CD_ROUND* = 2
const                       # line cap  
  CD_CAPFLAT* = 0
  CD_CAPSQUARE* = 1
  CD_CAPROUND* = 2
const                       # background opacity mode 
  CD_OPAQUE* = 0
  CD_TRANSPARENT* = 1
const                       # write mode 
  CD_REPLACE* = 0
  CD_XOR* = 1
  CD_NOT_XOR* = 2
const                       # color allocation mode (palette) 
  CD_POLITE* = 0
  CD_FORCE* = 1
const                       # line style 
  CD_CONTINUOUS* = 0
  CD_DASHED* = 1
  CD_DOTTED* = 2
  CD_DASH_DOT* = 3
  CD_DASH_DOT_DOT* = 4
  CD_CUSTOM* = 5
const                       # marker type 
  CD_PLUS* = 0
  CD_STAR* = 1
  CD_CIRCLE* = 2
  CD_X* = 3
  CD_BOX* = 4
  CD_DIAMOND* = 5
  CD_HOLLOW_CIRCLE* = 6
  CD_HOLLOW_BOX* = 7
  CD_HOLLOW_DIAMOND* = 8
const                       # hatch type 
  CD_HORIZONTAL* = 0
  CD_VERTICAL* = 1
  CD_FDIAGONAL* = 2
  CD_BDIAGONAL* = 3
  CD_CROSS* = 4
  CD_DIAGCROSS* = 5
const                       # interior style 
  CD_SOLID* = 0
  CD_HATCH* = 1
  CD_STIPPLE* = 2
  CD_PATTERN* = 3
  CD_HOLLOW* = 4
const                       # text alignment 
  CD_NORTH* = 0
  CD_SOUTH* = 1
  CD_EAST* = 2
  CD_WEST* = 3
  CD_NORTH_EAST* = 4
  CD_NORTH_WEST* = 5
  CD_SOUTH_EAST* = 6
  CD_SOUTH_WEST* = 7
  CD_CENTER* = 8
  CD_BASE_LEFT* = 9
  CD_BASE_CENTER* = 10
  CD_BASE_RIGHT* = 11
const                       # style 
  CD_PLAIN* = 0
  CD_BOLD* = 1
  CD_ITALIC* = 2
  CD_UNDERLINE* = 4
  CD_STRIKEOUT* = 8
const 
  CD_BOLD_ITALIC* = (CD_BOLD or CD_ITALIC) # compatibility name 
const                       # some font sizes 
  CD_SMALL* = 8
  CD_STANDARD* = 12
  CD_LARGE* = 18
# Context Capabilities 
const 
  CD_CAP_NONE* = 0x00000000
  CD_CAP_FLUSH* = 0x00000001
  CD_CAP_CLEAR* = 0x00000002
  CD_CAP_PLAY* = 0x00000004
  CD_CAP_YAXIS* = 0x00000008
  CD_CAP_CLIPAREA* = 0x00000010
  CD_CAP_CLIPPOLY* = 0x00000020
  CD_CAP_REGION* = 0x00000040
  CD_CAP_RECT* = 0x00000080
  CD_CAP_CHORD* = 0x00000100
  CD_CAP_IMAGERGB* = 0x00000200
  CD_CAP_IMAGERGBA* = 0x00000400
  CD_CAP_IMAGEMAP* = 0x00000800
  CD_CAP_GETIMAGERGB* = 0x00001000
  CD_CAP_IMAGESRV* = 0x00002000
  CD_CAP_BACKGROUND* = 0x00004000
  CD_CAP_BACKOPACITY* = 0x00008000
  CD_CAP_WRITEMODE* = 0x00010000
  CD_CAP_LINESTYLE* = 0x00020000
  CD_CAP_LINEWITH* = 0x00040000
  CD_CAP_FPRIMTIVES* = 0x00080000
  CD_CAP_HATCH* = 0x00100000
  CD_CAP_STIPPLE* = 0x00200000
  CD_CAP_PATTERN* = 0x00400000
  CD_CAP_FONT* = 0x00800000
  CD_CAP_FONTDIM* = 0x01000000
  CD_CAP_TEXTSIZE* = 0x02000000
  CD_CAP_TEXTORIENTATION* = 0x04000000
  CD_CAP_PALETTE* = 0x08000000
  CD_CAP_LINECAP* = 0x10000000
  CD_CAP_LINEJOIN* = 0x20000000
  CD_CAP_PATH* = 0x40000000
  CD_CAP_BEZIER* = 0x80000000
  CD_CAP_ALL* = 0xFFFFFFFF
# Context Types 
const 
  CD_CTX_WINDOW* = 0
  CD_CTX_DEVICE* = 1
  CD_CTX_IMAGE* = 2
  CD_CTX_FILE* = 3
# cdPlay definitions 
const 
  CD_SIZECB* = 0            # size callback 


# library 
proc cdVersion*(): cstring {.importc: "cdVersion", dynlib: cd_dll.}
proc cdVersionDate*(): cstring {.importc: "cdVersionDate", dynlib: cd_dll.}
proc cdVersionNumber*(): cint {.importc: "cdVersionNumber", dynlib: cd_dll.}

# canvas init 
proc createCanvas*(context: PCDContext; data: pointer): PCDCanvas {. importc: "cdCreateCanvas", dynlib: cd_dll.} 
  ## Creates a canvas using the specified context and a raw data pointer

proc createCanvasF*(context: PCDContext; format: cstring): PCDCanvas {.varargs, importc: "cdCreateCanvasf", dynlib: cd_dll.}
  ## Creates a canvas using the specified context and a formatted string.

proc kill*(canvas: PCDCanvas) {.importc: "cdKillCanvas", dynlib: cd_dll.}
  ## Destroys the canvas and releases resources used by it.

proc getContext*(canvas: PCDCanvas): PCDContext {.importc: "cdCanvasGetContext", dynlib: cd_dll.}
  ## Gets the context used by the canvas.


proc cdCanvasActivate(canvas: PCDCanvas): cint {. importc: "cdCanvasActivate", dynlib: cd_dll.}
proc activate*(canvas: PCDCanvas):bool {.discardable.}=
  ## Activates the canvas. Returns true on success.
  return cdCanvasActivate(canvas)==CD_OK

proc deactivate*(canvas: PCDCanvas) {. importc: "cdCanvasDeactivate", dynlib: cd_dll.}
  ## Makes the canvas not beeing active.
   
    
proc cdUseContextPlus(use: cint): cint {.importc: "cdUseContextPlus", dynlib: cd_dll.}
proc useContextPlus*(use:bool):bool=
  ## Activates or deactivates the use of an external context for the next calls of the createCanvas function
  if use:
    result = cdUseContextPlus(1) != 0
  else:
    result = cdUseContextPlus(0) != 0

proc cdInitContextPlus*() {.importc: "cdInitContextPlus", dynlib: cdcontextplus_dll.} 
  ## Initializes the context driver to use another context replacing the standard drivers. 
  ## This functions is only available when a library containing a "ContextPlus" 
  ## context driver is used. See the Cairo, GDI+ and XRender base drivers. 
  ## Those libraries does not support XOR write mode, but has support for 
  ## anti-aliasing and alpha for transparency.
  
proc cdFinishContextPlus*() {.importc: "cdFinishContextPlus", dynlib: cdcontextplus_dll.} 
  ## End use of an `initContextPlus`
  

# context 
type 
  cdCallback* = proc (canvas: PCDCanvas): cint {.varargs,cdecl.}

proc registerCallback*(context: PCDContext; cb: cint; func: cdCallback): cint {. importc: "cdContextRegisterCallback", dynlib: cd_dll.}
proc Caps*(context: PCDContext): culong {. importc: "cdContextCaps", dynlib: cd_dll.}
proc IsPlus*(context: PCDContext): cint {. importc: "cdContextIsPlus", dynlib: cd_dll.}
proc getType*(context: PCDContext): cint {.importc: "cdContextType", dynlib: cd_dll.}
  ## Gets the type of  the context
  ## ctxWindow - GUI window based
  ## ctxDevice - device based (clipboard, printer, picture)
  ## ctxImage - server or client image based, including double buffer based
  ## ctxFile - metafile based
  
  
# control 
proc simulate*(canvas: PCDCanvas; mode: cint): cint {. importc: "cdCanvasSimulate", dynlib: cd_dll.}
proc flush*(canvas: PCDCanvas) {.importc: "cdCanvasFlush", dynlib: cd_dll.}
proc clear*(canvas: PCDCanvas) {.importc: "cdCanvasClear", dynlib: cd_dll.}
proc saveState*(canvas: PCDCanvas): PCDState {.importc: "cdCanvasSaveState", dynlib: cd_dll.}
proc restoreState*(canvas: PCDCanvas; state: PCDState) {.importc: "cdCanvasRestoreState", dynlib: cd_dll.}
proc releaseState*(state: PCDState) {.importc: "cdReleaseState", dynlib: cd_dll.}
proc setAttribute*(canvas: PCDCanvas; name: cstring; data: cstring) {.importc: "cdCanvasSetAttribute", dynlib: cd_dll.}
proc setFAttribute*(canvas: PCDCanvas; name: cstring; format: cstring) {.varargs, importc: "cdCanvasSetfAttribute", dynlib: cd_dll.}
proc getAttribute*(canvas: PCDCanvas; name: cstring): cstring {.importc: "cdCanvasGetAttribute", dynlib: cd_dll.}

# interpretation 
proc play*(canvas: PCDCanvas; context: PCDContext; xmin: cint; xmax: cint; ymin: cint; ymax: cint; data: pointer): cint {.importc: "cdCanvasPlay", dynlib: cd_dll.}
# coordinate transformation 
proc cdCanvasGetSize(canvas: PCDCanvas; width: ptr cint; height: ptr cint; width_mm: ptr cdouble; height_mm: ptr cdouble) {. importc: "cdCanvasGetSize", dynlib: cd_dll.}
proc getSize*(canvas:PCDCanvas):tuple[width,height:int,width_mm,height_mm:float]=
  ## Returns the canvas size in pixels and in millimeters.
  var width,height:cint
  var width_mm,height_mm:cdouble
  cdCanvasGetSize(canvas,addr width,addr height,addr width_mm,addr height_mm)
  result.width=width
  result.height=height
  result.width_mm=width_mm
  result.height_mm=height_mm
  
    
proc cdCanvasUpdateYAxis(canvas: PCDCanvas; y: ptr cint): cint {.importc: "cdCanvasUpdateYAxis", dynlib: cd_dll.}
proc updateYAxis*(canvas:PCDCanvas,y:var int32):int32=
  ## Invert the given Y coordinate if the native Y axis orientation is different 
  ## from the CD axis orientation. The CD axis orientation is always bottom-top.
  ## It also returns the changed value.
  return cdCanvasUpdateYAxis(canvas,addr y)
  
proc cdfCanvasUpdateYAxis*(canvas: PCDCanvas; y: ptr cdouble): cdouble {.importc: "cdfCanvasUpdateYAxis", dynlib: cd_dll.}
proc updateYAxis*(canvas:PCDCanvas,y:var float64):float=
  ## Invert the given Y coordinate if the native Y axis orientation is different 
  ## from the CD axis orientation. The CD axis orientation is always bottom-top.
  ## It also returns the changed value.
  return cdfCanvasUpdateYAxis(canvas,addr y)

proc invertYAxis*(canvas: PCDCanvas; y: cint): cint {. importc: "cdCanvasInvertYAxis", dynlib: cd_dll.}
  ## Invert the given Y coordinate independent of the driver Y axis orientation.

proc invertYAxis*(canvas: PCDCanvas; y: cdouble): cdouble {.importc: "cdfCanvasInvertYAxis", dynlib: cd_dll.}
  ## Invert the given Y coordinate independent of the driver Y axis orientation.

proc cdCanvasMM2Pixel(canvas: PCDCanvas; mm_dx: cdouble; mm_dy: cdouble; dx: ptr cint; dy: ptr cint) {. importc: "cdCanvasMM2Pixel", dynlib: cd_dll.}
proc cdfCanvasMM2Pixel(canvas: PCDCanvas; mm_dx, mm_dy: cdouble; dx,dy: ptr cdouble) {. importc: "cdfCanvasMM2Pixel", dynlib: cd_dll.}
proc mmToPixel*(canvas: PCDCanvas; mm_dx,mm_dy: cdouble):tuple[x,y:cint]=
  cdCanvasMM2Pixel(canvas,mm_dx,mm_dy,addr result.x,addr result.y)
proc mmToPixelPnt*(canvas: PCDCanvas; mm_dx,mm_dy: float64):TPoint2d=
  var fx,fy:cdouble
  cdfCanvasMM2Pixel(canvas,mm_dx,mm_dy,addr fx,addr fy)
  result.x=fx
  result.y=fy
proc mmToPixelVec*(canvas: PCDCanvas; mm_dx,mm_dy: float64):TVector2d=
  var fx,fy:cdouble
  cdfCanvasMM2Pixel(canvas,mm_dx,mm_dy,addr fx,addr fy)
  result.x=fx
  result.y=fy


proc cdCanvasPixel2MM(canvas: PCDCanvas; dx: cint; dy: cint; mm_dx: ptr cdouble; mm_dy: ptr cdouble) {. importc: "cdCanvasPixel2MM", dynlib: cd_dll.}
proc cdfCanvasPixel2MM(canvas: PCDCanvas; dx: cdouble; dy: cdouble; mm_dx: ptr cdouble; mm_dy: ptr cdouble) {.importc: "cdfCanvasPixel2MM", dynlib: cd_dll.}
proc PixelToMM*(canvas: PCDCanvas; dx,dy: cint):tuple[x,y:cdouble]=
  cdCanvasPixel2MM(canvas,dx,dy,addr result.x,addr result.y)
proc PixelToMM*(canvas: PCDCanvas; dx,dy: cdouble):tuple[x,y:cdouble]=
  cdfCanvasPixel2MM(canvas,dx,dy,addr result.x,addr result.y)
proc PixelToMMPnt*(canvas: PCDCanvas; dx,dy: float):TPoint2d=
  var fx,fy:cdouble
  cdfCanvasPixel2MM(canvas,dx,dy,addr fx,addr fy)
  result.x=fx
  result.y=fy
proc PixelToMMVec*(canvas: PCDCanvas; dx,dy: float):TVector2d=
  var fx,fy:cdouble
  cdfCanvasPixel2MM(canvas,dx,dy,addr fx,addr fy)
  result.x=fx
  result.y=fy



proc cdCanvasOrigin(canvas: PCDCanvas; x: cint; y: cint) {.importc: "cdCanvasOrigin", dynlib: cd_dll.}
proc cdfCanvasOrigin(canvas: PCDCanvas; x: cdouble; y: cdouble) {.importc: "cdfCanvasOrigin", dynlib: cd_dll.}
proc `origin=` *(canvas:PCDCanvas,org:tuple[x,y:int])=
  cdCanvasOrigin(canvas,org.x.cint,org.y.cint)
proc `origin=` *(canvas:PCDCanvas,org:TPoint2d)=
  cdfCanvasOrigin(canvas,org.x,org.y)
  

proc cdCanvasGetOrigin(canvas: PCDCanvas; x: ptr cint; y: ptr cint) {.importc: "cdCanvasGetOrigin", dynlib: cd_dll.}
proc cdfCanvasGetOrigin(canvas: PCDCanvas; x: ptr cdouble; y: ptr cdouble) {.importc: "cdfCanvasGetOrigin", dynlib: cd_dll.}
proc getOrigin*(canvas:PCDCanvas):tuple[x,y:cint]=
  cdCanvasGetOrigin(canvas,addr result.x,addr result.y)
proc getOriginF*(canvas:PCDCanvas):TPoint2d=
  var fx,fy:cdouble
  cdfCanvasGetOrigin(canvas,addr fx,addr fy)
  result.x=fx
  result.y=fy


proc cdCanvasTransform(canvas: PCDCanvas; matrix: ptr cdouble) {.importc: "cdCanvasTransform", dynlib: cd_dll.}
proc `transform=` *(canvas:PCDCanvas,matrix:TMatrix2d)=
  var dp:array[0..5,cdouble]=[matrix.ax.cdouble,matrix.ay.cdouble,matrix.bx.cdouble,matrix.by.cdouble,matrix.tx.cdouble,matrix.ty.cdouble]
  cdCanvasTransform(canvas,addr dp[0])



proc cdCanvasGetTransform(canvas: PCDCanvas): ptr array[0..5,cdouble] {.importc: "cdCanvasGetTransform", dynlib: cd_dll.}
proc transform*(canvas:PCDCanvas):TMatrix2d=
  var pm=cdCanvasGetTransform(canvas)
  result.setElements(pm[0],pm[1],pm[2],pm[3],pm[4],pm[5])



proc cdCanvasTransformMultiply*(canvas: PCDCanvas; matrix: ptr cdouble) {.
    importc: "cdCanvasTransformMultiply", dynlib: cd_dll.}
proc cdCanvasTransformRotate*(canvas: PCDCanvas; angle: cdouble) {.
    importc: "cdCanvasTransformRotate", dynlib: cd_dll.}
proc cdCanvasTransformScale*(canvas: PCDCanvas; sx: cdouble; sy: cdouble) {.
    importc: "cdCanvasTransformScale", dynlib: cd_dll.}
proc cdCanvasTransformTranslate*(canvas: PCDCanvas; dx: cdouble; 
                                 dy: cdouble) {.
    importc: "cdCanvasTransformTranslate", dynlib: cd_dll.}
proc cdCanvasTransformPoint*(canvas: PCDCanvas; x: cint; y: cint; 
                             tx: ptr cint; ty: ptr cint) {.
    importc: "cdCanvasTransformPoint", dynlib: cd_dll.}
proc cdfCanvasTransformPoint*(canvas: PCDCanvas; x: cdouble; y: cdouble; 
                              tx: ptr cdouble; ty: ptr cdouble) {.
    importc: "cdfCanvasTransformPoint", dynlib: cd_dll.}
# clipping 
proc cdCanvasClip*(canvas: PCDCanvas; mode: cint): cint {.
    importc: "cdCanvasClip", dynlib: cd_dll.}
proc cdCanvasClipArea*(canvas: PCDCanvas; xmin: cint; xmax: cint; 
                       ymin: cint; ymax: cint) {.importc: "cdCanvasClipArea", 
    dynlib: cd_dll.}
proc cdCanvasGetClipArea*(canvas: PCDCanvas; xmin: ptr cint; 
                          xmax: ptr cint; ymin: ptr cint; ymax: ptr cint): cint {.
    importc: "cdCanvasGetClipArea", dynlib: cd_dll.}
proc cdfCanvasClipArea*(canvas: PCDCanvas; xmin: cdouble; xmax: cdouble; 
                        ymin: cdouble; ymax: cdouble) {.
    importc: "cdfCanvasClipArea", dynlib: cd_dll.}
proc cdfCanvasGetClipArea*(canvas: PCDCanvas; xmin: ptr cdouble; 
                           xmax: ptr cdouble; ymin: ptr cdouble; 
                           ymax: ptr cdouble): cint {.
    importc: "cdfCanvasGetClipArea", dynlib: cd_dll.}
# clipping region 
proc cdCanvasIsPointInRegion*(canvas: PCDCanvas; x: cint; y: cint): cint {.
    importc: "cdCanvasIsPointInRegion", dynlib: cd_dll.}
proc cdCanvasOffsetRegion*(canvas: PCDCanvas; x: cint; y: cint) {.
    importc: "cdCanvasOffsetRegion", dynlib: cd_dll.}
proc cdCanvasGetRegionBox*(canvas: PCDCanvas; xmin: ptr cint; 
                           xmax: ptr cint; ymin: ptr cint; ymax: ptr cint) {.
    importc: "cdCanvasGetRegionBox", dynlib: cd_dll.}
proc cdCanvasRegionCombineMode*(canvas: PCDCanvas; mode: cint): cint {.
    importc: "cdCanvasRegionCombineMode", dynlib: cd_dll.}
# primitives 
proc cdCanvasPixel*(canvas: PCDCanvas; x: cint; y: cint; color: clong) {.
    importc: "cdCanvasPixel", dynlib: cd_dll.}
proc cdCanvasMark*(canvas: PCDCanvas; x: cint; y: cint) {.
    importc: "cdCanvasMark", dynlib: cd_dll.}
proc cdCanvasBegin*(canvas: PCDCanvas; mode: cint) {.
    importc: "cdCanvasBegin", dynlib: cd_dll.}
proc cdCanvasPathSet*(canvas: PCDCanvas; action: cint) {.
    importc: "cdCanvasPathSet", dynlib: cd_dll.}
proc cdCanvasEnd*(canvas: PCDCanvas) {.importc: "cdCanvasEnd", 
    dynlib: cd_dll.}


# integer primitives
proc line*(canvas: PCDCanvas; x1,y1,x2,y2: cint) {.importc: "cdCanvasLine", dynlib: cd_dll.}
proc vertex*(canvas: PCDCanvas; x,y: cint) {.importc: "cdCanvasVertex", dynlib: cd_dll.}
proc rect*(canvas: PCDCanvas; xmin,xmax,ymin,ymax:cint) {.importc: "cdCanvasRect", dynlib: cd_dll.}
  ## Draws a rectangle on the canvas.
proc box*(canvas: PCDCanvas; xmin,xmax,ymin,ymax: cint) {.importc: "cdCanvasBox", dynlib: cd_dll.}
  ## Fills a rectangle on the canvas.
proc arc*(canvas: PCDCanvas; xc,yc,w,h:cint,angle1:cdouble,angle2:cdouble) {.importc: "cdCanvasArc", dynlib: cd_dll.}
proc sector*(canvas: PCDCanvas; xc,yc,w,h:cint,angle1,angle2: cdouble) {. importc: "cdCanvasSector", dynlib: cd_dll.}
proc chord*(canvas: PCDCanvas; xc,yc,w,h: cint; angle1: cdouble; angle2: cdouble) {. importc: "cdCanvasChord", dynlib: cd_dll.}
proc text*(canvas: PCDCanvas; x,y:cint,txt:cstring) {. importc: "cdCanvasText", dynlib: cd_dll.}

# floating point primitives
proc line*(canvas: PCDCanvas; x1,y1,x2,y2:cdouble) {.importc: "cdfCanvasLine", dynlib: cd_dll.}
proc vertex*(canvas: PCDCanvas; x,y: cdouble) {.importc: "cdfCanvasVertex", dynlib: cd_dll.}
proc rect*(canvas: PCDCanvas; xmin,xmax,ymin,ymax) {.importc: "cdfCanvasRect", dynlib: cd_dll.}
proc box*(canvas: PCDCanvas; xmin: cdouble; xmax: cdouble; ymin: cdouble; ymax: cdouble) {.importc: "cdfCanvasBox", dynlib: cd_dll.}
proc arc*(canvas: PCDCanvas; xc,yc,w,h,angle1,angle2:cdouble) {.importc: "cdfCanvasArc", dynlib: cd_dll.}
proc sector*(canvas: PCDCanvas; xc,yc,w,h,angle1,angle2:cdouble) {. importc: "cdfCanvasSector", dynlib: cd_dll.}
proc chord*(canvas: PCDCanvas;  xc,yc,w,h,angle1,angle2:cdouble) {. importc: "cdfCanvasChord", dynlib: cd_dll.}
proc text*(canvas: PCDCanvas; x,y:cdouble,s:string) {. importc: "cdfCanvasText", dynlib: cd_dll.}


# attributes 
proc cdCanvasSetBackground(canvas: PCDCanvas; color: clong) {. #*#
    importc: "cdCanvasSetBackground", dynlib: cd_dll.}
proc `background=` * (c:PCDCanvas,color:TColor)=
  ## Sets the current background color of the canvas.
  cdCanvasSetBackground(c,cast[clong](color))

proc cdCanvasSetForeground(canvas: PCDCanvas; color: clong) {. #*#
    importc: "cdCanvasSetForeground", dynlib: cd_dll.}
proc `foreground=`*(c:PCDCanvas,color:TColor)=
  ## Sets the current foreground color of the canvas.
  cdCanvasSetForeground(c,cast[clong](color))
   
proc cdCanvasBackground(canvas: PCDCanvas; color: clong): clong {. #*#
    importc: "cdCanvasBackground", dynlib: cd_dll.}
proc background*(c:PCDCanvas):TColor=
  ## Gets the current background color of the canvas.
  cast[TColor](cdCanvasBackground(c,CD_QUERY))
    
proc cdCanvasForeground(canvas: PCDCanvas; color: clong): clong {. #*#
    importc: "cdCanvasForeground", dynlib: cd_dll.}
proc foreground*(c:PCDCanvas):TColor=
  ## Gets the current foreground color of the canvas.
  cast[TColor](cdCanvasForeground(c,CD_QUERY))


proc cdCanvasBackOpacity*(canvas: PCDCanvas; opacity: cint): cint {.
    importc: "cdCanvasBackOpacity", dynlib: cd_dll.}
proc cdCanvasWriteMode*(canvas: PCDCanvas; mode: cint): cint {.
    importc: "cdCanvasWriteMode", dynlib: cd_dll.}
proc cdCanvasLineStyle*(canvas: PCDCanvas; style: cint): cint {.
    importc: "cdCanvasLineStyle", dynlib: cd_dll.}
proc cdCanvasLineStyleDashes*(canvas: PCDCanvas; dashes: ptr cint; 
                              count: cint) {.
    importc: "cdCanvasLineStyleDashes", dynlib: cd_dll.}
proc cdCanvasLineWidth*(canvas: PCDCanvas; width: cint): cint {.
    importc: "cdCanvasLineWidth", dynlib: cd_dll.}
proc cdCanvasLineJoin*(canvas: PCDCanvas; join: cint): cint {.
    importc: "cdCanvasLineJoin", dynlib: cd_dll.}
proc cdCanvasLineCap*(canvas: PCDCanvas; cap: cint): cint {.
    importc: "cdCanvasLineCap", dynlib: cd_dll.}
proc cdCanvasInteriorStyle*(canvas: PCDCanvas; style: cint): cint {.
    importc: "cdCanvasInteriorStyle", dynlib: cd_dll.}
proc cdCanvasHatch*(canvas: PCDCanvas; style: cint): cint {.
    importc: "cdCanvasHatch", dynlib: cd_dll.}
proc cdCanvasStipple*(canvas: PCDCanvas; w: cint; h: cint; 
                      stipple: ptr cuchar) {.importc: "cdCanvasStipple", 
    dynlib: cd_dll.}
proc cdCanvasGetStipple*(canvas: PCDCanvas; n: ptr cint; m: ptr cint): ptr cuchar {.
    importc: "cdCanvasGetStipple", dynlib: cd_dll.}
proc cdCanvasPattern*(canvas: PCDCanvas; w: cint; h: cint; 
                      pattern: ptr clong) {.importc: "cdCanvasPattern", 
    dynlib: cd_dll.}
proc cdCanvasGetPattern*(canvas: PCDCanvas; n: ptr cint; m: ptr cint): ptr clong {.
    importc: "cdCanvasGetPattern", dynlib: cd_dll.}
proc cdCanvasFillMode*(canvas: PCDCanvas; mode: cint): cint {.
    importc: "cdCanvasFillMode", dynlib: cd_dll.}
proc cdCanvasFont*(canvas: PCDCanvas; type_face: cstring; style: cint; 
                   size: cint): cint {.importc: "cdCanvasFont", dynlib: cd_dll.}
proc cdCanvasGetFont*(canvas: PCDCanvas; type_face: cstring; 
                      style: ptr cint; size: ptr cint) {.
    importc: "cdCanvasGetFont", dynlib: cd_dll.}
proc cdCanvasNativeFont*(canvas: PCDCanvas; font: cstring): cstring {.
    importc: "cdCanvasNativeFont", dynlib: cd_dll.}
proc cdCanvasTextAlignment*(canvas: PCDCanvas; alignment: cint): cint {.
    importc: "cdCanvasTextAlignment", dynlib: cd_dll.}
proc cdCanvasTextOrientation*(canvas: PCDCanvas; angle: cdouble): cdouble {.
    importc: "cdCanvasTextOrientation", dynlib: cd_dll.}
proc cdCanvasMarkType*(canvas: PCDCanvas; typ: cint): cint {.
    importc: "cdCanvasMarkType", dynlib: cd_dll.}
proc cdCanvasMarkSize*(canvas: PCDCanvas; size: cint): cint {.
    importc: "cdCanvasMarkSize", dynlib: cd_dll.}
# vector text 
proc cdCanvasVectorText*(canvas: PCDCanvas; x: cint; y: cint; s: cstring) {.
    importc: "cdCanvasVectorText", dynlib: cd_dll.}
proc cdCanvasMultiLineVectorText*(canvas: PCDCanvas; x: cint; y: cint; 
                                  s: cstring) {.
    importc: "cdCanvasMultiLineVectorText", dynlib: cd_dll.}
# vector text attributes 
proc cdCanvasVectorFont*(canvas: PCDCanvas; filename: cstring): cstring {.
    importc: "cdCanvasVectorFont", dynlib: cd_dll.}
proc cdCanvasVectorTextDirection*(canvas: PCDCanvas; x1: cint; y1: cint; 
                                  x2: cint; y2: cint) {.
    importc: "cdCanvasVectorTextDirection", dynlib: cd_dll.}
proc cdCanvasVectorTextTransform*(canvas: PCDCanvas; matrix: ptr cdouble): ptr cdouble {.
    importc: "cdCanvasVectorTextTransform", dynlib: cd_dll.}
proc cdCanvasVectorTextSize*(canvas: PCDCanvas; size_x: cint; size_y: cint; 
                             s: cstring) {.importc: "cdCanvasVectorTextSize", 
    dynlib: cd_dll.}
proc cdCanvasVectorCharSize*(canvas: PCDCanvas; size: cint): cint {.
    importc: "cdCanvasVectorCharSize", dynlib: cd_dll.}
proc cdCanvasVectorFontSize*(canvas: PCDCanvas; size_x: cdouble; 
                             size_y: cdouble) {.
    importc: "cdCanvasVectorFontSize", dynlib: cd_dll.}
proc cdCanvasGetVectorFontSize*(canvas: PCDCanvas; size_x: ptr cdouble; 
                                size_y: ptr cdouble) {.
    importc: "cdCanvasGetVectorFontSize", dynlib: cd_dll.}
# vector text properties 
proc cdCanvasGetVectorTextSize*(canvas: PCDCanvas; s: cstring; x: ptr cint; 
                                y: ptr cint) {.
    importc: "cdCanvasGetVectorTextSize", dynlib: cd_dll.}
proc cdCanvasGetVectorTextBounds*(canvas: PCDCanvas; s: cstring; x: cint; 
                                  y: cint; rect: ptr cint) {.
    importc: "cdCanvasGetVectorTextBounds", dynlib: cd_dll.}
proc cdCanvasGetVectorTextBox*(canvas: PCDCanvas; x: cint; y: cint; 
                               s: cstring; xmin: ptr cint; xmax: ptr cint; 
                               ymin: ptr cint; ymax: ptr cint) {.
    importc: "cdCanvasGetVectorTextBox", dynlib: cd_dll.}
proc cdfCanvasVectorTextDirection*(canvas: PCDCanvas; x1: cdouble; 
                                   y1: cdouble; x2: cdouble; y2: cdouble) {.
    importc: "cdfCanvasVectorTextDirection", dynlib: cd_dll.}
proc cdfCanvasVectorTextSize*(canvas: PCDCanvas; size_x: cdouble; 
                              size_y: cdouble; s: cstring) {.
    importc: "cdfCanvasVectorTextSize", dynlib: cd_dll.}
proc cdfCanvasGetVectorTextSize*(canvas: PCDCanvas; s: cstring; 
                                 x: ptr cdouble; y: ptr cdouble) {.
    importc: "cdfCanvasGetVectorTextSize", dynlib: cd_dll.}
proc cdfCanvasVectorCharSize*(canvas: PCDCanvas; size: cdouble): cdouble {.
    importc: "cdfCanvasVectorCharSize", dynlib: cd_dll.}
proc cdfCanvasVectorText*(canvas: PCDCanvas; x: cdouble; y: cdouble; 
                          s: cstring) {.importc: "cdfCanvasVectorText", 
    dynlib: cd_dll.}
proc cdfCanvasMultiLineVectorText*(canvas: PCDCanvas; x: cdouble; 
                                   y: cdouble; s: cstring) {.
    importc: "cdfCanvasMultiLineVectorText", dynlib: cd_dll.}
proc cdfCanvasGetVectorTextBounds*(canvas: PCDCanvas; s: cstring; 
                                   x: cdouble; y: cdouble; rect: ptr cdouble) {.
    importc: "cdfCanvasGetVectorTextBounds", dynlib: cd_dll.}
proc cdfCanvasGetVectorTextBox*(canvas: PCDCanvas; x: cdouble; y: cdouble; 
                                s: cstring; xmin: ptr cdouble; 
                                xmax: ptr cdouble; ymin: ptr cdouble; 
                                ymax: ptr cdouble) {.
    importc: "cdfCanvasGetVectorTextBox", dynlib: cd_dll.}
# properties 
proc cdCanvasGetFontDim*(canvas: PCDCanvas; max_width: ptr cint; 
                         height: ptr cint; ascent: ptr cint; descent: ptr cint) {.
    importc: "cdCanvasGetFontDim", dynlib: cd_dll.}
proc cdCanvasGetTextSize*(canvas: PCDCanvas; s: cstring; width: ptr cint; 
                          height: ptr cint) {.importc: "cdCanvasGetTextSize", 
    dynlib: cd_dll.}
proc cdCanvasGetTextBox*(canvas: PCDCanvas; x: cint; y: cint; s: cstring; 
                         xmin: ptr cint; xmax: ptr cint; ymin: ptr cint; 
                         ymax: ptr cint) {.importc: "cdCanvasGetTextBox", 
    dynlib: cd_dll.}
proc cdCanvasGetTextBounds*(canvas: PCDCanvas; x: cint; y: cint; 
                            s: cstring; rect: ptr cint) {.
    importc: "cdCanvasGetTextBounds", dynlib: cd_dll.}
proc cdCanvasGetColorPlanes*(canvas: PCDCanvas): cint {.
    importc: "cdCanvasGetColorPlanes", dynlib: cd_dll.}
# color 
proc cdCanvasPalette*(canvas: PCDCanvas; n: cint; palette: ptr clong; 
                      mode: cint) {.importc: "cdCanvasPalette", dynlib: cd_dll.}
# client images 
proc cdCanvasGetImageRGB*(canvas: PCDCanvas; r: ptr cuchar; g: ptr cuchar; 
                          b: ptr cuchar; x: cint; y: cint; w: cint; h: cint) {.
    importc: "cdCanvasGetImageRGB", dynlib: cd_dll.}
proc cdCanvasPutImageRectRGB*(canvas: PCDCanvas; iw: cint; ih: cint; 
                              r: ptr cuchar; g: ptr cuchar; b: ptr cuchar; 
                              x: cint; y: cint; w: cint; h: cint; xmin: cint; 
                              xmax: cint; ymin: cint; ymax: cint) {.
    importc: "cdCanvasPutImageRectRGB", dynlib: cd_dll.}
proc cdCanvasPutImageRectRGBA*(canvas: PCDCanvas; iw: cint; ih: cint; 
                               r: ptr cuchar; g: ptr cuchar; b: ptr cuchar; 
                               a: ptr cuchar; x: cint; y: cint; w: cint; 
                               h: cint; xmin: cint; xmax: cint; ymin: cint; 
                               ymax: cint) {.
    importc: "cdCanvasPutImageRectRGBA", dynlib: cd_dll.}
proc cdCanvasPutImageRectMap*(canvas: PCDCanvas; iw: cint; ih: cint; 
                              index: ptr cuchar; colors: ptr clong; x: cint; 
                              y: cint; w: cint; h: cint; xmin: cint; 
                              xmax: cint; ymin: cint; ymax: cint) {.
    importc: "cdCanvasPutImageRectMap", dynlib: cd_dll.}
# server images 
proc cdCanvasCreateImage*(canvas: PCDCanvas; w: cint; h: cint): PCDImage {.
    importc: "cdCanvasCreateImage", dynlib: cd_dll.}
proc cdKillImage*(image: PCDImage) {.importc: "cdKillImage", dynlib: cd_dll.}
proc cdCanvasGetImage*(canvas: PCDCanvas; image: PCDImage; x: cint; 
                       y: cint) {.importc: "cdCanvasGetImage", dynlib: cd_dll.}
proc cdCanvasPutImageRect*(canvas: PCDCanvas; image: PCDImage; x: cint; 
                           y: cint; xmin: cint; xmax: cint; ymin: cint; 
                           ymax: cint) {.importc: "cdCanvasPutImageRect", 
    dynlib: cd_dll.}
proc cdCanvasScrollArea*(canvas: PCDCanvas; xmin: cint; xmax: cint; 
                         ymin: cint; ymax: cint; dx: cint; dy: cint) {.
    importc: "cdCanvasScrollArea", dynlib: cd_dll.}
# bitmap 
proc cdCreateBitmap*(w: cint; h: cint; typ: cint): ptr cdBitmap {.
    importc: "cdCreateBitmap", dynlib: cd_dll.}
proc cdInitBitmap*(w: cint; h: cint; typ: cint): ptr cdBitmap {.varargs, 
    importc: "cdInitBitmap", dynlib: cd_dll.}
proc cdKillBitmap*(bitmap: ptr cdBitmap) {.importc: "cdKillBitmap", 
    dynlib: cd_dll.}
proc cdBitmapGetData*(bitmap: ptr cdBitmap; dataptr: cint): ptr cuchar {.
    importc: "cdBitmapGetData", dynlib: cd_dll.}
proc cdBitmapSetRect*(bitmap: ptr cdBitmap; xmin: cint; xmax: cint; 
                      ymin: cint; ymax: cint) {.importc: "cdBitmapSetRect", 
    dynlib: cd_dll.}
proc cdCanvasPutBitmap*(canvas: PCDCanvas; bitmap: ptr cdBitmap; x: cint; 
                        y: cint; w: cint; h: cint) {.
    importc: "cdCanvasPutBitmap", dynlib: cd_dll.}
proc cdCanvasGetBitmap*(canvas: PCDCanvas; bitmap: ptr cdBitmap; x: cint; 
                        y: cint) {.importc: "cdCanvasGetBitmap", 
                                   dynlib: cd_dll.}
proc cdBitmapRGB2Map*(bitmap_rgb: ptr cdBitmap; bitmap_map: ptr cdBitmap) {.
    importc: "cdBitmapRGB2Map", dynlib: cd_dll.}
# color 
proc cdEncodeColor*(red: cuchar; green: cuchar; blue: cuchar): clong {.
    importc: "cdEncodeColor", dynlib: cd_dll.}
proc cdDecodeColor*(color: clong; red: ptr cuchar; green: ptr cuchar; 
                    blue: ptr cuchar) {.importc: "cdDecodeColor", 
    dynlib: cd_dll.}
proc cdDecodeAlpha*(color: clong): cuchar {.importc: "cdDecodeAlpha", 
    dynlib: cd_dll.}
proc cdEncodeAlpha*(color: clong; alpha: cuchar): clong {.
    importc: "cdEncodeAlpha", dynlib: cd_dll.}
template cdAlpha*(col: expr): expr = 
  cast[cuchar]((not (((col) shr 24) and 0x000000FF)))

template cdReserved*(col: expr): expr = 
  cast[cuchar]((((col) shr 24) and 0x000000FF))

template cdRed*(col: expr): expr = 
  cast[cuchar]((((col) shr 16) and 0x000000FF))

template cdGreen*(col: expr): expr = 
  cast[cuchar]((((col) shr 8) and 0x000000FF))

template cdBlue*(col: expr): expr = 
  cast[cuchar]((((col) shr 0) and 0x000000FF))

# client image color convertion 
proc cdRGB2Map*(width: cint; height: cint; red: ptr cuchar; green: ptr cuchar; 
                blue: ptr cuchar; index: ptr cuchar; pal_size: cint; 
                color: ptr clong) {.importc: "cdRGB2Map", dynlib: cd_dll.}
type 
  cdSizeCallback* = proc (canvas: PCDCanvas; w: cint; h: cint; w_mm: cdouble; 
                    h_mm: cdouble): cint
const 
  CD_ABORT* = 1
  CD_CONTINUE* = 0

# simulation flags 
const 
  CD_SIM_NONE* = 0x00000000
  CD_SIM_LINE* = 0x00000001
  CD_SIM_RECT* = 0x00000002
  CD_SIM_BOX* = 0x00000004
  CD_SIM_ARC* = 0x00000008
  CD_SIM_SECTOR* = 0x00000010
  CD_SIM_CHORD* = 0x00000020
  CD_SIM_POLYLINE* = 0x00000040
  CD_SIM_POLYGON* = 0x00000080
  CD_SIM_TEXT* = 0x00000100
  CD_SIM_ALL* = 0x0000FFFF
  CD_SIM_LINES* = (CD_SIM_LINE or CD_SIM_RECT or CD_SIM_ARC or
      CD_SIM_POLYLINE)
  CD_SIM_FILLS* = (
    CD_SIM_BOX or CD_SIM_SECTOR or CD_SIM_CHORD or CD_SIM_POLYGON)


# note: color constants of cd removed, use colors module

# some usefull conversion factors 
const 
  CD_MM2PT* = 2.834645669         # milimeters to points (pt = CD_MM2PT * mm) 
  CD_RAD2DEG* = 57.295779513      # radians to degrees (deg = CD_RAD2DEG * rad) 
  CD_DEG2RAD* = 0.01745329252     # degrees to radians (rad = CD_DEG2RAD * deg) 
# paper sizes 
const 
  CD_A0* = 0
  CD_A1* = 1
  CD_A2* = 2
  CD_A3* = 3
  CD_A4* = 4
  CD_A5* = 5
  CD_LETTER* = 6
  CD_LEGAL* = 7
  
  
# *******************************
#     Contexts
# *******************************
proc cdContextIup*:PCDContext {.importc: "cdContextIup", dynlib: iupcd_dll.}





template CD_IUP* =cdContextIup()


#*****************************************************************************
#Copyright (C) 1994-2013 Tecgraf, PUC-Rio.
#
#Permission is hereby granted, free of charge, to any person obtaining
#a copy of this software and associated documentation files (the
#"Software"), to deal in the Software without restriction, including
#without limitation the rights to use, copy, modify, merge, publish,
#distribute, sublicense, and/or sell copies of the Software, and to
#permit persons to whom the Software is furnished to do so, subject to
#the following conditions:
#
#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#****************************************************************************