//
//  leftSideCollectionView.swift
//  Pixel Perfect
//
//  Created by Nirav Patel on 24/06/19.
//  Copyright © 2019 Nirav Patel. All rights reserved.
//

import Cocoa

class leftSideCollectionView: NSCollectionViewItem {

   
    override var isSelected: Bool{
        didSet{
            super.isSelected = isSelected
            updateColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("leftSideCollectionView:viewDidLoad")
        self.view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor
    }
    
  
    
    func updateColor(){
        if isSelected{
            print("sideBarCollectionView:updateColor")
            switch highlightState {
            case .none:
                view.layer?.backgroundColor = NSColor.black.cgColor
                break
            case .forSelection:
                view.layer?.backgroundColor = NSColor.gray.cgColor
                break
            case .forDeselection:
                view.layer?.backgroundColor = NSColor.black.cgColor
                break
            default:
                print("isSelected Default case")
                break
            }
        }else{
            view.layer?.backgroundColor = NSColor.black.cgColor
            
        }
        
    }
    
}
