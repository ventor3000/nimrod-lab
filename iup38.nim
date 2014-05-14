
#---- IUPCD (IUPIM)(IUPLUA)

#
#     Binding for the IUP GUI toolkit
#     (c) 2012 Andreas Rumpf 
#     C header files translated by hand
#
#     Major update June 2013 by Robert Persson
#     to support the full power of IUP 3.8 
#     Old wrapper was for<=IUP3.0 RC2, and some stuff was missing
#     
#     Licence of IUP follows:
#
#******************************************************************************
# Copyright (C) 1994-2013 Tecgraf, PUC-Rio.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#*****************************************************************************/

{.deadCodeElim: on.}

proc EnableTheming() #hack-wrap to enable theming under windows/does nothing under other OS:es

when defined(windows): 
  const 
    iup_dll = "iup(38|30|).dll"
    iupcontrols_dll = "iupcontrols(38|30|).dll"
    iup_pplot_dll = "iup_pplot(38|30|).dll"
    iup_scintilla_dll = "iup_scintilla(38|).dll"
    iupgl_dll = "iupgl(38|30|).dll"
    iupole_dll = "iupole(38|30|).dll" #only windows
    iupimglib_dll =  "iupimglib(38|30|).dll"
    iupweb_dll =  "iupweb(38|30|).dll"
    iuptuio_dll =  "iuptuio(38|30|).dll"
    iup_mglplot_dll =  "iup_mglplot(38|30|).dll"
elif defined(macosx):
  const 
    iup_dll = "libiup(3.8|3.0|).dylib"
    iupcontrols_dll = "libiupcontrols(3.8|3.0|).dylib"
    iup_pplot_dll = "libiup_pplot(3.8|3.0|).dylib"
    iup_scintilla_dll = "libiup_scintilla(3.8|).dylib"
    iupgl_dll = "libiupgl(3.8|3.0|).dylib"
    iupole_dll = "libiupole(3.8|3.0|).dylib" #never exists, but must be defined
    iupwebimglib_dll = "libiupimglib(3.8|3.0|).dylib"
    iupweb_dll = "libiupweb(3.8|3.0|).dylib"
    iuptuio_dll = "libiuptuio(3.8|3.0|).dylib"
    iup_mglplot_dll = "libiup_mglplot(3.8|3.0|).dylib"
else: 
  const 
    iup_dll = "libiup(3.8|3.0|).so"
    iupcontrols_dll = "libiupcontrols(3.8|3.0|).so"
    iup_pplot_dll = "libiup_pplot(3.8|3.0|).so"
    iup_scintilla_dll = "libiup_scintilla(3.8|).so"
    iupgl_dll="libiupgl(3.8|3.0|).so"
    iupole_dll="libiupole(3.8|3.0|).so" #never exists, but must be defined
    iupimglib_dll="libiupimglib(3.8|3.0|).so"
    iupweb_dll="libiupweb(3.8|3.0|).so"
    iuptuio_dll="libiuptuio(3.8|3.0|).so"
    iup_mglplot_dll="libiup_mglplot(3.8|3.0|).so"


# Fixed port from IUP3.0 RC2 (since functions from RC3 and forward missing) to IUP3.8 doing the following:
# Fixed windows iup_dll ending with | since the commonly used name is iup.dll
# 
# Removed constants describing version specific (constIUP_VERSION, constIUP_VERSION_NUMBER etc.)
#
# Added functions from IUP3.0 RC3 until IUP3.8, and some missing old stuff (mostly opengl things):
#   SaveImageAsString (3.0 RC3)
#   LoadBuffer (3.0 RC3)
#   Clipboard (3.0 RC3)
#   LoopStepWait (3.0)
#   Split (3.1)
#   ResetAttribute (3.2)
#   RefreshChildren (3.3)
#   LayoutDialog (3.3)
#   CopyClassAttributes (3.3)
#   GetClassCallbacks (3.3)
#   GetAllClasses (3.3)
#   SetAttributeId (3.3)
#   StoreAttributeId (3.3)
#   GetAttributeId (3.3)
#   GetFloatId (3.3)
#   GetIntId (3.3)
#   SetfAttributeId (3.3)
#   SetAttributeId2 (3.3)
#   StoreAttributeId2 (3.3)
#   GetAttributeId2 (3.3)
#   GetFloatId2 (3.3)
#   GetIntId2 (3.3)
#   SetfAttributeId2 (3.3)
#   ClassMatch (3.4)
#   PPlotInsertStrPoints  (3.4)
#   PPlotInsertPoints  (3.4)
#   PPlotAddPoints (3.4)
#   PPlotAddStrPoints (3.4)
#   RecordInput (along with constants) (3.4)
#   PlayInput (3.4)
#   ElementPropertiesDialog (3.5)
#   ScrollBox (3.7)
#   Link (3.8)
#   GridBox (3.8)
#   GridBoxv (3.8)
#   ScintillaOpen (3.8)*tested*
#   Scintilla (3.8)*tested*
#   GLCanvasOpen (old/missing)
#   GLCanvas (old/missing)
#   GLMakeCurrent (old/missing)
#   GLIsCurrent (old/missing)
#   GLSwapBuffers (old/missing)
#   GLPalette (old/missing)
#   GLUseFont (old/missing)
#   GLWait (old/missing)
#   OleControl (old/missing)*tested*
#   OleControlOpen (old/missing)*tested*
#   WebBrowserOpen (3.3)*tested*
#   WebBrowser  (3.0)*tested*
#   TuioOpen (3.3) *tested*
#   TuioClient (3.3) *tested*
#   MglPlotOpen (3.6) *tested*
#   MglPlot (3.6) *tested*
#   MglPlotBegin (3.6)
#   MglPlotAdd1D (3.6)
#   MglPlotAdd2D (3.6)
#   MglPlotAdd3D (3.6)
#   MglPlotEnd (3.6)
#   MglPlotNewDataSet (3.6)
#   MglPlotInsert1D (3.6)
#   MglPlotInsert2D (3.6)
#   MglPlotInsert3D (3.6)
#   MglPlotSet1D (3.6)
#   MglPlotSet2D (3.6)
#   MglPlotSet3D (3.6)
#   MglPlotSetFormula (3.6)
#   MglPlotSetData (3.6)
#   MglPlotLoadData (3.6)
#   MglPlotSetFromFormula
#   MglPlotTransform (3.6)
#   MglPlotTransformXYZ (3.6)
#   MglPlotDrawMark (3.6)
#   MglPlotDrawLine (3.6)
#   MglPlotDrawText (3.6)
#   MglPlotPaintTo (3.6)














# Removed the following obsolete functions that does nothing:
#   ControlsClose
#   OldValOpen
#   OldTabsOpen

# Fixed correct dynlink references for iupcontrols/iupimglib
# Removed references to older dynlibs:s than iup 3.0 (possibly incompatible)
# Made all Iup*Open(...) that returns something functions discardable
# Update license notice copied from iup.h v3.8

type
  Ihandle {.pure.} = object
  PIhandle* = ptr Ihandle

  Icallback* = proc (arg: PIhandle): cint {.cdecl.}

  GetFileResult * = enum
    gfCancel= -1,
    gfExistingFile= 0,
    gfNewFile= 1
    
    
 
# pre-definided dialogs
proc FileDlg*: PIhandle {.importc: "IupFileDlg", dynlib: iup_dll, cdecl.}
proc MessageDlg*: PIhandle {.importc: "IupMessageDlg", dynlib: iup_dll, cdecl.}
proc ColorDlg*: PIhandle {.importc: "IupColorDlg", dynlib: iup_dll, cdecl.}
proc FontDlg*: PIhandle {.importc: "IupFontDlg", dynlib: iup_dll, cdecl.}


proc stringToCharArray(str:string,arr:var openArray[char])=
  
  var index=0
  for ch in str:
    arr[index]=ch
    inc index
  
  arr[index]='\0'
    
    
  
  
  

proc getFileInternal(filename: cstring): cint {.importc: "IupGetFile", dynlib: iup_dll, cdecl.}
proc getFile* (filename: var string):GetFileResult =
  ## Shows a modal dialog of the native interface system to select a filename. 
  ## Uses the fileDlg element internally.
  ## `filename`: This parameter is used as an input value to define the default filter and directory. 
  ## Example: "../docs/*.txt". As an output value, it is used to contain the filename entered by the user.
  ## Returns `gfNewFile`, `gfExistingFile` or `gfCancel` if canceled by user.
  var buf {.noinit.}: array[0..2500, char]
  
  stringToCharArray(filename,buf)
  
  result=GetFileResult(getFileInternal(buf))
  if(result>=gfExistingFile):
    filename= $buf


proc Message*(title, msg: cstring) {.
  importc: "IupMessage", dynlib: iup_dll, cdecl.}
proc Messagef*(title, format: cstring) {.
  importc: "IupMessagef", dynlib: iup_dll, cdecl, varargs.}
proc Alarm*(title, msg, b1, b2, b3: cstring): cint {.
  importc: "IupAlarm", dynlib: iup_dll, cdecl.}
proc Scanf*(format: cstring): cint {.
  importc: "IupScanf", dynlib: iup_dll, cdecl, varargs.}
proc ListDialog*(theType: cint, title: cstring, size: cint, 
                 list: cstringArray, op, max_col, max_lin: cint, 
                 marks: ptr cint): cint {.
                 importc: "IupListDialog", dynlib: iup_dll, cdecl.}
proc GetText*(title, text: cstring): cint {.
  importc: "IupGetText", dynlib: iup_dll, cdecl.}
proc GetColor*(x, y: cint, r, g, b: var byte): cint {.
  importc: "IupGetColor", dynlib: iup_dll, cdecl.}

proc LayoutDialog*(dialog:PIhandle): PIHandle {.
  importc: "IupLayoutDialog", dynlib: iup_dll, cdecl.}
proc ElementPropertiesDialog*(dialog:PIhandle): PIHandle {.
  importc: "IupElementPropertiesDialog", dynlib: iup_dll, cdecl.}


type
  Iparamcb* = proc (dialog: PIhandle, param_index: cint, 
                    user_data: pointer): cint {.cdecl.}

proc GetParam*(title: cstring, action: Iparamcb, user_data: pointer, 
               format: cstring): cint {.
               importc: "IupGetParam", cdecl, varargs, dynlib: iup_dll.}
proc GetParamv*(title: cstring, action: Iparamcb, user_data: pointer, 
                format: cstring, param_count, param_extra: cint, 
                param_data: pointer): cint {.
                importc: "IupGetParamv", cdecl, dynlib: iup_dll.}


#                      Functions

proc InternalOpen(argc: ptr cint, argv: ptr cstringArray):cint {. importc: "IupOpen", cdecl, dynlib: iup_dll.}



proc Open*(argc: ptr cint, argv: ptr cstringArray,usetheming=true):cint {.discardable.}=
  if usetheming:
    EnableTheming() 
  return InternalOpen(argc,argv)
  

proc Close*() {.importc: "IupClose", cdecl, dynlib: iup_dll.}

proc MainLoop*(): cint {.importc: "IupMainLoop", cdecl, dynlib: iup_dll, 
                         discardable.}
proc LoopStep*(): cint {.importc: "IupLoopStep", cdecl, dynlib: iup_dll,
                         discardable.}

proc LoopStepWait*(): cint {.importc:"IupLoopStepWait", cdecl, dynlib: iup_dll,
                         discardable.}

proc MainLoopLevel*(): cint {.importc: "IupMainLoopLevel", cdecl, 
                              dynlib: iup_dll, discardable.}
proc Flush*() {.importc: "IupFlush", cdecl, dynlib: iup_dll.}
proc ExitLoop*() {.importc: "IupExitLoop", cdecl, dynlib: iup_dll.}

proc RecordInput*(filename:cstring,mode:cint):cint {.importc: "IupRecordInput", cdecl, dynlib: iup_dll.}
proc PlayInput*(filename:cstring):cint {.importc: "IupPlayInput", cdecl, dynlib: iup_dll.}

proc Update*(ih: PIhandle) {.importc: "IupUpdate", cdecl, dynlib: iup_dll.}
proc UpdateChildren*(ih: PIhandle) {.importc: "IupUpdateChildren", cdecl, dynlib: iup_dll.}
proc Redraw*(ih: PIhandle, children: cint) {.importc: "IupRedraw", cdecl, dynlib: iup_dll.}
proc Refresh*(ih: PIhandle) {.importc: "IupRefresh", cdecl, dynlib: iup_dll.}
proc RefreshChildren*(ih: PIhandle) {.importc: "IupRefreshChildren", cdecl, dynlib: iup_dll.}

proc MapFont*(iupfont: cstring): cstring {.importc: "IupMapFont", cdecl, dynlib: iup_dll.}
proc UnMapFont*(driverfont: cstring): cstring {.importc: "IupUnMapFont", cdecl, dynlib: iup_dll.}
proc Help*(url: cstring): cint {.importc: "IupHelp", cdecl, dynlib: iup_dll.}
proc Load*(filename: cstring): cstring {.importc: "IupLoad", cdecl, dynlib: iup_dll.}
proc LoadBuffer*(filename: cstring): cstring {.importc: "IupLoadBuffer", cdecl, dynlib: iup_dll.}

proc IupVersion*(): cstring {.importc: "IupVersion", cdecl, dynlib: iup_dll.}
proc IupVersionDate*(): cstring {.importc: "IupVersionDate", cdecl, dynlib: iup_dll.}
proc IupVersionNumber*(): cint {.importc: "IupVersionNumber", cdecl, dynlib: iup_dll.}
proc SetLanguage*(lng: cstring) {.importc: "IupSetLanguage", cdecl, dynlib: iup_dll.}
proc GetLanguage*(): cstring {.importc: "IupGetLanguage", cdecl, dynlib: iup_dll.}

proc Destroy*(ih: PIhandle) {.importc: "IupDestroy", cdecl, dynlib: iup_dll.}
proc Detach*(child: PIhandle) {.importc: "IupDetach", cdecl, dynlib: iup_dll.}
proc Append*(ih, child: PIhandle): PIhandle {.
  importc: "IupAppend", cdecl, dynlib: iup_dll, discardable.}
proc Insert*(ih, ref_child, child: PIhandle): PIhandle {.
  importc: "IupInsert", cdecl, dynlib: iup_dll, discardable.}
proc GetChild*(ih: PIhandle, pos: cint): PIhandle {.
  importc: "IupGetChild", cdecl, dynlib: iup_dll.}
proc GetChildPos*(ih, child: PIhandle): cint {.
  importc: "IupGetChildPos", cdecl, dynlib: iup_dll.}
proc GetChildCount*(ih: PIhandle): cint {.
  importc: "IupGetChildCount", cdecl, dynlib: iup_dll.}
proc GetNextChild*(ih, child: PIhandle): PIhandle {.
  importc: "IupGetNextChild", cdecl, dynlib: iup_dll.}
proc GetBrother*(ih: PIhandle): PIhandle {.
  importc: "IupGetBrother", cdecl, dynlib: iup_dll.}
proc GetParent*(ih: PIhandle): PIhandle {.
  importc: "IupGetParent", cdecl, dynlib: iup_dll.}
proc GetDialog*(ih: PIhandle): PIhandle {.
  importc: "IupGetDialog", cdecl, dynlib: iup_dll.}
proc GetDialogChild*(ih: PIhandle, name: cstring): PIhandle {.
  importc: "IupGetDialogChild", cdecl, dynlib: iup_dll.}
proc Reparent*(ih, new_parent: PIhandle): cint {.
  importc: "IupReparent", cdecl, dynlib: iup_dll.}

proc Popup*(ih: PIhandle, x, y: cint): cint {.
  importc: "IupPopup", cdecl, dynlib: iup_dll, discardable.}
proc Show*(ih: PIhandle): cint {.
  importc: "IupShow", cdecl, dynlib: iup_dll, discardable.}
proc ShowXY*(ih: PIhandle, x, y: cint): cint {.
  importc: "IupShowXY", cdecl, dynlib: iup_dll, discardable.}
proc Hide*(ih: PIhandle): cint {.
  importc: "IupHide", cdecl, dynlib: iup_dll, discardable.}
proc Map*(ih: PIhandle): cint {.
  importc: "IupMap", cdecl, dynlib: iup_dll, discardable.}
proc Unmap*(ih: PIhandle) {.
  importc: "IupUnmap", cdecl, dynlib: iup_dll, discardable.}

proc SetAttribute*(ih: PIhandle, name, value: cstring) {.
  importc: "IupSetAttribute", cdecl, dynlib: iup_dll.}
proc StoreAttribute*(ih: PIhandle, name, value: cstring) {.
  importc: "IupStoreAttribute", cdecl, dynlib: iup_dll.}
proc SetAttributes*(ih: PIhandle, str: cstring): PIhandle {.
  importc: "IupSetAttributes", cdecl, dynlib: iup_dll.}
proc GetAttribute*(ih: PIhandle, name: cstring): cstring {.
  importc: "IupGetAttribute", cdecl, dynlib: iup_dll.}
proc GetAttributes*(ih: PIhandle): cstring {.
  importc: "IupGetAttributes", cdecl, dynlib: iup_dll.}
proc GetInt*(ih: PIhandle, name: cstring): cint {.
  importc: "IupGetInt", cdecl, dynlib: iup_dll.}
proc GetInt2*(ih: PIhandle, name: cstring): cint {.
  importc: "IupGetInt2", cdecl, dynlib: iup_dll.}
proc GetIntInt*(ih: PIhandle, name: cstring, i1, i2: var cint): cint {.
  importc: "IupGetIntInt", cdecl, dynlib: iup_dll.}
proc GetFloat*(ih: PIhandle, name: cstring): cfloat {.
  importc: "IupGetFloat", cdecl, dynlib: iup_dll.}
proc SetfAttribute*(ih: PIhandle, name, format: cstring) {.
  importc: "IupSetfAttribute", cdecl, dynlib: iup_dll, varargs.}
proc ResetAttribute*(ih: PIhandle, name: cstring) {.
  importc: "IupResetAttribute", cdecl, dynlib: iup_dll, varargs.}
proc GetAllAttributes*(ih: PIhandle, names: cstringArray, n: cint): cint {.
  importc: "IupGetAllAttributes", cdecl, dynlib: iup_dll.}
proc SetAtt*(handle_name: cstring, ih: PIhandle, name: cstring): PIhandle {.
  importc: "IupSetAtt", cdecl, dynlib: iup_dll, varargs, discardable.}

proc SetAttributeId*(ih:PIHandle,name:cstring,id:cint,value:cstring) {.importc: "IupSetAttribute", cdecl, dynlib: iup_dll.}
proc StoreAttributeId*(ih:PIHandle,name:cstring,id:cint,value:cstring) {.importc: "IupStoreAttributeId", cdecl, dynlib: iup_dll.}
proc GetAttributeId*(ih:PIHandle,name:cstring,id:cint):cstring {.importc: "IupGetAttributeId", cdecl, dynlib: iup_dll.}
proc GetFloatId*(ih:PIHandle,name:cstring,id:cint):cfloat {.importc: "IupGetFloatId", cdecl, dynlib: iup_dll.}
proc GetIntId*(ih:PIHandle,name:cstring,id:cint):cint {.importc: "IupGetIntId", cdecl, dynlib: iup_dll.}
proc SetfAttributeId*(ih:PIHandle,name:cstring,id:cint) {.importc: "IupSetfAttributeId", cdecl, dynlib: iup_dll, varargs.}

proc SetAttributeId2*(ih:PIHandle,name:cstring, lin,col:cint,value:cstring) {.importc: "IupSetAttribute2", cdecl, dynlib: iup_dll.}
proc StoreAttributeId2*(ih:PIHandle,name:cstring, lin,col:cint,value:cstring) {.importc: "IupStoreAttributeId2", cdecl, dynlib: iup_dll.}
proc GetAttributeId2*(ih:PIHandle,name:cstring, lin,col:cint):cstring {.importc: "IupGetAttributeId2", cdecl, dynlib: iup_dll.}
proc GetFloatId2*(ih:PIHandle,name:cstring, lin,col:cint):cfloat {.importc: "IupGetFloatId2", cdecl, dynlib: iup_dll.}
proc GetIntId2*(ih:PIHandle,name:cstring, lin,col:cint):cint {.importc: "IupGetIntId2", cdecl, dynlib: iup_dll.}
proc SetfAttributeId2*(ih:PIHandle,name:cstring, lin,col:cint) {.importc: "IupSetfAttributeId2", cdecl, dynlib: iup_dll, varargs.}


proc SetGlobal*(name, value: cstring) {.
  importc: "IupSetGlobal", cdecl, dynlib: iup_dll.}
proc StoreGlobal*(name, value: cstring) {.
  importc: "IupStoreGlobal", cdecl, dynlib: iup_dll.}
proc GetGlobal*(name: cstring): cstring {.
  importc: "IupGetGlobal", cdecl, dynlib: iup_dll.}

proc SetFocus*(ih: PIhandle): PIhandle {.
  importc: "IupSetFocus", cdecl, dynlib: iup_dll.}
proc GetFocus*(): PIhandle {.
  importc: "IupGetFocus", cdecl, dynlib: iup_dll.}
proc PreviousField*(ih: PIhandle): PIhandle {.
  importc: "IupPreviousField", cdecl, dynlib: iup_dll.}
proc NextField*(ih: PIhandle): PIhandle {.
  importc: "IupNextField", cdecl, dynlib: iup_dll.}

proc GetCallback*(ih: PIhandle, name: cstring): Icallback {.
  importc: "IupGetCallback", cdecl, dynlib: iup_dll.}
proc SetCallback*(ih: PIhandle, name: cstring, func: Icallback): Icallback {.
  importc: "IupSetCallback", cdecl, dynlib: iup_dll, discardable.}
  
proc SetCallbacks*(ih: PIhandle, name: cstring, func: Icallback): PIhandle {.
  importc: "IupSetCallbacks", cdecl, dynlib: iup_dll, varargs, discardable.}

proc GetFunction*(name: cstring): Icallback {.
  importc: "IupGetFunction", cdecl, dynlib: iup_dll.}
proc SetFunction*(name: cstring, func: Icallback): Icallback {.
  importc: "IupSetFunction", cdecl, dynlib: iup_dll, discardable.}
proc GetActionName*(): cstring {.
  importc: "IupGetActionName", cdecl, dynlib: iup_dll.}

proc GetHandle*(name: cstring): PIhandle {.
  importc: "IupGetHandle", cdecl, dynlib: iup_dll.}
proc SetHandle*(name: cstring, ih: PIhandle): PIhandle {.
  importc: "IupSetHandle", cdecl, dynlib: iup_dll.}
proc GetAllNames*(names: cstringArray, n: cint): cint {.
  importc: "IupGetAllNames", cdecl, dynlib: iup_dll.}
proc GetAllDialogs*(names: cstringArray, n: cint): cint {.
  importc: "IupGetAllDialogs", cdecl, dynlib: iup_dll.}
proc GetName*(ih: PIhandle): cstring {.
  importc: "IupGetName", cdecl, dynlib: iup_dll.}

proc SetAttributeHandle*(ih: PIhandle, name: cstring, ih_named: PIhandle) {.
  importc: "IupSetAttributeHandle", cdecl, dynlib: iup_dll.}
proc GetAttributeHandle*(ih: PIhandle, name: cstring): PIhandle {.
  importc: "IupGetAttributeHandle", cdecl, dynlib: iup_dll.}

proc GetClassName*(ih: PIhandle): cstring {.
  importc: "IupGetClassName", cdecl, dynlib: iup_dll.}
proc GetClassType*(ih: PIhandle): cstring {.
  importc: "IupGetClassType", cdecl, dynlib: iup_dll.}
proc GetAllClasses*(names: ptr cstring, c:cint):cint {.
  importc: "IupGetAllClasses", cdecl, dynlib: iup_dll.}
proc GetClassAttributes*(classname: cstring, names: cstringArray, n: cint): cint {.
  importc: "IupGetClassAttributes", cdecl, dynlib: iup_dll.}
proc GetClassCallbacks*(classname:cstring, names: ptr cstring,n:cint): cint {.
  importc: "IupGetClassCallbacks", cdecl, dynlib: iup_dll.}
proc SaveClassAttributes*(ih: PIhandle) {.
  importc: "IupSaveClassAttributes", cdecl, dynlib: iup_dll.}
proc CopyClassAttributes*(src_ih,dst_ih: PIhandle) {.  
  importc: "IupCopyClassAttributes", cdecl, dynlib: iup_dll.}
proc SetClassDefaultAttribute*(classname, name, value: cstring) {.
  importc: "IupSetClassDefaultAttribute", cdecl, dynlib: iup_dll.}
proc ClassMatch*(ih:PIhandle,classname:cstring):cint {.importc: "IupClassMatch", cdecl, dynlib: iup_dll.}

proc Create*(classname: cstring): PIhandle {.
  importc: "IupCreate", cdecl, dynlib: iup_dll.}
proc Createv*(classname: cstring, params: pointer): PIhandle {.
  importc: "IupCreatev", cdecl, dynlib: iup_dll.}
proc Createp*(classname: cstring, first: pointer): PIhandle {.
  importc: "IupCreatep", cdecl, dynlib: iup_dll, varargs.}

proc Fill*(): PIhandle {.importc: "IupFill", cdecl, dynlib: iup_dll.}
proc Radio*(child: PIhandle): PIhandle {.
  importc: "IupRadio", cdecl, dynlib: iup_dll.}
proc Vbox*(child: PIhandle): PIhandle {.
  importc: "IupVbox", cdecl, dynlib: iup_dll, varargs.}
proc Vboxv*(children: ptr PIhandle): PIhandle {.
  importc: "IupVboxv", cdecl, dynlib: iup_dll.}
proc Zbox*(child: PIhandle): PIhandle {.
  importc: "IupZbox", cdecl, dynlib: iup_dll, varargs.}
proc Zboxv*(children: ptr PIhandle): PIhandle {.
  importc: "IupZboxv", cdecl, dynlib: iup_dll.}
proc Hbox*(child: PIhandle): PIhandle {.
  importc: "IupHbox", cdecl, dynlib: iup_dll, varargs.}
proc Hboxv*(children: ptr PIhandle): PIhandle {.
  importc: "IupHboxv", cdecl, dynlib: iup_dll.}

proc Normalizer*(ih_first: PIhandle): PIhandle {.
  importc: "IupNormalizer", cdecl, dynlib: iup_dll, varargs.}
proc Normalizerv*(ih_list: ptr PIhandle): PIhandle {.
  importc: "IupNormalizerv", cdecl, dynlib: iup_dll.}

proc Cbox*(child: PIhandle): PIhandle {.
  importc: "IupCbox", cdecl, dynlib: iup_dll, varargs.}
proc Cboxv*(children: ptr PIhandle): PIhandle {.
  importc: "IupCboxv", cdecl, dynlib: iup_dll.}
proc Sbox*(child: PIhandle): PIhandle {.
  importc: "IupSbox", cdecl, dynlib: iup_dll.}
proc Split*(child1,child2:PIHandle):PIHandle {.
  importc: "IupSplit", cdecl, dynlib: iup_dll.}
proc ScrollBox*(ih:PIHandle) {.
  importc: "IupScrollBox", cdecl, dynlib: iup_dll.}
proc GridBox*(child: PIhandle): PIhandle {.
  importc: "IupGridBox", cdecl, dynlib: iup_dll, varargs.}
proc GridBoxv*(children: ptr PIhandle): PIhandle {.
  importc: "IupGridBoxv", cdecl, dynlib: iup_dll.}
proc Expander*(child:PIhandle): PIhandle {.
  importc: "IupExpander", cdecl, dynlib: iup_dll.}
  
proc Frame*(child: PIhandle): PIhandle {.
  importc: "IupFrame", cdecl, dynlib: iup_dll.}

proc Image*(width, height: cint, pixmap: pointer): PIhandle {.
  importc: "IupImage", cdecl, dynlib: iup_dll.}
proc ImageRGB*(width, height: cint, pixmap: pointer): PIhandle {.
  importc: "IupImageRGB", cdecl, dynlib: iup_dll.}
proc ImageRGBA*(width, height: cint, pixmap: pointer): PIhandle {.
  importc: "IupImageRGBA", cdecl, dynlib: iup_dll.}

proc Item*(title, action: cstring): PIhandle {.
  importc: "IupItem", cdecl, dynlib: iup_dll.}
proc Submenu*(title: cstring, child: PIhandle): PIhandle {.
  importc: "IupSubmenu", cdecl, dynlib: iup_dll.}
proc Separator*(): PIhandle {.
  importc: "IupSeparator", cdecl, dynlib: iup_dll.}
proc Menu*(child: PIhandle): PIhandle {.
  importc: "IupMenu", cdecl, dynlib: iup_dll, varargs.}
proc Menuv*(children: ptr PIhandle): PIhandle {.
  importc: "IupMenuv", cdecl, dynlib: iup_dll.}

proc Button*(title, action: cstring): PIhandle {.
  importc: "IupButton", cdecl, dynlib: iup_dll.}
proc Canvas*(action: cstring): PIhandle {.
  importc: "IupCanvas", cdecl, dynlib: iup_dll.}
proc Dialog*(child: PIhandle): PIhandle {.
  importc: "IupDialog", cdecl, dynlib: iup_dll.}
proc User*(): PIhandle {.
  importc: "IupUser", cdecl, dynlib: iup_dll.}
proc Label*(title: cstring): PIhandle {.
  importc: "IupLabel", cdecl, dynlib: iup_dll.}
proc List*(action: cstring): PIhandle {.
  importc: "IupList", cdecl, dynlib: iup_dll.}
proc Text*(action: cstring): PIhandle {.
  importc: "IupText", cdecl, dynlib: iup_dll.}
proc MultiLine*(action: cstring): PIhandle {.
  importc: "IupMultiLine", cdecl, dynlib: iup_dll.}
proc Toggle*(title, action: cstring): PIhandle {.
  importc: "IupToggle", cdecl, dynlib: iup_dll.}
proc Timer*(): PIhandle {.
  importc: "IupTimer", cdecl, dynlib: iup_dll.}
proc Clipboard*(): PIhandle {.
  importc: "IupClipboard", cdecl, dynlib: iup_dll.}
proc ProgressBar*(): PIhandle {.
  importc: "IupProgressBar", cdecl, dynlib: iup_dll.}
proc Val*(theType: cstring): PIhandle {.
  importc: "IupVal", cdecl, dynlib: iup_dll.}
proc Tabs*(child: PIhandle): PIhandle {.
  importc: "IupTabs", cdecl, dynlib: iup_dll, varargs.}
proc Tabsv*(children: ptr PIhandle): PIhandle {.
  importc: "IupTabsv", cdecl, dynlib: iup_dll.}
proc Tree*(): PIhandle {.importc: "IupTree", cdecl, dynlib: iup_dll.}
proc Link* (url,title:cstring):PIhandle {.importc: "IupLink", cdecl, dynlib: iup_dll.}

# Deprecated controls, use SPIN attribute of IupText
proc Spin*(): PIhandle {.importc: "IupSpin", cdecl, dynlib: iup_dll.}
proc Spinbox*(child: PIhandle): PIhandle {.
  importc: "IupSpinbox", cdecl, dynlib: iup_dll.}
  
# IupImage utility 
proc SaveImageAsText*(ih:PIHandle, file_name, format, name:cstring):cint {.importc: "IupSaveImageAsText", cdecl, dynlib: iup_dll.}

# IupText and IupScintilla utilities
proc TextConvertLinColToPos*(ih: PIhandle, lin, col: cint, pos: var cint) {.
  importc: "IupTextConvertLinColToPos", cdecl, dynlib: iup_dll.}
proc TextConvertPosToLinCol*(ih: PIhandle, pos: cint, lin, col: var cint) {.
  importc: "IupTextConvertPosToLinCol", cdecl, dynlib: iup_dll.}

# IupText, IupList, IupTree, IupMatrix and IupScintilla utility
proc ConvertXYToPos*(ih: PIhandle, x, y: cint): cint {.
  importc: "IupConvertXYToPos", cdecl, dynlib: iup_dll.}

# IupTree utilities
proc TreeSetUserId*(ih: PIhandle, id: cint, userid: pointer): cint {.
  importc: "IupTreeSetUserId", cdecl, dynlib: iup_dll, discardable.}
proc TreeGetUserId*(ih: PIhandle, id: cint): pointer {.
  importc: "IupTreeGetUserId", cdecl, dynlib: iup_dll.}
proc TreeGetId*(ih: PIhandle, userid: pointer): cint {.
  importc: "IupTreeGetId", cdecl, dynlib: iup_dll.}

proc TreeSetAttribute*(ih: PIhandle, name: cstring, id: cint, value: cstring) {.
  importc: "IupTreeSetAttribute", cdecl, dynlib: iup_dll.}
proc TreeStoreAttribute*(ih: PIhandle, name: cstring, id: cint, value: cstring) {.
  importc: "IupTreeStoreAttribute", cdecl, dynlib: iup_dll.}
proc TreeGetAttribute*(ih: PIhandle, name: cstring, id: cint): cstring {.
  importc: "IupTreeGetAttribute", cdecl, dynlib: iup_dll.}
proc TreeGetInt*(ih: PIhandle, name: cstring, id: cint): cint {.
  importc: "IupTreeGetInt", cdecl, dynlib: iup_dll.}
proc TreeGetFloat*(ih: PIhandle, name: cstring, id: cint): cfloat {.
  importc: "IupTreeGetFloat", cdecl, dynlib: iup_dll.}
proc TreeSetfAttribute*(ih: PIhandle, name: cstring, id: cint, format: cstring) {.
  importc: "IupTreeSetfAttribute", cdecl, dynlib: iup_dll, varargs.}


#                   Common Return Values
const
  IUP_ERROR* = cint(1)
  IUP_NOERROR* = cint(0)
  IUP_OPENED* = cint(-1)
  IUP_INVALID* = cint(-1)

  # Callback Return Values
  IUP_IGNORE* = cint(-1)
  IUP_DEFAULT* = cint(-2)
  IUP_CLOSE* = cint(-3)
  IUP_CONTINUE* = cint(-4)

  # IupPopup and IupShowXY Parameter Values
  IUP_CENTER* = cint(0xFFFF) 
  IUP_LEFT* = cint(0xFFFE) 
  IUP_RIGHT* = cint(0xFFFD) 
  IUP_MOUSEPOS* = cint(0xFFFC) 
  IUP_CURRENT* = cint(0xFFFB) 
  IUP_CENTERPARENT* = cint(0xFFFA) 
  IUP_TOP* = IUP_LEFT
  IUP_BOTTOM* = IUP_RIGHT

  # SHOW_CB Callback Values
  IUP_SHOW* = cint(0)
  IUP_RESTORE* = cint(1)
  IUP_MINIMIZE* = cint(2)
  IUP_MAXIMIZE* = cint(3)
  IUP_HIDE* = cint(4)

  # SCROLL_CB Callback Values
  IUP_SBUP* = cint(0)
  IUP_SBDN* = cint(1)
  IUP_SBPGUP* = cint(2)   
  IUP_SBPGDN* = cint(3)
  IUP_SBPOSV* = cint(4)
  IUP_SBDRAGV* = cint(5) 
  IUP_SBLEFT* = cint(6)
  IUP_SBRIGHT* = cint(7)
  IUP_SBPGLEFT* = cint(8)
  IUP_SBPGRIGHT* = cint(9)
  IUP_SBPOSH* = cint(10)
  IUP_SBDRAGH* = cint(11)

  # Mouse Button Values and Macros
  IUP_BUTTON1* = cint(ord('1'))
  IUP_BUTTON2* = cint(ord('2'))
  IUP_BUTTON3* = cint(ord('3'))
  IUP_BUTTON4* = cint(ord('4'))
  IUP_BUTTON5* = cint(ord('5'))

proc isShift*(s: cstring): bool = return s[0] == 'S'
proc isControl*(s: cstring): bool = return s[1] == 'C'
proc isButton1*(s: cstring): bool = return s[2] == '1'
proc isButton2*(s: cstring): bool = return s[3] == '2'
proc isbutton3*(s: cstring): bool = return s[4] == '3'
proc isDouble*(s: cstring): bool = return s[5] == 'D'
proc isAlt*(s: cstring): bool = return s[6] == 'A'
proc isSys*(s: cstring): bool = return s[7] == 'Y'
proc isButton4*(s: cstring): bool = return s[8] == '4'
proc isButton5*(s: cstring): bool = return s[9] == '5'

# Pre-Defined Masks
const
  IUP_MASK_FLOAT* = "[+/-]?(/d+/.?/d*|/./d+)"
  IUP_MASK_UFLOAT* = "(/d+/.?/d*|/./d+)"
  IUP_MASK_EFLOAT* = "[+/-]?(/d+/.?/d*|/./d+)([eE][+/-]?/d+)?"
  IUP_MASK_INT* = "[+/-]?/d+"
  IUP_MASK_UINT* = "/d+"
  
# Record Input Modes
const
  IUP_RECBINARY* = cint(0)
  IUP_RECTEXT* = cint(1)

# from 32 to 126, all character sets are equal,
# the key code i the same as the character code.
const
  K_SP* = cint(ord(' '))
  K_exclam* = cint(ord('!'))   
  K_quotedbl* = cint(ord('\"'))
  K_numbersign* = cint(ord('#'))
  K_dollar* = cint(ord('$'))
  K_percent* = cint(ord('%'))
  K_ampersand* = cint(ord('&'))
  K_apostrophe* = cint(ord('\''))
  K_parentleft* = cint(ord('('))
  K_parentright* = cint(ord(')'))
  K_asterisk* = cint(ord('*'))
  K_plus* = cint(ord('+'))
  K_comma* = cint(ord(','))
  K_minus* = cint(ord('-'))
  K_period* = cint(ord('.'))
  K_slash* = cint(ord('/'))
  K_0* = cint(ord('0'))
  K_1* = cint(ord('1'))
  K_2* = cint(ord('2'))
  K_3* = cint(ord('3'))
  K_4* = cint(ord('4'))
  K_5* = cint(ord('5'))
  K_6* = cint(ord('6'))
  K_7* = cint(ord('7'))
  K_8* = cint(ord('8'))
  K_9* = cint(ord('9'))
  K_colon* = cint(ord(':'))
  K_semicolon* = cint(ord(';'))
  K_less* = cint(ord('<'))
  K_equal* = cint(ord('='))
  K_greater* = cint(ord('>'))   
  K_question* = cint(ord('?'))   
  K_at* = cint(ord('@'))   
  K_upperA* = cint(ord('A'))   
  K_upperB* = cint(ord('B'))   
  K_upperC* = cint(ord('C'))   
  K_upperD* = cint(ord('D'))   
  K_upperE* = cint(ord('E'))   
  K_upperF* = cint(ord('F'))   
  K_upperG* = cint(ord('G'))   
  K_upperH* = cint(ord('H'))   
  K_upperI* = cint(ord('I'))   
  K_upperJ* = cint(ord('J'))   
  K_upperK* = cint(ord('K'))   
  K_upperL* = cint(ord('L'))   
  K_upperM* = cint(ord('M'))   
  K_upperN* = cint(ord('N'))   
  K_upperO* = cint(ord('O'))   
  K_upperP* = cint(ord('P'))   
  K_upperQ* = cint(ord('Q'))  
  K_upperR* = cint(ord('R'))  
  K_upperS* = cint(ord('S'))  
  K_upperT* = cint(ord('T'))  
  K_upperU* = cint(ord('U'))  
  K_upperV* = cint(ord('V')) 
  K_upperW* = cint(ord('W')) 
  K_upperX* = cint(ord('X'))  
  K_upperY* = cint(ord('Y'))  
  K_upperZ* = cint(ord('Z'))  
  K_bracketleft* = cint(ord('[')) 
  K_backslash* = cint(ord('\\'))  
  K_bracketright* = cint(ord(']'))  
  K_circum* = cint(ord('^'))   
  K_underscore* = cint(ord('_'))   
  K_grave* = cint(ord('`'))   
  K_lowera* = cint(ord('a'))  
  K_lowerb* = cint(ord('b'))   
  K_lowerc* = cint(ord('c')) 
  K_lowerd* = cint(ord('d'))   
  K_lowere* = cint(ord('e'))   
  K_lowerf* = cint(ord('f'))  
  K_lowerg* = cint(ord('g'))
  K_lowerh* = cint(ord('h')) 
  K_loweri* = cint(ord('i')) 
  K_lowerj* = cint(ord('j')) 
  K_lowerk* = cint(ord('k'))
  K_lowerl* = cint(ord('l'))
  K_lowerm* = cint(ord('m'))
  K_lowern* = cint(ord('n'))
  K_lowero* = cint(ord('o'))
  K_lowerp* = cint(ord('p'))
  K_lowerq* = cint(ord('q'))
  K_lowerr* = cint(ord('r'))
  K_lowers* = cint(ord('s'))
  K_lowert* = cint(ord('t'))
  K_loweru* = cint(ord('u'))
  K_lowerv* = cint(ord('v'))
  K_lowerw* = cint(ord('w'))
  K_lowerx* = cint(ord('x'))
  K_lowery* = cint(ord('y'))
  K_lowerz* = cint(ord('z'))
  K_braceleft* = cint(ord('{'))
  K_bar* = cint(ord('|'))
  K_braceright* = cint(ord('}'))
  K_tilde* = cint(ord('~'))

proc isPrint*(c: cint): bool = return c > 31 and c < 127

# also define the escape sequences that have keys associated
const
  K_BS* = cint(ord('\b'))
  K_TAB* = cint(ord('\t'))
  K_LF* = cint(10)
  K_CR* = cint(13)

# IUP Extended Key Codes, range start at 128
# Modifiers use 256 interval
# These key code definitions are specific to IUP

proc isXkey*(c: cint): bool = return c > 128
proc isShiftXkey*(c: cint): bool = return c > 256 and c < 512
proc isCtrlXkey*(c: cint): bool = return c > 512 and c < 768
proc isAltXkey*(c: cint): bool = return c > 768 and c < 1024
proc isSysXkey*(c: cint): bool = return c > 1024 and c < 1280

proc IUPxCODE*(c: cint): cint = return c + cint(128) # Normal (must be above 128)
proc IUPsxCODE*(c: cint): cint = 
  return c + cint(256)
  # Shift (must have range to include the standard keys and the normal 
  # extended keys, so must be above 256

proc IUPcxCODE*(c: cint): cint = return c + cint(512) # Ctrl
proc IUPmxCODE*(c: cint): cint = return c + cint(768) # Alt
proc IUPyxCODE*(c: cint): cint = return c + cint(1024) # Sys (Win or Apple) 

const
  IUP_NUMMAXCODES* = 1280 ## 5*256=1280  Normal+Shift+Ctrl+Alt+Sys

  K_HOME* = IUPxCODE(1)                
  K_UP* = IUPxCODE(2)
  K_PGUP* = IUPxCODE(3)
  K_LEFT* = IUPxCODE(4)
  K_MIDDLE* = IUPxCODE(5)
  K_RIGHT* = IUPxCODE(6)
  K_END* = IUPxCODE(7)
  K_DOWN* = IUPxCODE(8)
  K_PGDN* = IUPxCODE(9)
  K_INS* = IUPxCODE(10)    
  K_DEL* = IUPxCODE(11)    
  K_PAUSE* = IUPxCODE(12)
  K_ESC* = IUPxCODE(13)
  K_ccedilla* = IUPxCODE(14)
  K_F1* = IUPxCODE(15)
  K_F2* = IUPxCODE(16)
  K_F3* = IUPxCODE(17)
  K_F4* = IUPxCODE(18)
  K_F5* = IUPxCODE(19)
  K_F6* = IUPxCODE(20)
  K_F7* = IUPxCODE(21)
  K_F8* = IUPxCODE(22)
  K_F9* = IUPxCODE(23)
  K_F10* = IUPxCODE(24)
  K_F11* = IUPxCODE(25)
  K_F12* = IUPxCODE(26)
  K_Print* = IUPxCODE(27)
  K_Menu* = IUPxCODE(28)

  K_acute* = IUPxCODE(29) # no Shift/Ctrl/Alt

  K_sHOME* = IUPsxCODE(K_HOME)
  K_sUP* = IUPsxCODE(K_UP)
  K_sPGUP* = IUPsxCODE(K_PGUP)
  K_sLEFT* = IUPsxCODE(K_LEFT)
  K_sMIDDLE* = IUPsxCODE(K_MIDDLE)
  K_sRIGHT* = IUPsxCODE(K_RIGHT)
  K_sEND* = IUPsxCODE(K_END)
  K_sDOWN* = IUPsxCODE(K_DOWN)
  K_sPGDN* = IUPsxCODE(K_PGDN)
  K_sINS* = IUPsxCODE(K_INS)
  K_sDEL* = IUPsxCODE(K_DEL)
  K_sSP* = IUPsxCODE(K_SP)
  K_sTAB* = IUPsxCODE(K_TAB)
  K_sCR* = IUPsxCODE(K_CR)
  K_sBS* = IUPsxCODE(K_BS)
  K_sPAUSE* = IUPsxCODE(K_PAUSE)
  K_sESC* = IUPsxCODE(K_ESC)
  K_sCcedilla* = IUPsxCODE(K_ccedilla)
  K_sF1* = IUPsxCODE(K_F1)
  K_sF2* = IUPsxCODE(K_F2)
  K_sF3* = IUPsxCODE(K_F3)
  K_sF4* = IUPsxCODE(K_F4)
  K_sF5* = IUPsxCODE(K_F5)
  K_sF6* = IUPsxCODE(K_F6)
  K_sF7* = IUPsxCODE(K_F7)
  K_sF8* = IUPsxCODE(K_F8)
  K_sF9* = IUPsxCODE(K_F9)
  K_sF10* = IUPsxCODE(K_F10)
  K_sF11* = IUPsxCODE(K_F11)
  K_sF12* = IUPsxCODE(K_F12)
  K_sPrint* = IUPsxCODE(K_Print)
  K_sMenu* = IUPsxCODE(K_Menu)

  K_cHOME* = IUPcxCODE(K_HOME)
  K_cUP* = IUPcxCODE(K_UP)
  K_cPGUP* = IUPcxCODE(K_PGUP)
  K_cLEFT* = IUPcxCODE(K_LEFT)
  K_cMIDDLE* = IUPcxCODE(K_MIDDLE)
  K_cRIGHT* = IUPcxCODE(K_RIGHT)
  K_cEND* = IUPcxCODE(K_END)
  K_cDOWN* = IUPcxCODE(K_DOWN)
  K_cPGDN* = IUPcxCODE(K_PGDN)
  K_cINS* = IUPcxCODE(K_INS)
  K_cDEL* = IUPcxCODE(K_DEL)
  K_cSP* = IUPcxCODE(K_SP)
  K_cTAB* = IUPcxCODE(K_TAB)
  K_cCR* = IUPcxCODE(K_CR)
  K_cBS* = IUPcxCODE(K_BS)
  K_cPAUSE* = IUPcxCODE(K_PAUSE)
  K_cESC* = IUPcxCODE(K_ESC)
  K_cCcedilla* = IUPcxCODE(K_ccedilla)
  K_cF1* = IUPcxCODE(K_F1)
  K_cF2* = IUPcxCODE(K_F2)
  K_cF3* = IUPcxCODE(K_F3)
  K_cF4* = IUPcxCODE(K_F4)
  K_cF5* = IUPcxCODE(K_F5)
  K_cF6* = IUPcxCODE(K_F6)
  K_cF7* = IUPcxCODE(K_F7)
  K_cF8* = IUPcxCODE(K_F8)
  K_cF9* = IUPcxCODE(K_F9)
  K_cF10* = IUPcxCODE(K_F10)
  K_cF11* = IUPcxCODE(K_F11)
  K_cF12* = IUPcxCODE(K_F12)
  K_cPrint* = IUPcxCODE(K_Print)
  K_cMenu* = IUPcxCODE(K_Menu)

  K_mHOME* = IUPmxCODE(K_HOME)
  K_mUP* = IUPmxCODE(K_UP)
  K_mPGUP* = IUPmxCODE(K_PGUP)
  K_mLEFT* = IUPmxCODE(K_LEFT)
  K_mMIDDLE* = IUPmxCODE(K_MIDDLE)
  K_mRIGHT* = IUPmxCODE(K_RIGHT)
  K_mEND* = IUPmxCODE(K_END)
  K_mDOWN* = IUPmxCODE(K_DOWN)
  K_mPGDN* = IUPmxCODE(K_PGDN)
  K_mINS* = IUPmxCODE(K_INS)
  K_mDEL* = IUPmxCODE(K_DEL)
  K_mSP* = IUPmxCODE(K_SP)
  K_mTAB* = IUPmxCODE(K_TAB)
  K_mCR* = IUPmxCODE(K_CR)
  K_mBS* = IUPmxCODE(K_BS)
  K_mPAUSE* = IUPmxCODE(K_PAUSE)
  K_mESC* = IUPmxCODE(K_ESC)
  K_mCcedilla* = IUPmxCODE(K_ccedilla)
  K_mF1* = IUPmxCODE(K_F1)
  K_mF2* = IUPmxCODE(K_F2)
  K_mF3* = IUPmxCODE(K_F3)
  K_mF4* = IUPmxCODE(K_F4)
  K_mF5* = IUPmxCODE(K_F5)
  K_mF6* = IUPmxCODE(K_F6)
  K_mF7* = IUPmxCODE(K_F7)
  K_mF8* = IUPmxCODE(K_F8)
  K_mF9* = IUPmxCODE(K_F9)
  K_mF10* = IUPmxCODE(K_F10)
  K_mF11* = IUPmxCODE(K_F11)
  K_mF12* = IUPmxCODE(K_F12)
  K_mPrint* = IUPmxCODE(K_Print)
  K_mMenu* = IUPmxCODE(K_Menu)

  K_yHOME* = IUPyxCODE(K_HOME)
  K_yUP* = IUPyxCODE(K_UP)
  K_yPGUP* = IUPyxCODE(K_PGUP)
  K_yLEFT* = IUPyxCODE(K_LEFT)
  K_yMIDDLE* = IUPyxCODE(K_MIDDLE)
  K_yRIGHT* = IUPyxCODE(K_RIGHT)
  K_yEND* = IUPyxCODE(K_END)
  K_yDOWN* = IUPyxCODE(K_DOWN)
  K_yPGDN* = IUPyxCODE(K_PGDN)
  K_yINS* = IUPyxCODE(K_INS)
  K_yDEL* = IUPyxCODE(K_DEL)
  K_ySP* = IUPyxCODE(K_SP)
  K_yTAB* = IUPyxCODE(K_TAB)
  K_yCR* = IUPyxCODE(K_CR)
  K_yBS* = IUPyxCODE(K_BS)
  K_yPAUSE* = IUPyxCODE(K_PAUSE)
  K_yESC* = IUPyxCODE(K_ESC)
  K_yCcedilla* = IUPyxCODE(K_ccedilla)
  K_yF1* = IUPyxCODE(K_F1)
  K_yF2* = IUPyxCODE(K_F2)
  K_yF3* = IUPyxCODE(K_F3)
  K_yF4* = IUPyxCODE(K_F4)
  K_yF5* = IUPyxCODE(K_F5)
  K_yF6* = IUPyxCODE(K_F6)
  K_yF7* = IUPyxCODE(K_F7)
  K_yF8* = IUPyxCODE(K_F8)
  K_yF9* = IUPyxCODE(K_F9)
  K_yF10* = IUPyxCODE(K_F10)
  K_yF11* = IUPyxCODE(K_F11)
  K_yF12* = IUPyxCODE(K_F12)
  K_yPrint* = IUPyxCODE(K_Print)
  K_yMenu* = IUPyxCODE(K_Menu)

  K_sPlus* = IUPsxCODE(K_plus)   
  K_sComma* = IUPsxCODE(K_comma)   
  K_sMinus* = IUPsxCODE(K_minus)   
  K_sPeriod* = IUPsxCODE(K_period)   
  K_sSlash* = IUPsxCODE(K_slash)   
  K_sAsterisk* = IUPsxCODE(K_asterisk)
                        
  K_cupperA* = IUPcxCODE(K_upperA)
  K_cupperB* = IUPcxCODE(K_upperB)
  K_cupperC* = IUPcxCODE(K_upperC)
  K_cupperD* = IUPcxCODE(K_upperD)
  K_cupperE* = IUPcxCODE(K_upperE)
  K_cupperF* = IUPcxCODE(K_upperF)
  K_cupperG* = IUPcxCODE(K_upperG)
  K_cupperH* = IUPcxCODE(K_upperH)
  K_cupperI* = IUPcxCODE(K_upperI)
  K_cupperJ* = IUPcxCODE(K_upperJ)
  K_cupperK* = IUPcxCODE(K_upperK)
  K_cupperL* = IUPcxCODE(K_upperL)
  K_cupperM* = IUPcxCODE(K_upperM)
  K_cupperN* = IUPcxCODE(K_upperN)
  K_cupperO* = IUPcxCODE(K_upperO)
  K_cupperP* = IUPcxCODE(K_upperP)
  K_cupperQ* = IUPcxCODE(K_upperQ)
  K_cupperR* = IUPcxCODE(K_upperR)
  K_cupperS* = IUPcxCODE(K_upperS)
  K_cupperT* = IUPcxCODE(K_upperT)
  K_cupperU* = IUPcxCODE(K_upperU)
  K_cupperV* = IUPcxCODE(K_upperV)
  K_cupperW* = IUPcxCODE(K_upperW)
  K_cupperX* = IUPcxCODE(K_upperX)
  K_cupperY* = IUPcxCODE(K_upperY)
  K_cupperZ* = IUPcxCODE(K_upperZ)
  K_c1* = IUPcxCODE(K_1)
  K_c2* = IUPcxCODE(K_2)
  K_c3* = IUPcxCODE(K_3)
  K_c4* = IUPcxCODE(K_4)
  K_c5* = IUPcxCODE(K_5)
  K_c6* = IUPcxCODE(K_6)
  K_c7* = IUPcxCODE(K_7)        
  K_c8* = IUPcxCODE(K_8)         
  K_c9* = IUPcxCODE(K_9)
  K_c0* = IUPcxCODE(K_0)
  K_cPlus* = IUPcxCODE(K_plus)   
  K_cComma* = IUPcxCODE(K_comma)   
  K_cMinus* = IUPcxCODE(K_minus)   
  K_cPeriod* = IUPcxCODE(K_period)   
  K_cSlash* = IUPcxCODE(K_slash)   
  K_cSemicolon* = IUPcxCODE(K_semicolon) 
  K_cEqual* = IUPcxCODE(K_equal)
  K_cBracketleft* = IUPcxCODE(K_bracketleft)
  K_cBracketright* = IUPcxCODE(K_bracketright)
  K_cBackslash* = IUPcxCODE(K_backslash)
  K_cAsterisk* = IUPcxCODE(K_asterisk)

  K_mupperA* = IUPmxCODE(K_upperA)
  K_mupperB* = IUPmxCODE(K_upperB)
  K_mupperC* = IUPmxCODE(K_upperC)
  K_mupperD* = IUPmxCODE(K_upperD)
  K_mupperE* = IUPmxCODE(K_upperE)
  K_mupperF* = IUPmxCODE(K_upperF)
  K_mupperG* = IUPmxCODE(K_upperG)
  K_mupperH* = IUPmxCODE(K_upperH)
  K_mupperI* = IUPmxCODE(K_upperI)
  K_mupperJ* = IUPmxCODE(K_upperJ)
  K_mupperK* = IUPmxCODE(K_upperK)
  K_mupperL* = IUPmxCODE(K_upperL)
  K_mupperM* = IUPmxCODE(K_upperM)
  K_mupperN* = IUPmxCODE(K_upperN)
  K_mupperO* = IUPmxCODE(K_upperO)
  K_mupperP* = IUPmxCODE(K_upperP)
  K_mupperQ* = IUPmxCODE(K_upperQ)
  K_mupperR* = IUPmxCODE(K_upperR)
  K_mupperS* = IUPmxCODE(K_upperS)
  K_mupperT* = IUPmxCODE(K_upperT)
  K_mupperU* = IUPmxCODE(K_upperU)
  K_mupperV* = IUPmxCODE(K_upperV)
  K_mupperW* = IUPmxCODE(K_upperW)
  K_mupperX* = IUPmxCODE(K_upperX)
  K_mupperY* = IUPmxCODE(K_upperY)
  K_mupperZ* = IUPmxCODE(K_upperZ)
  K_m1* = IUPmxCODE(K_1)
  K_m2* = IUPmxCODE(K_2)
  K_m3* = IUPmxCODE(K_3)
  K_m4* = IUPmxCODE(K_4)
  K_m5* = IUPmxCODE(K_5)
  K_m6* = IUPmxCODE(K_6)
  K_m7* = IUPmxCODE(K_7)        
  K_m8* = IUPmxCODE(K_8)         
  K_m9* = IUPmxCODE(K_9)
  K_m0* = IUPmxCODE(K_0)
  K_mPlus* = IUPmxCODE(K_plus)   
  K_mComma* = IUPmxCODE(K_comma)   
  K_mMinus* = IUPmxCODE(K_minus)   
  K_mPeriod* = IUPmxCODE(K_period)   
  K_mSlash* = IUPmxCODE(K_slash)   
  K_mSemicolon* = IUPmxCODE(K_semicolon) 
  K_mEqual* = IUPmxCODE(K_equal)
  K_mBracketleft* = IUPmxCODE(K_bracketleft)
  K_mBracketright* = IUPmxCODE(K_bracketright)
  K_mBackslash* = IUPmxCODE(K_backslash)
  K_mAsterisk* = IUPmxCODE(K_asterisk)

  K_yA* = IUPyxCODE(K_upperA)
  K_yB* = IUPyxCODE(K_upperB)
  K_yC* = IUPyxCODE(K_upperC)
  K_yD* = IUPyxCODE(K_upperD)
  K_yE* = IUPyxCODE(K_upperE)
  K_yF* = IUPyxCODE(K_upperF)
  K_yG* = IUPyxCODE(K_upperG)
  K_yH* = IUPyxCODE(K_upperH)
  K_yI* = IUPyxCODE(K_upperI)
  K_yJ* = IUPyxCODE(K_upperJ)
  K_yK* = IUPyxCODE(K_upperK)
  K_yL* = IUPyxCODE(K_upperL)
  K_yM* = IUPyxCODE(K_upperM)
  K_yN* = IUPyxCODE(K_upperN)
  K_yO* = IUPyxCODE(K_upperO)
  K_yP* = IUPyxCODE(K_upperP)
  K_yQ* = IUPyxCODE(K_upperQ)
  K_yR* = IUPyxCODE(K_upperR)
  K_yS* = IUPyxCODE(K_upperS)
  K_yT* = IUPyxCODE(K_upperT)
  K_yU* = IUPyxCODE(K_upperU)
  K_yV* = IUPyxCODE(K_upperV)
  K_yW* = IUPyxCODE(K_upperW)
  K_yX* = IUPyxCODE(K_upperX)
  K_yY* = IUPyxCODE(K_upperY)
  K_yZ* = IUPyxCODE(K_upperZ)
  K_y1* = IUPyxCODE(K_1)
  K_y2* = IUPyxCODE(K_2)
  K_y3* = IUPyxCODE(K_3)
  K_y4* = IUPyxCODE(K_4)
  K_y5* = IUPyxCODE(K_5)
  K_y6* = IUPyxCODE(K_6)
  K_y7* = IUPyxCODE(K_7)        
  K_y8* = IUPyxCODE(K_8)         
  K_y9* = IUPyxCODE(K_9)
  K_y0* = IUPyxCODE(K_0)
  K_yPlus* = IUPyxCODE(K_plus)
  K_yComma* = IUPyxCODE(K_comma)
  K_yMinus* = IUPyxCODE(K_minus)   
  K_yPeriod* = IUPyxCODE(K_period)   
  K_ySlash* = IUPyxCODE(K_slash)   
  K_ySemicolon* = IUPyxCODE(K_semicolon) 
  K_yEqual* = IUPyxCODE(K_equal)
  K_yBracketleft* = IUPyxCODE(K_bracketleft)
  K_yBracketright* = IUPyxCODE(K_bracketright)
  K_yBackslash* = IUPyxCODE(K_backslash)
  K_yAsterisk* = IUPyxCODE(K_asterisk)


when true: #fold-begin iupcontrols.dll
  proc ControlsOpen*(): cint {.cdecl, importc: "IupControlsOpen", dynlib: iupcontrols_dll, discardable.}
  proc Colorbar*(): PIhandle {.cdecl, importc: "IupColorbar", dynlib: iupcontrols_dll.}
  proc Cells*(): PIhandle {.cdecl, importc: "IupCells", dynlib: iupcontrols_dll.}
  proc ColorBrowser*(): PIhandle {.cdecl, importc: "IupColorBrowser", dynlib: iupcontrols_dll.}
  proc Gauge*(): PIhandle {.cdecl, importc: "IupGauge", dynlib: iupcontrols_dll.}
  proc Dial*(theType: cstring): PIhandle {.cdecl, importc: "IupDial", dynlib: iupcontrols_dll.}
  proc Matrix*(action: cstring): PIhandle {.cdecl, importc: "IupMatrix", dynlib: iupcontrols_dll.}

  # IupMatrix utilities
  proc MatSetAttribute*(ih: PIhandle, name: cstring, lin, col: cint, 
                        value: cstring) {.
                        cdecl, importc: "IupMatSetAttribute", dynlib: iup_dll.}
  proc MatStoreAttribute*(ih: PIhandle, name: cstring, lin, col: cint, 
                          value: cstring) {.cdecl, 
                          importc: "IupMatStoreAttribute", dynlib: iup_dll.}
  proc MatGetAttribute*(ih: PIhandle, name: cstring, lin, col: cint): cstring {.
    cdecl, importc: "IupMatGetAttribute", dynlib: iup_dll.}
  proc MatGetInt*(ih: PIhandle, name: cstring, lin, col: cint): cint {.
    cdecl, importc: "IupMatGetInt", dynlib: iup_dll.}
  proc MatGetFloat*(ih: PIhandle, name: cstring, lin, col: cint): cfloat {.
    cdecl, importc: "IupMatGetFloat", dynlib: iup_dll.}
  proc MatSetfAttribute*(ih: PIhandle, name: cstring, lin, col: cint, 
                         format: cstring) {.cdecl, 
                         importc: "IupMatSetfAttribute", 
                         dynlib: iup_dll, varargs.}
  # Used by IupColorbar
  const
    IUP_PRIMARY* = -1
    IUP_SECONDARY* = -2
#fold-end iupcontrols.dll

when true: #fold-begin iup_pplot.dll
  # Initialize PPlot widget class
  proc PPlotOpen*() {.cdecl, importc: "IupPPlotOpen", dynlib: iup_pplot_dll, discardable.}

  # Create an PPlot widget instance
  proc PPlot*: PIhandle {.cdecl, importc: "IupPPlot", dynlib: iup_pplot_dll.}

  # Add dataset to plot
  proc PPlotBegin*(ih: PIhandle, strXdata: cint) {.
    cdecl, importc: "IupPPlotBegin", dynlib: iup_pplot_dll.}
  proc PPlotAdd*(ih: PIhandle, x, y: cfloat) {.
    cdecl, importc: "IupPPlotAdd", dynlib: iup_pplot_dll.}
  proc PPlotAddStr*(ih: PIhandle, x: cstring, y: cfloat) {.
    cdecl, importc: "IupPPlotAddStr", dynlib: iup_pplot_dll.}
  proc PPlotEnd*(ih: PIhandle): cint {.
    cdecl, importc: "IupPPlotEnd", dynlib: iup_pplot_dll.}

  proc PPlotInsertStr*(ih: PIhandle, index, sample_index: cint, x: cstring, 
                       y: cfloat) {.cdecl, importc: "IupPPlotInsertStr", 
                       dynlib: iup_pplot_dll.}
  proc PPlotInsert*(ih: PIhandle, index, sample_index: cint, 
                    x, y: cfloat) {.
                    cdecl, importc: "IupPPlotInsert", dynlib: iup_pplot_dll.}

  proc PPlotInsertStrPoints*(ih:PIhandle, index,sample_index:cint,x:ptr cstring,y:ptr cfloat,count:cint) {.
    cdecl, importc: "IupPPlotInsertStrPoints", dynlib: iup_pplot_dll.}
  proc PPlotInsertPoints*(ih:PIhandle,index,sample_index:cint,x,y:ptr cfloat,count:cint) {.
    cdecl, importc: "IupPPlotInsertPoints", dynlib: iup_pplot_dll.}
  proc PPlotAddPoints*(ih:PIhandle, index:cint,x,y:ptr cfloat,count: cint) {.
    cdecl, importc: "IupPPlotAddPoints", dynlib: iup_pplot_dll.}
  proc PPlotAddStrPoints*(ih:PIhandle,index:cint, x:ptr cstring,y:ptr cfloat, count:cint) {.
    cdecl, importc: "IupPPlotAddStrPoints", dynlib: iup_pplot_dll.}

  # convert from plot coordinates to pixels
  proc PPlotTransform*(ih: PIhandle, x, y: cfloat, ix, iy: var cint) {.
    cdecl, importc: "IupPPlotTransform", dynlib: iup_pplot_dll.}

  # Plot on the given device. Uses a "cdCanvas*".
  proc PPlotPaintTo*(ih: PIhandle, cnv: pointer) {.
    cdecl, importc: "IupPPlotPaintTo", dynlib: iup_pplot_dll.}
#fold-end iup_pplot.dll

when true: #fold-begin iup_scintilla.dll
  proc ScintillaOpen* {.cdecl, importc: "IupScintillaOpen", dynlib: iup_scintilla_dll, discardable.}
  proc Scintilla* :PIhandle {.cdecl, importc: "IupScintilla", dynlib: iup_scintilla_dll.}
#fold-end iup_scintilla.dll

when true: #fold-begin iupgl.dll
  proc GLCanvasOpen* {.cdecl, importc: "IupGLCanvasOpen", dynlib: iupgl_dll, discardable.}
  proc GLCanvas* :PIhandle {.cdecl, importc: "IupGLCanvas", dynlib: iupgl_dll.}
  proc GLMakeCurrent*(ih:PIHandle) {.cdecl, importc: "IupGLMakeCurrent", dynlib: iupgl_dll.}
  proc GLIsCurrent*(ih:PIHandle):cint {.cdecl, importc: "IupGLIsCurrent", dynlib: iupgl_dll.}
  proc GLSwapBuffers*(ih:PIHandle) {.cdecl, importc: "IupGLSwapBuffers", dynlib: iupgl_dll.}
  proc GLPalette*(ih:PIHandle,index:cint,r,g,b:cfloat) {.cdecl, importc: "IupGLPalette", dynlib: iupgl_dll.}
  proc GLUseFont*(ih:PIHandle,first,count,list_base:cint) {.cdecl, importc: "IupGLUseFont", dynlib: iupgl_dll.}
  proc GLWait*(gl:cint):cint {.cdecl, importc: "IupGLWait", dynlib: iupgl_dll.}
#fold-end iupgl.dll

when true: #fold-begin iupole.dll
  proc OleControl*(progid:cstring):PIHandle {.cdecl, importc: "IupOleControl", dynlib: iupole_dll.}
  proc OleControlOpen*:cint {.cdecl, importc: "IupOleControlOpen", dynlib: iupole_dll, discardable.}
#fold-end iupole.dll

when true: #fold-begin iupimglib.dll
  proc ImageLibOpen*:cint {.cdecl, importc: "IupImageLibOpen", dynlib: iupimglib_dll,discardable.}
#fold-end iupimglib.dll


when true: #fold-begin iupwebbrowser.dll
  proc WebBrowserOpen*:cint {.cdecl, importc: "IupWebBrowserOpen", dynlib: iupweb_dll, discardable.}
  proc WebBrowser* :PIHandle {.cdecl, importc: "IupWebBrowser", dynlib: iupweb_dll.}
#fold-end iupwebbrowser.dll


when true: #fold-bgin iuptuio.dll
  proc TuioOpen* :cint {.cdecl, importc: "IupTuioOpen", dynlib: iuptuio_dll, discardable.}
  proc TuioClient*(port:cint):PIHandle {.cdecl, importc: "IupTuioClient", dynlib: iuptuio_dll.}
#fold-end iuptuio.dll

when true: #fold-begin iup_mglplot.dll
  proc MglPlotOpen*{.importc: "IupMglPlotOpen", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlot*:PIhandle{.importc: "IupMglPlot",dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotBegin*(ih: PIhandle, dim:cint) {.importc: "IupMglPlotBegin", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotAdd1D*(ih: PIhandle, name:cstring, y:cfloat) {.importc: "IupMglPlotAdd1D", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotAdd2D*(ih:PIhandle,x,y:cfloat) {.importc: "IupMglPlotAdd2D", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotAdd3D*(ih:PIhandle,x,y,z:cfloat) {.importc: "IupMglPlotAdd3D", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotEnd*(ih:PIhandle):cint {.importc: "IupMglPlotEnd", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotNewDataSet*(ih:PIhandle,dim:cint):cint {.importc: "IupMglPlotNewDataSet", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotInsert1D*(ih:PIhandle,ds_index,sample_index:cint, names:ptr cstring, y:ptr cfloat, count:cint) {.importc: "IupMglPlotInsert1D", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotInsert2D*(ih:PIhandle, ds_index, sample_index:cint, x,y:ptr cfloat, count:cint) {.importc: "IupMglPlotInsert2D", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotInsert3D*(ih:PIhandle, ds_index, sample_index:cint, x,y,z: ptr cfloat, count:cint) {.importc: "IupMglPlotInsert3D", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotSet1D*(ih:PIhandle, ds_index:cint, names:ptr cstring, y:ptr cfloat, count:cint) {.importc: "IupMglPlotSet1D", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotSet2D*(ih:PIhandle, ds_index:cint, x,y:ptr cfloat, count:cint) {.importc: "IupMglPlotSet2D", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotSet3D*(ih:PIhandle, ds_index:cint, x,y,z: ptr cfloat,count:cint) {.importc: "IupMglPlotSet3D", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotSetFormula*(ih:PIhandle, ds_index:cint, formulaX, formulaY,formulaZ:cstring, count:cint) {.importc: "IupMglPlotSetFormula", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotSetData*(ih:PIhandle, ds_index:cint, data:ptr cfloat, count_x,count_y,count_z:cint) {.importc: "IupMglPlotSetData", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotLoadData*(ih:PIhandle, ds_index:cint, filename:cstring, count_x, count_y, count_z:cint) {.importc: "IupMglPlotLoadData", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotSetFromFormula*(ih:PIhandle, ds_index:cint, formula:cstring, count_x, count_y, count_z:cint) {.importc: "IupMglPlotSetFromFormula", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotTransform*(ih:PIhandle, x, y, z:cfloat, ix,iy:ptr cint) {.importc: "IupMglPlotTransform", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotTransformXYZ*(ih:PIhandle, ix, iy:cint, x,y,z:ptr cfloat) {.importc: "IupMglPlotTransformXYZ", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotDrawMark*(ih:PIhandle, x,y,z:cfloat) {.importc: "IupMglPlotDrawMark", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotDrawLine*(ih:PIhandle, x1,y1,z1,x2,y2,z2:cfloat) {.importc: "IupMglPlotDrawLine", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotDrawText*(ih:PIhandle, text:cstring, x,y,z:cfloat) {.importc: "IupMglPlotDrawText", dynlib: iup_mglplot_dll, cdecl.}
  proc MglPlotPaintTo*(ih:PIhandle, format:cstring, w,h:cint, dpi:cfloat, data:pointer) {.importc: "IupMglPlotPaintTo", dynlib: iup_mglplot_dll, cdecl.}
#fold-end iup_mglplot.dll


when defined(windows): #Enable theming under windows
  type TActCtx {.final, pure.} = object 
    cbSize:int32
    dwFlags:int32
    lpSource:cstring
    wProcessorArchitecture:int16
    wLangId:int16
    lpAssemblyDirectory:cstring
    lpResourceName:cstring
    lpApplicationName:cstring
  
  #avoid importing full windows.nim (besides the ActCtx functions are not there (?))
  proc CreateActCtx(pActCtx: var TActCtx): int {. stdcall,dynlib: "Kernel32.dll",importc: "CreateActCtxA" .}
  proc ActivateActCtx(hActCtx: int; lpCookie: ptr int32): int32 {. stdcall,dynlib: "Kernel32.dll",importc: "ActivateActCtx" .}
  proc GetSystemDirectory*(lpBuffer: cstring, uSize: int32): int32{.stdcall,dynlib: "kernel32", importc: "GetSystemDirectoryA".}

  proc EnableTheming()=
    # somewhat hacky: grab theme manifest from shell32.dll to avoid having own manifest
    var actctx:TActCtx
    var dir:array[0..256,char]
    if GetSystemDirectory(dir,256)==0:  return
    actctx.cbSize=int32(sizeof(actctx))
    actctx.dwFlags= 28
    actctx.lpSource="shell32.dll"
    actctx.wProcessorArchitecture=0
    actctx.wLangId=0
    actctx.lpAssemblyDirectory=dir
    actctx.lpResourceName=cast[cstring](124)
    discard ActivateActCtx(CreateActCtx(actctx),nil)
else:
  proc EnableTheming()=
    # under all other platforms, nothing is done
  
    
    
  
  
  
  
  
  
  
  
  
  
  
  
  
  