import iup38
import strutils
import os
import encodings

var
  doctabs:PIhandle  #tabs control for each document
  
proc onCmdNew(ih:PIhandle):cint {.cdecl.}
proc onCmdExit(ih:PIhandle):cint {.cdecl.}
proc onCmdOpen(ih:PIhandle):cint {.cdecl.}

var noname_counter=1 #used to create indexed NONMAEx.nim name for new drawings



proc newToolButton(title,cmdname:string,image:string=nil):PIHandle=
  var btn=button("",cmdname)
  if image!=nil:
    setAttribute(btn,"IMAGE",image)
  else:
    setAttribute(btn,"TITLE",title)
    
  if title!=nil:
    setAttribute(btn,"TOOLTIP",title)
  setAttribute(btn,"CANFOCUS","NO")
  return btn
  

proc createMainWindow():PIhandle =

  doctabs=Tabs(nil)

  var mainwindow=Dialog(
    vbox(
      hbox( #toolbar
        newToolButton("","NEW","IUP_FileNew"),
        newToolButton("","OPEN","IUP_FileOpen"),
        newToolButton("X","EXIT"),
        nil
      ),        
      doctabs,
      nil
    )
  )
  
  setAttribute(mainwindow,"TITLE","Nimride")
  
  setFunction("NEW",onCmdNew)
  setFunction("EXIT",onCmdExit)
  setFunction("OPEN",onCmdOpen)
  
  
  #create one document from scratch
  discard onCmdNew(nil)
  
  return mainwindow
  
  
proc createNimrodScintilla():PIhandle=
  ## creates an iup scintilla control initialized for nimrod
  var ed=scintilla()
  SetAttribute(ed, "LEXERLANGUAGE", "nimrod");
  SetAttribute(ed, "KEYWORDS0", "proc var method")

  #SetAttribute(ed, "STYLECLEARALL", "YES")  # sets all styles to have the same attributes as 32 
  SetAttribute(ed, "STYLEFONT32", "Consolas")
  #SetAttribute(ed, "STYLEFONTSIZE32", "12")
  
  SetAttribute(ed, "STYLEFGCOLOR1", "0 128 0")    # 1-C comment 
  SetAttribute(ed, "STYLEFGCOLOR2", "0 128 0")    # 2-C++ comment line 
  SetAttribute(ed, "STYLEFGCOLOR4", "128 0 0")    # 4-Number 
  SetAttribute(ed, "STYLEFGCOLOR5", "0 0 255")    # 5-Keyword 
  SetAttribute(ed, "STYLEFGCOLOR6", "160 20 20")  # 6-String 
  SetAttribute(ed, "STYLEFGCOLOR7", "128 0 0")    # 7-Character 
  SetAttribute(ed, "STYLEFGCOLOR9", "0 0 255")    # 9-Preprocessor block 
  SetAttribute(ed, "STYLEFGCOLOR10", "255 0 255") # 10-Operator 
  SetAttribute(ed, "STYLEBOLD10", "YES")
  
  SetAttribute(ed,"USETABS","NO")
  SetAttribute(ed,"TABSIZE","2")
  
  
  ed.setAttribute("EXPAND","YES")
  
  return ed




proc createNewEditor(filename:string):PIhandle=
  ## Creates a new editor document
  ## If filename is not nil this file is loaded
  var ed=createNimrodScintilla()
  
  
  if filename!=nil:
    setAttribute(ed,"VALUE",readFile(filename))
    echo filename
    echo extractFileName(filename)
    ed.setAttribute("TABTITLE",extractFileName(filename))
  else:
    ed.setAttribute("TABTITLE","NONAME"& $noname_counter&".nim")
    inc noname_counter
    
  append(doctabs,ed)
  var stridx= $(getChildCount(doctabs)-1)
  setAttribute(doctabs,"VALUEPOS",stridx)
  ed.Map()
  ed.Refresh()
  
  


  return ed

proc onCmdNew(ih:PIhandle):cint =
  discard createNewEditor(nil)
  result=IUP_DEFAULT

proc onCmdExit(ih:PIhandle):cint=
  #TODO: check for unsaved files
  result=IUP_CLOSE


proc ASCIIToUtf8(asc:string):string=
  var ce=getCurrentEncoding()
  return encodings.convert(asc,"utf-8",ce)
  

proc onCmdOpen(ih:PIhandle):cint=
  
   
  var fd=FileDlg()
  setAttribute(fd,"FILTER","*.nim")
  setAttribute(fd,"FILTERINFO","Nimrod sources (*.nim)")
  setAttribute(fd,"MULTIPLEFILES","YES")
  fd.popup(IUP_CENTER,IUP_CENTER)
  if fd.GetInt("STATUS")==0: #normal existing file selected
    var fname= $fd.getAttribute("VALUE")
    if fname.contains('|'): #Multiple files selcted
      var parts=fname.split('|')
      var dir=parts[0]
      for fnidx in 1.. <high(parts): #skip last since we always have an empty | last
        var fn=dir & dirsep & parts[fnidx]
        #discard createNewEditor(dir & dirsep & parts[fnidx])
        echo(fn)
        echo(ASCIIToUtf8(fn))
    else: #only one file selected
      #discard createNewEditor(fname)
      echo(fname)
      echo(ASCIIToUtf8(fname))
    #discard createNewEditor($fname)

  
  fd.destroy()
  
  result=IUP_DEFAULT


when isMainModule:
  iup38.open(nil,nil)
  scintillaOpen()
  imageLibOpen()
  
  var mainwin=createMainWindow()
  mainwin.show()
  
  mainLoop()