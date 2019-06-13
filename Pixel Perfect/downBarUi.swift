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

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        hPanel.intValue = 80;
        vPanel.intValue = 80;
        cols.intValue = 1;
        rows.intValue = 1;
        hStart.intValue = 0;
        vStart.intValue = 0;

        // Drawing code here.
    }
    

    @IBAction func NsTextViewChanged(_ sender: NSTextField) {
        var value = sender.stringValue
        
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

            
        default:
            print("noting")
        }
    }
    
}
