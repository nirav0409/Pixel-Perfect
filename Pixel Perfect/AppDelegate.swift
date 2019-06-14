//
//  AppDelegate.swift
//  Pixel Perfect
//
//  Created by Nirav Patel on 06/06/19.
//  Copyright © 2019 Nirav Patel. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,NSCollectionViewDelegate,NSCollectionViewDataSource {
    
    var count = 1;
    var selectedIndex : Int = 0

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let collectionViewItem = NSUserInterfaceItemIdentifier("sideBarCollectionView")
        let item = collectionView.makeItem(withIdentifier: collectionViewItem, for: indexPath)
        item.textField?.stringValue = "80 Panel-H \n80 Panel-V \n1 Cols \n1 Rows "
        //item.highlightState = .forSelection
       // item.isSelected = true
    
        return item
    }


    @IBOutlet weak var sideColView: NSCollectionView!
    @IBOutlet weak var window: NSWindow!

    @IBAction func exportToPNG(_ sender: Any) {
         NotificationCenter.default.post(name : NSNotification.Name(rawValue: "exportToPNG") , object: self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print("appDelegate.applicationDidFinishLaunching")
        let collectionViewItem = NSUserInterfaceItemIdentifier("sideBarCollectionView")
        let item = NSNib(nibNamed: "sideBarCollectionView", bundle: nil)
        sideColView.register(item, forItemWithIdentifier: collectionViewItem)
        sideColView.dataSource = self
        sideColView.delegate = self
        sideColView.allowsMultipleSelection = false
       // print(sideColView.numberOfItems(inSection: 0))
        print(sideColView.indexPathsForVisibleItems())
        sideColView.item(at: 0)?.highlightState = .forSelection
        sideColView.selectItems(at: [[0,0]], scrollPosition: NSCollectionView.ScrollPosition.top)
         NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.updateLayoutDetials(_:)), name: NSNotification.Name(rawValue: "updateLayoutDetials"), object: nil)

      //  drawMainUi.registerNotification()

    }
    @objc func updateLayoutDetials(_ notification : NSNotification){
        var layout  = notification.userInfo?["value"] as! myLayout
        
        sideColView.item(at: self.selectedIndex)?.textField?.stringValue = "\(layout.totalWidth) Panel-H \n\(layout.totalHeight) Panel-V \n\(layout.countX) Cols  \n\(layout.countY) Rows"
    }
    
    
    @IBAction func removeButtonClicked(_ sender: Any) {
        print("Remove Layout")
        if(count > 0){
        let removeAtIndexPath = IndexPath(item: selectedIndex, section: 0)
        var indexPaths: Set<IndexPath> = []
        indexPaths.insert(removeAtIndexPath)
        count = count - 1
        self.sideColView.performBatchUpdates({
            self.sideColView.deleteItems(at: indexPaths)
        }, completionHandler: nil)}
        NotificationCenter.default.post(name : NSNotification.Name(rawValue: "removeLayout") , object: self)

    }
    @IBAction func addButtonClicked(_ sender: Any) {
        print("add Layout")
        let insertAtIndexPath = IndexPath(item: count, section: 0)
        count = count+1
        var indexPaths: Set<IndexPath> = []
        indexPaths.insert(insertAtIndexPath)
        self.sideColView.performBatchUpdates({
             self.sideColView.insertItems(at: indexPaths)
        }, completionHandler: nil)
        
        NotificationCenter.default.post(name : NSNotification.Name(rawValue: "addLayout") , object: self)

     //   sideColView.selectItems(at: [[0,count-1]], scrollPosition: NSCollectionView.ScrollPosition.top)

        //var b = boxUi()
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
      
        self.selectedIndex = (indexPaths.first)![1]
        NotificationCenter.default.post(name : NSNotification.Name(rawValue: "selectionChanged") , object: self,userInfo: ["value" : (indexPaths.first)![1]])
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    
}

