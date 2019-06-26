//
//  boxUi.swift
//  Pixel Perfect
//
//  Created by Nirav Patel on 09/06/19.
//  Copyright © 2019 Nirav Patel. All rights reserved.
//

import Cocoa

class boxUi: NSView {

    var hStart = 0
    var vStart = 0
    var startXPoint = 0
    var startYPoint = 0
    var countX = 1
    var countY = 1
    var boxWidth = 80
    var boxHeight = 80
    var totalHeight = 80
    var totalWidth = 80
    var evenColor = NSColor.orange
    var oddColor = NSColor.red
    var lineColor = NSColor.blue
    var offset = 0
    var label = 1
    var labelColor = NSColor.white
    var labelFontSize = 10
    var outlineSize = 0
    
    required init?(_ dirtyRect: NSRect,_ layout :myLayout){
        super.init(frame :dirtyRect)
        print("boxUi:init")
        self.hStart = layout.startXPoint
        self.vStart = layout.startYPoint
        self.startXPoint = offset
        self.startYPoint = offset
        self.countX = layout.countX
        self.countY = layout.countY
        self.boxWidth = layout.boxWidth
        self.boxHeight = layout.boxHeight
        self.totalHeight = layout.totalHeight
        self.totalWidth = layout.totalWidth
        self.evenColor = layout.evenColor
        self.oddColor = layout.oddColor
        self.lineColor = layout.lineColor
        self.label = layout.label
        self.labelColor = layout.labelColor
        self.labelFontSize = layout.labelFontSize
        self.outlineSize = layout.outlineSize
        
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        print("boxUi:draw")
       // initValues()
        drawUI2()
    }

  
    override var isFlipped: Bool{
     return true
    }
    
    func UpdateUi(){
        print("boxUi:UpdateUi")

        self.subviews.removeAll()
        self.layoutSubtreeIfNeeded()
    }
     func drawUI2(){
        print("boxUi:drawUI2")

        
        var startX = startXPoint
        var startY = startYPoint
        for indexY in 0...(countY - 1){
            for indexX in 0...(countX - 1) {
                let boxColor :NSColor
                if((indexX + indexY) % 2 == 0 ){
                     boxColor = self.oddColor
                }else{
                     boxColor = self.evenColor
                }
                if(indexX == 0 && indexY == (countY-1) && self.label == 1){
                    drawRact(startX, startYPoint: startY , h: boxHeight, w: boxWidth , boxColor: boxColor, label: 1)
                    
                }else{
                    drawRact(startX, startYPoint: startY , h: boxHeight, w: boxWidth , boxColor: boxColor , label : 0)
                }
                startX = startX + boxWidth + offset
            }
            startX = startXPoint
            startY = startY + boxHeight + offset
        }
        //crossLine Going Upwords
        drawCrossUpwordsLine(startXPoint,startYPoint: startYPoint,h: totalHeight,w: totalWidth)
        
        //crossLine Going Downwords
        drawCrossDownwordsLine(startXPoint,startYPoint: startYPoint,h: totalHeight,w: totalWidth)
        
    }
    func drawRact(_ startXPoint: Int, startYPoint: Int, h: Int, w: Int , boxColor: NSColor, label:Int){
        print("boxUi:drawRact")

        let cg = CGRect(x: startXPoint, y: (Int(bounds.height)-startYPoint-h), width: w, height: h)
        let smallRact = NSBezierPath(rect: cg)
        boxColor.setFill()
    //    NSColor.blue.setFill()
        smallRact.fill()

        if(label == 1){
            let label = NSTextField(frame : cg)
            label.textColor = self.labelColor
            label.alignment = .left
            label.font = NSFont(name: "Arial", size: CGFloat(self.labelFontSize))
            label.stringValue = "H:\(self.hStart) V:\(self.vStart)"
            self.addSubview(label)
        }
        
    }
    
    
    func drawCrossUpwordsLine(_ startXPoint: Int, startYPoint: Int, h: Int, w: Int){
        print("boxUi:drawCrossUpwordsLine")

        let  startX = startXPoint
        let  startY = (Int(bounds.height) - startYPoint) - h
        let  endX = startXPoint+w
        let  endY = (Int(bounds.height) - startYPoint)
        
        let crossUpPath = NSBezierPath()
        crossUpPath.lineWidth = CGFloat(self.outlineSize)
        self.lineColor.setStroke()

        crossUpPath.move(to: NSPoint(x: startX, y: startY))
        crossUpPath.line(to: NSPoint(x: endX, y: endY))
        crossUpPath.stroke()
    }
    
    func drawCrossDownwordsLine(_ startXPoint: Int, startYPoint: Int, h: Int, w: Int){
        print("boxUi:drawCrossDownwordsLine")

        let  startX = startXPoint
        let  startY = (Int(bounds.height) - startYPoint)
        let  endX = startXPoint+w
        let  endY = (Int(bounds.height) - startYPoint) - h

        let crossDownPath = NSBezierPath()
        crossDownPath.lineWidth = CGFloat(self.outlineSize)

        crossDownPath.move(to: NSPoint(x: startX, y: startY))
        crossDownPath.line(to: NSPoint(x: endX, y: endY))
        self.lineColor.setStroke()
        crossDownPath.stroke()
    }
    
}
