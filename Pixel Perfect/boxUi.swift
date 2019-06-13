//
//  boxUi.swift
//  Pixel Perfect
//
//  Created by Nirav Patel on 09/06/19.
//  Copyright © 2019 Nirav Patel. All rights reserved.
//

import Cocoa

class boxUi: NSView {

    var startXPoint = 0
    var startYPoint = 0
    var countX = 1
    var countY = 1
    var totalHeight = 80
    var totalWidth = 80
    
    
    required init?(_ dirtyRect: NSRect,_ layout :myLayout){
        super.init(frame :dirtyRect)
        print("boxUi.init")
        self.startXPoint = 0
        self.startYPoint = 0
        self.countX = layout.countX
        self.countY = layout.countY
        self.totalHeight = layout.totalHeight
        self.totalWidth = layout.totalWidth
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        print("boxUi.draw")
       // initValues()
        drawUI2()
    }
  

    
    func UpdateUi(){
        self.subviews.removeAll()
        self.layoutSubtreeIfNeeded()
    }
     func drawUI2(){
        
        let squareWidth = totalWidth
        let squareHeight = totalHeight
        
        let offset = 1
        var startX = startXPoint
        var startY = startYPoint
        for _ in 0...(countY - 1){
            for _ in 0...(countX - 1) {
                drawRact(startX, startYPoint: startY , h: totalHeight, w: totalWidth)
                startX = startX + totalWidth + offset
            }
            startX = startXPoint
            startY = startY + totalHeight + offset
        }
        //crossLine Going Upwords
        let lineHeight = (totalHeight + offset) * countY
        let lineWidth  = (totalWidth + offset) * countX
        drawCrossUpwordsLine(startXPoint,startYPoint: startYPoint,h: lineHeight,w: lineWidth)
        
        //crossLine Going Downwords
        drawCrossDownwordsLine(startXPoint,startYPoint: startYPoint,h: lineHeight,w: lineWidth)
        
    }
    func drawRact(_ startXPoint: Int, startYPoint: Int, h: Int, w: Int){
        
        let cg = CGRect(x: startXPoint, y: (Int(bounds.height)-startYPoint-h), width: w, height: h)
        let smallRact = NSBezierPath(rect: cg)
    //    NSColor.blue.setFill()
        smallRact.fill()
        
    }
    
    
    func drawCrossUpwordsLine(_ startXPoint: Int, startYPoint: Int, h: Int, w: Int){
        let  startX = startXPoint
        let  startY = (Int(bounds.height) - startYPoint) - h
        let  endX = startXPoint+w
        let  endY = (Int(bounds.height) - startYPoint)
        
        let crossUpPath = NSBezierPath()
        NSColor.red.setStroke()

        crossUpPath.move(to: NSPoint(x: startX, y: startY))
        crossUpPath.line(to: NSPoint(x: endX, y: endY))
        crossUpPath.stroke()
    }
    
    func drawCrossDownwordsLine(_ startXPoint: Int, startYPoint: Int, h: Int, w: Int){
        let  startX = startXPoint
        let  startY = (Int(bounds.height) - startYPoint)
        let  endX = startXPoint+w
        let  endY = (Int(bounds.height) - startYPoint) - h

        let crossDownPath = NSBezierPath()
        
        crossDownPath.move(to: NSPoint(x: startX, y: startY))
        crossDownPath.line(to: NSPoint(x: endX, y: endY))
        NSColor.red.setStroke()
        crossDownPath.stroke()
    }
    
}
