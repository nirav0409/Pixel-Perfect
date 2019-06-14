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
    var totalHeight = 80
    var totalWidth = 80
    var offset = 1
    
    init(){
        
    }
    func getRect() -> CGRect{
        var rect = CGRect(x: startXPoint, y: startYPoint, width: ((totalWidth+offset) * countX + offset) , height: ((totalHeight+offset) * countY + offset))
        return rect
    }
    
}

class drawMainUi: NSView {

    var currentLayoutIndex: Int = -1
    var layouts = [myLayout]()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("drawMainUi.init")
        initBasic()
        registerNotification()
    }
    
    
    func initBasic(){
        var layout = myLayout()
        var rect = layout.getRect()
        var headerView = boxUi(rect ,layout)
        headerView?.wantsLayer = true
        headerView?.layer?.backgroundColor = NSColor.yellow.cgColor
       
        layouts.append(layout)
        self.currentLayoutIndex = 0
        self.subviews.append((headerView)!)
        
    }

    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        print("drawMainUi.draw")
    }
    
    @objc func addLayout(_ notification: NSNotification){
        
        var layout = myLayout()
        var rect = layout.getRect()
        var headerView = boxUi(rect ,layout)
        headerView?.wantsLayer = true
        headerView?.layer?.backgroundColor = NSColor.yellow.cgColor
        layouts.append(layout)
        self.subviews.append(headerView!)
        self.currentLayoutIndex = layouts.count - 1


    }
    @objc func removeLayout(_ notification: NSNotification){
        
        if(layouts.count > 0){
            self.subviews.remove(at: self.currentLayoutIndex)
            layouts.remove(at: self.currentLayoutIndex)
            if(layouts.count > 0){
                self.currentLayoutIndex = 0
            }
            else{
                self.currentLayoutIndex = -1
                
            }
        }

    }
    
     func registerNotification()  {
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
    }
     @objc func exportToPNG(_ notification: NSNotification){
      // let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
      // var myView = NSView(frame: rect)
        var i : Int = 0
        var myView = self as! NSView
        /*for views in self.subviews{
            i += 1
            print(i)
            myView.addSubview(views)
        }*/
        var rep = myView.bitmapImageRepForCachingDisplay(in: myView.bounds)!
        myView.cacheDisplay(in: myView.bounds, to: rep)
        var image = "myTestimage.png"
        var url = URL(fileURLWithPath: image)
        if let data = rep.representation(using: NSBitmapImageRep.FileType.png, properties: [:]) {
            do{
                try data.write(to: url)
            } catch let error {
                print("Error: \(error)")
            }
            
        }
        
    }
 
 
        @objc func updateSelectedIndex(_ notification: NSNotification){
        let value = notification.userInfo?["value"]
        self.currentLayoutIndex = value as! Int
        NotificationCenter.default.post(name : NSNotification.Name(rawValue: "updateBoxes") , object: self,userInfo: ["value" : self.layouts[self.currentLayoutIndex]])
    }
    @objc func drawUI(_ notification: NSNotification){
        
        let name = notification.name.rawValue
        var update = false
        let value = notification.userInfo?["value"]
        print("drawMainUi.drawUI value \(value)")
        if(value as! String == ""){
            return
            
        }
        switch name {
        case "hPanel":
            if(self.layouts[self.currentLayoutIndex].totalWidth != Int((value) as! String)!){
               self.layouts[self.currentLayoutIndex].totalWidth = Int((value) as! String)!
                update = true
            }
        case "vPanel":
            if(self.layouts[self.currentLayoutIndex].totalHeight != Int((value) as! String)!){
                self.layouts[self.currentLayoutIndex].totalHeight = Int((value) as! String)!
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
        default:
            print("error")
        }
        if(update){
            print("updating layout")
            self.subviews.remove(at: self.currentLayoutIndex)
            var rect = layouts[self.currentLayoutIndex].getRect()
            var headerView = boxUi(rect ,layouts[self.currentLayoutIndex])
            headerView?.wantsLayer = true
            headerView?.layer?.backgroundColor = NSColor.yellow.cgColor
            self.subviews.insert(headerView!, at: currentLayoutIndex)
            self.layoutSubtreeIfNeeded()
             NotificationCenter.default.post(name : NSNotification.Name(rawValue: "updateLayoutDetials") , object: self,userInfo: ["value" : self.layouts[self.currentLayoutIndex]])
        }
   
        
    }
    
    
    
}
