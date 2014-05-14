import iup38


iup38.open(nil,nil)

discard iup38.controlsOpen()




var dlg=dialog(
  vbox(
    button("Hello",nil),
    button("Hello again åäöÅÄÖ",nil),
    
    iup38.matrix("MATACTION")    
    
  )
)


  






show(dlg)

mainLoop()



