//
//  downBarUi.swift
//  Pixel Perfect
//
//  Created by Nirav Patel on 07/06/19.
//  Copyright © 2019 Nirav Patel. All rights reserved.
//

import Cocoa

class downBarUi: NSView {

    @IBOutlet weak var hPanel: NSTextField!
    @IBOutlet weak var vPanel: NSTextField!
    @IBOutlet weak var cols: NSTextField!
    @IBOutlet weak var rows: NSTextField!
    @IBOutlet weak var hStart: NSTextField!
    @IBOutlet weak var vStart: NSTextField!
    @IBOutlet weak var hSize: NSTextField!
    @IBOutlet weak var vSize: NSTextField!
    @IBOutlet weak var lineColor: NSColorWell!
    @IBOutlet weak var evenColor: NSColorWell!
    @IBOutlet weak var oddColor: NSColorWell!
    @IBOutlet weak var xyLabelColor: NSColorWell!
    @IBOutlet weak var xyLabelFontSize: NSTextField!
    @IBOutlet weak var outLineSize: NSTextField!

 

    @IBAction func CheckboxChecked(_ sender: NSButton) {
        print("downBarUi:CheckboxChecked")

        let mySender =  sender.identifier?.rawValue
        switch mySender {
        case "labelCheckBox":
            print("bull's eye")
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "labelCheckBox") , object: self , userInfo: ["value" : sender.intValue])
            return
        default:
            print("wrong checkBox :\(String(describing: mySender))")
        }
    }
    
    
    @IBAction func ColorChangeListerner(_ sender: NSColorWell) {
        print("downBarUi:ColorChangeListerner")

        let mySender =  sender.identifier?.rawValue
        let value = sender.color
        switch mySender {
        case "evenColorPicker":
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "evenColorPicker") , object: self , userInfo: ["value" : value])
            return
        case "oddColorPicker":
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "oddColorPicker") , object: self , userInfo: ["value" : value])
            return
        case "lineColor":
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "lineColor") , object: self , userInfo: ["value" : value])
            return
        case "xyLabelColor":
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "xyLabelColor") , object: self , userInfo: ["value" : value])
            return
        default:
            print("wrong ColorPicker : \(String(describing: mySender))")
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        print("downBarUi:draw")

        hPanel.intValue = 80;
        vPanel.intValue = 80;
        cols.intValue = 1;
        rows.intValue = 1;
        hStart.intValue = 0;
        vStart.intValue = 0;
        hSize.intValue = 1920;
        vSize.intValue = 1080;

        evenColor.color = NSColor.orange
        oddColor.color = NSColor.red
        lineColor.color = NSColor.blue
        NotificationCenter.default.addObserver(self, selector: #selector(downBarUi.updateBoxes(_:)), name: NSNotification.Name(rawValue: "updateBoxes"), object: nil)
        
        // Drawing code here.
        
    }

    @objc func updateBoxes(_ notification: NSNotification){
        print("downBarUi:updateBoxes")

        let value = notification.userInfo?["value"]
        let layout =  value as! myLayout
        hPanel.intValue = Int32(layout.boxWidth)
        vPanel.intValue = Int32((layout.boxHeight))
        cols.intValue = Int32((layout.countX))
        rows.intValue = Int32((layout.countY))
        hStart.intValue = Int32((layout.startXPoint))
        vStart.intValue = Int32((layout.startYPoint))
        evenColor.color = layout.evenColor
        oddColor.color = layout.oddColor
        lineColor.color = layout.lineColor

        
    }
    @IBAction func NsTextViewChanged(_ sender: NSTextField) {
        print("downBarUi:NsTextViewChanged")

        var value = sender.stringValue
        value = value.replacingOccurrences(of: ",", with: "")
        switch sender.identifier?.rawValue {
        case "hPanel":
            print("h panel changed")
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "hPanel") , object: self , userInfo: ["value" : value])
        case "vPanel":
            print("v Panel Changed")
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "vPanel") , object: self , userInfo: ["value" : value])

            
        case "cols":
            print("cols Changed")
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "cols") , object: self , userInfo: ["value" : value])

            
        case "rows":
            print("rows Changed")
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "rows") , object: self , userInfo: ["value" : value])

            
        case "hStart":
            print("h Start Changed")
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "hStart") , object: self , userInfo: ["value" : value])

            
        case "vStart":
            print("V Start Changed")
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "vStart") , object: self , userInfo: ["value" : value])
            
        case "hSize":
            print("H Size Changed")
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "hSize") , object: self , userInfo: ["value" : value])
            
        case "vSize":
            print("V Size Changed")
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "vSize") , object: self , userInfo: ["value" : value])
            
        case "outLineSize":
            print("outLine Size Changed")
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "outLineSize") , object: self , userInfo: ["value" : value])
            
        case "xyLabelFontSize":
            print("xyLabel Font Size  Changed")
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "xyLabelFontSize") , object: self , userInfo: ["value" : value])
            
        default:
            print("noting")
        }
    }
    
}
