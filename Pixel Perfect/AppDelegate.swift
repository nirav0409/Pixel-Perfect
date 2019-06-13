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

    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let collectionViewItem = NSUserInterfaceItemIdentifier("sideBarCollectionView")
        let item = collectionView.makeItem(withIdentifier: collectionViewItem, for: indexPath)
        return item
    }
    

    @IBOutlet weak var sideColView: NSCollectionView!
    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print("appDelegate.applicationDidFinishLaunching")
        let collectionViewItem = NSUserInterfaceItemIdentifier("sideBarCollectionView")
        let item = NSNib(nibNamed: "sideBarCollectionView", bundle: nil)
        sideColView.register(item, forItemWithIdentifier: collectionViewItem)
        sideColView.dataSource = self
        sideColView.delegate = self
      //  drawMainUi.registerNotification()

    }
    
    
    @IBAction func removeButtonClicked(_ sender: Any) {
        print("Remove Layout")
        if(count > 0){
        let removeAtIndexPath = IndexPath(item: count-1, section: 0)
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

        //var b = boxUi()
        
    }
    
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    
}

