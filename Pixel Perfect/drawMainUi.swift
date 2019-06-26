//
//  drawMainUi.swift
//  Pixel Perfect
//
//  Created by Nirav Patel on 07/06/19.
//  Copyright © 2019 Nirav Patel. All rights reserved.
//

import Cocoa

class myLayout{
    
    
    var startXPoint = 0
    var startYPoint = 0
    var countX = 1
    var countY = 1
    var boxHeight = 80
    var boxWidth = 80
    var totalHeight = 80
    var totalWidth = 80
    var evenColor = NSColor.orange
    var oddColor = NSColor.red
    var lineColor = NSColor.blue
    var offsetColor = NSColor.yellow
    var offset = 0
    var label = 1
    var labelColor = NSColor.white
    var labelFontSize = 10
    var outlineSize = 0
    init(){
        
    }
    init(_ preset : presetLayout){
        self.boxWidth = preset.hSize
        self.boxHeight = preset.vSize
        self.countX = preset.countX
        self.countY = preset.countY
    }
    func getRect() -> CGRect{
        print("myLayout:getRect")
        totalWidth = ((boxWidth + offset) * countX) + offset
        totalHeight = ((boxHeight + offset) * countY) + offset
        return CGRect(x: startXPoint, y: startYPoint, width: totalWidth, height: totalHeight)
        
    }
    
    
}

class drawMainUi: NSView{

    var currentLayoutIndex: Int = -1
    var layouts = [myLayout]()

    override var isFlipped: Bool{
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("drawMainUi:init")
        initBasic()
        registerNotification()
    }
    

    
    
    func initBasic(){
         print("drawMainUi:initBasic")
        let layout = myLayout()
        let rect = layout.getRect()
        let headerView = boxUi(rect ,layout)
        headerView?.wantsLayer = true
        headerView?.layer?.backgroundColor = NSColor.yellow.cgColor
        layouts.append(layout)
        self.currentLayoutIndex = 0
        self.subviews.append((headerView)!)
        self.frame.size.height = 1080
        self.frame.size.width = 1920
        
    }

    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        print("drawMainUi:draw")

    }
    
    @objc func addLayout(_ notification: NSNotification){
        print("drawMainUi:addLayout")
        let layoutDetails = notification.userInfo?["value"] as! presetLayout
        let layout = myLayout(layoutDetails)
        let rect = layout.getRect()
        let headerView = boxUi(rect ,layout)
        headerView?.wantsLayer = true
        headerView?.layer?.backgroundColor = NSColor.yellow.cgColor
        layouts.append(layout)
        self.subviews.append(headerView!)
        self.currentLayoutIndex = layouts.count - 1
        NotificationCenter.default.post(name : NSNotification.Name(rawValue: "updateBoxes") , object: self,userInfo: ["value" : self.layouts[self.currentLayoutIndex]])


    }
    @objc func removeLayout(_ notification: NSNotification){
        print("drawMainUi:removeLayout")
        if(layouts.count > 1){
            self.subviews.remove(at: self.currentLayoutIndex)
            layouts.remove(at: self.currentLayoutIndex)
            if(self.currentLayoutIndex != 0){
                self.currentLayoutIndex = self.currentLayoutIndex - 1
            }
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "updateBoxes") , object: self,userInfo: ["value" : self.layouts[self.currentLayoutIndex]])

        }

    }
    
     func registerNotification()  {
        print("drawMainUi:registerNotification")

        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.drawUI(_:)), name: NSNotification.Name(rawValue: "hPanel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.drawUI(_:)), name: NSNotification.Name(rawValue: "vPanel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.drawUI(_:)), name: NSNotification.Name(rawValue: "cols"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.drawUI(_:)), name: NSNotification.Name(rawValue: "rows"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.drawUI(_:)), name: NSNotification.Name(rawValue: "hStart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.drawUI(_:)), name: NSNotification.Name(rawValue: "vStart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.addLayout(_:)), name: NSNotification.Name(rawValue: "addLayout"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.removeLayout(_:)), name: NSNotification.Name(rawValue: "removeLayout"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.updateSelectedIndex(_:)), name: NSNotification.Name(rawValue: "selectionChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.exportToPNG(_:)), name: NSNotification.Name(rawValue: "exportToPNG"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.updateRoster(_:)), name: NSNotification.Name(rawValue: "hSize"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.updateRoster(_:)), name: NSNotification.Name(rawValue: "vSize"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.updateBoxColor(_:)), name: NSNotification.Name(rawValue: "oddColorPicker"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.updateBoxColor(_:)), name: NSNotification.Name(rawValue: "evenColorPicker"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.updateBoxColor(_:)), name: NSNotification.Name(rawValue: "lineColor"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.drawUI(_:)), name: NSNotification.Name(rawValue: "outLineSize"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.labelCheckBoxChanged(_:)), name: NSNotification.Name(rawValue: "labelCheckBox"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.drawUI(_:)), name: NSNotification.Name(rawValue: "xyLabelFontSize"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawMainUi.updateBoxColor(_:)), name: NSNotification.Name(rawValue: "xyLabelColor"), object: nil)

    }
    
    
    
    @objc func labelCheckBoxChanged(_ notification: NSNotification){
        print("drawMainUi:labelCheckBoxChanged")
        let name = notification.name.rawValue
        let checkBoxValue = notification.userInfo?["value"] as! Int32
        switch name {
        case "labelCheckBox":
            if(self.layouts[self.currentLayoutIndex].label != checkBoxValue){
                self.layouts[self.currentLayoutIndex].label = Int(checkBoxValue)
                updateSelectedLayout()
            }
            break
        default:
            print("worong checkBox Selected:\(name) ")
            
        }
    }
    
    @objc func updateBoxColor(_ notification: NSNotification){
        print("drawMainUi:updateBoxColor")

        let name = notification.name.rawValue
        let selectedColor = notification.userInfo?["value"] as! NSColor
        switch name {
        case "oddColorPicker":
            if(self.layouts[self.currentLayoutIndex].oddColor != selectedColor){
                self.layouts[self.currentLayoutIndex].oddColor = selectedColor
                updateSelectedLayout()
            }
            break
        case "evenColorPicker":
            if(self.layouts[self.currentLayoutIndex].evenColor != selectedColor){
                self.layouts[self.currentLayoutIndex].evenColor = selectedColor
                updateSelectedLayout()
            }
        break
        case "lineColor":
            if(self.layouts[self.currentLayoutIndex].lineColor != selectedColor){
                self.layouts[self.currentLayoutIndex].lineColor = selectedColor
                updateSelectedLayout()
            }
        case "offsetColor":
            if(self.layouts[self.currentLayoutIndex].offsetColor != selectedColor){
                self.layouts[self.currentLayoutIndex].offsetColor = selectedColor
                updateSelectedLayout()
            }
        case "xyLabelColor":
            if(self.layouts[self.currentLayoutIndex].labelColor != selectedColor){
                self.layouts[self.currentLayoutIndex].labelColor = selectedColor
                updateSelectedLayout()
            }
        default:
            print("wrong Color Picker:  \(name)")
        }
    }
    @objc func updateRoster(_ notification: NSNotification){
        print("drawMainUi:updateRoster")

        let name = notification.name.rawValue
        let value = notification.userInfo?["value"]
         if(value as! String != ""){
            print("update roster")
            switch name{
            case "hSize":
                if(self.frame.size.width != CGFloat(Int((value) as! String)!)){
                    self.frame.size.width = CGFloat(Int((value) as! String)!)
                    self.layoutSubtreeIfNeeded()
                }
                break
            case "vSize":
                if(self.frame.size.height != CGFloat(Int((value) as! String)!)){
                    self.frame.size.height = CGFloat(Int((value) as! String)!)
                    self.layoutSubtreeIfNeeded()
                }
                break
            default:
                print("wrong updateRoaster: \(name)")
                
            }
        }
    }
    
    
    
     @objc func exportToPNG(_ notification: NSNotification){
        print("drawMainUi:exportToPNG")
        let savePanel = NSSavePanel();
        savePanel.title = "Select a folder"
        savePanel.message = "Please enter PNG file Name and Select Folder"
        savePanel.begin { (result) -> Void in
           
            if(result.rawValue == NSApplication.ModalResponse.OK.rawValue){
                var path = savePanel.url!.path
                print("selected folder is \(path)");
                if(!(path.contains(".png") || path.contains(".PNG"))){
                 path = path + ".png"
                }
                var myView = self as NSView
                print("width \(myView.frame.size.width) height\(myView.frame.size.height)")
                print("bouns \(myView.bounds)")

                var rep = myView.bitmapImageRepForCachingDisplay(in: myView.bounds)!
                print("bouns \(myView.bounds)")

                myView.cacheDisplay(in: myView.bounds, to: rep)
                let url = URL(fileURLWithPath: path)
                if let data = rep.representation(using: NSBitmapImageRep.FileType.png, properties: [:]) {
                    do{
                        try data.write(to: url)
                    } catch let error {
                        print("Error: \(error)")
                    }

                    
                }

            }
        }
        
        
    }
 
 
        @objc func updateSelectedIndex(_ notification: NSNotification){
            print("drawMainUi:updateSelectedIndex")

        let value = notification.userInfo?["value"]
        self.currentLayoutIndex = value as! Int
        NotificationCenter.default.post(name : NSNotification.Name(rawValue: "updateBoxes") , object: self,userInfo: ["value" : self.layouts[self.currentLayoutIndex]])
    }
    @objc func drawUI(_ notification: NSNotification){
        print("drawMainUi:drawUI")

        let name = notification.name.rawValue
        var update = false
        let value = notification.userInfo?["value"]
        print("drawMainUi.drawUI value \(String(describing: value))")
        if(value as! String == ""){
            return
            
        }
        switch name {
        case "hPanel":
            if(self.layouts[self.currentLayoutIndex].boxWidth != Int((value) as! String)!){
               self.layouts[self.currentLayoutIndex].boxWidth = Int((value) as! String)!
                update = true
            }
        case "vPanel":
            if(self.layouts[self.currentLayoutIndex].boxHeight != Int((value) as! String)!){
                self.layouts[self.currentLayoutIndex].boxHeight = Int((value) as! String)!
                update = true
            }
        case "cols":
            if(self.layouts[self.currentLayoutIndex].countX != Int((value) as! String)!){
                self.layouts[self.currentLayoutIndex].countX = Int((value) as! String)!
                update = true
            }
        case "rows":
            if(self.layouts[self.currentLayoutIndex].countY != Int((value) as! String)!){
                self.layouts[self.currentLayoutIndex].countY = Int((value) as! String)!
                update = true
            }
         case "hStart":
            if(self.layouts[self.currentLayoutIndex].startXPoint != Int((value) as! String)!){
                self.layouts[self.currentLayoutIndex].startXPoint = Int((value) as! String)!
                update = true
            }
        case "vStart":
            if(self.layouts[self.currentLayoutIndex].startYPoint != Int((value) as! String)!){
                self.layouts[self.currentLayoutIndex].startYPoint = Int((value) as! String)!
                update = true
            }
        case "xyLabelFontSize":
            if(self.layouts[self.currentLayoutIndex].labelFontSize != Int((value) as! String)!){
                self.layouts[self.currentLayoutIndex].labelFontSize = Int((value) as! String)!
                update = true
            }
        case "outLineSize":
                if(self.layouts[self.currentLayoutIndex].outlineSize != Int((value) as! String)!){
                    self.layouts[self.currentLayoutIndex].outlineSize = Int((value) as! String)!
                    update = true
            }
        
        default:
            print("error")
        }
        if(update){
            updateSelectedLayout()
        }
   
        
    }
    
    func updateSelectedLayout(){
        print("drawMainUi:updateSelectedLayout")
    self.subviews.remove(at: self.currentLayoutIndex)
        let rect = layouts[self.currentLayoutIndex].getRect()
        let headerView = boxUi(rect ,layouts[self.currentLayoutIndex])
    headerView?.wantsLayer = true
    headerView?.layer?.backgroundColor = NSColor.yellow.cgColor
    self.subviews.insert(headerView!, at: currentLayoutIndex)
    self.layoutSubtreeIfNeeded()
    NotificationCenter.default.post(name : NSNotification.Name(rawValue: "updateLayoutDetials") , object: self,userInfo: ["value" : self.layouts[self.currentLayoutIndex]])
    }
    

}
