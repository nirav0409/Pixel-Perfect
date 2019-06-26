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
    
    var count = 1
    var selectedIndex : Int = 0
    var selectedItem : Set<IndexPath> = [[0,0]]
    var leftcount = 0
    var presetLayouts = [presetLayout]()
    var loadFilePath : String = ""
    var appDir : String = ""
    var appName: String = "PixelPerfect"

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        print("AppDelegate:numberOfItemsInSection")
        let name = collectionView.identifier?.rawValue
        switch name {
        case "rightSideCollectionView":
            return count
        case "leftSideCollectionView":
            return leftcount
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        print("AppDelegate:itemForRepresentedObjectAt")
        let name = collectionView.identifier?.rawValue
        switch name {
        case "rightSideCollectionView":
            let collectionViewItem = NSUserInterfaceItemIdentifier("sideBarCollectionView")
            let item = collectionView.makeItem(withIdentifier: collectionViewItem, for: indexPath)
            item.textField?.stringValue = "80 Panel-H \n80 Panel-V \n1 Cols \n1 Rows "
            return item
        case "leftSideCollectionView":
            let collectionViewItem = NSUserInterfaceItemIdentifier("sideBarCollectionView")
            let item = collectionView.makeItem(withIdentifier: collectionViewItem, for: indexPath)
            print("left index path \(indexPath.item)")
            item.textField?.stringValue = "\(self.presetLayouts[indexPath.item].hSize) Panel-H \n\(self.presetLayouts[indexPath.item].vSize) Panel-V \n\(self.presetLayouts[indexPath.item].countX) Cols \n\(self.presetLayouts[indexPath.item].countY) Rows "
            return item
        default:
            //this is default case . it is never going to be called. if code works well. Se below code has no meaning
            print("wrong CollectionView :\(name)")
            let collectionViewItem = NSUserInterfaceItemIdentifier("sideBarCollectionView")
            let item = collectionView.makeItem(withIdentifier: collectionViewItem, for: indexPath)
            item.textField?.stringValue = "80 Panel-H \n80 Panel-V \n1 Cols \n1 Rows "
            return item
            
        }
       
    }


    @IBOutlet weak var sideColView: NSCollectionView!
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var leftSideColView: NSCollectionView!
    
    func expandingTildeInPath(_ path: String) -> String {
        return path.replacingOccurrences(of: "~", with: FileManager.default.homeDirectoryForCurrentUser.path)
    }
    @IBAction func exportToPNG(_ sender: Any) {
        print("AppDelegate:exportToPNG")

         NotificationCenter.default.post(name : NSNotification.Name(rawValue: "exportToPNG") , object: self)
    }
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        //right side collection View
        print("appDelegate:applicationDidFinishLaunching")
        
        //check folder is there or not
        self.appDir = expandingTildeInPath("~/Library/Application Support/\(self.appName)")
        self.loadFilePath = self.appDir + "/load.txt"
        print("dir check: \(FileManager.default.fileExists(atPath: self.appDir))")
        if(!FileManager.default.fileExists(atPath: self.appDir)){
            do
            {
                try FileManager.default.createDirectory(atPath: self.appDir, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.createFile(atPath: self.loadFilePath, contents: nil, attributes: nil)
                let text = "100*100*1*1#"
                let fileURL = URL(fileURLWithPath: self.loadFilePath)
                try text.write(to: fileURL , atomically: false, encoding: .utf8)
            }
            catch let error as NSError
            {
                print("Unable to create directory \(error.debugDescription)")
            }
        }
        
        
        
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
        //load Items for left side collection View
        
        readFromFile()
        //left side collection view
        
        let leftSideCollectionView = NSUserInterfaceItemIdentifier("leftSideCollectionView")
        let leftitem = NSNib(nibNamed: "leftSideCollectionView", bundle: nil)
        leftSideColView.register(item, forItemWithIdentifier: collectionViewItem)
        leftSideColView.dataSource = self
        leftSideColView.delegate = self
        leftSideColView.allowsMultipleSelection = false
        // print(sideColView.numberOfItems(inSection: 0))
        //leftSideColView.item(at: 0)?.highlightState = .forSelection
       // leftSideColView.selectItems(at: [[0,0]], scrollPosition: NSCollectionView.ScrollPosition.top)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.updateLayoutDetials(_:)), name: NSNotification.Name(rawValue: "updateleftLayoutDetails"), object: nil)


    }
    
 
    
    func readFromFile(){
        print("appDelegate:readFromFile")


            
        let fileURL = URL(fileURLWithPath: self.loadFilePath)
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                let text2 = text.split(separator: "\n")[0].split(separator: "#")
                self.leftcount = text2.count
                for t in text2{
                 let data = t.split(separator: "*")
                    presetLayouts.append(presetLayout(data[0],v: data[1],cx: data[2],cy: data[3]))
                }
            }
            catch {
                print("error",error)}
        }
        
    
    
    func writeToFile(){
        print("appDelegate:writeToFile")

            
        let fileURL = URL(fileURLWithPath: self.loadFilePath)
        do {
                var text : String = ""
                for p in presetLayouts{
                    let data = "\(p.hSize)*\(p.vSize)*\(p.countX)*\(p.countY)#"
                    text.append(contentsOf: data)
                }
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                print("error" , error)
            }

        
    }
    @objc func updateleftLayoutDetails(_ notification : NSNotification){
        print("appDelegate:updateleftLayoutDetails")
        
        let layout  = notification.userInfo?["value"] as! myLayout
        leftSideColView.item(at: self.selectedIndex)?.textField?.stringValue = "\(layout.totalWidth) Panel-H \n\(layout.totalHeight) Panel-V \n\(layout.countX) Cols  \n\(layout.countY) Rows"
    }
    
    
    @objc func updateLayoutDetials(_ notification : NSNotification){
        print("appDelegate:updateLayoutDetials")

        let layout  = notification.userInfo?["value"] as! myLayout
        
        sideColView.item(at: self.selectedIndex)?.textField?.stringValue = "\(layout.boxWidth) Panel-H \n\(layout.boxHeight) Panel-V \n\(layout.countX) Cols  \n\(layout.countY) Rows"
    }
    
    
    @IBAction func removeButtonClicked(_ sender: Any) {
        print("appDelegate:removeButtonClicked")
        if(self.count > 1){
            let removeAtIndexPath = IndexPath(item: selectedIndex, section: 0)
            var indexPaths: Set<IndexPath> = []
            indexPaths.insert(removeAtIndexPath)
            self.count = self.count - 1
            self.sideColView.performBatchUpdates({
                self.sideColView.deleteItems(at: indexPaths)
            }, completionHandler: nil)
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "removeLayout") , object: self)
            if(selectedIndex != 0){
                selectedIndex = selectedIndex - 1
            }
            indexPaths.removeAll()
            indexPaths.insert(IndexPath(item : (selectedIndex) , section : 0))
            sideColView.deselectItems(at: selectedItem)
            sideColView.selectItems(at: indexPaths, scrollPosition: NSCollectionView.ScrollPosition.bottom)
            self.selectedItem = indexPaths
            
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        print("appDelegate:addButtonClicked")
        let insertAtIndexPath = IndexPath(item: self.count, section: 0)
        self.selectedIndex = count
        self.count = self.count+1
        var indexPaths: Set<IndexPath> = []
        indexPaths.insert(insertAtIndexPath)
        self.sideColView.performBatchUpdates({
             self.sideColView.insertItems(at: indexPaths)
        }, completionHandler: nil)
        sideColView.item(at: insertAtIndexPath)?.textField?.stringValue = "80 Panel-H \n80 Panel-V \n1 Cols \n1 Rows"
        sideColView.deselectItems(at: selectedItem)
        sideColView.selectItems(at: indexPaths, scrollPosition: NSCollectionView.ScrollPosition.bottom)
        self.selectedItem = indexPaths
        NotificationCenter.default.post(name : NSNotification.Name(rawValue: "addLayout") , object: self,userInfo: ["value" :presetLayout()])

        
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        print("appDelegate:didSelectItemsAt")
        let name = collectionView.identifier?.rawValue
        switch name {
        case "rightSideCollectionView":
            self.selectedIndex = (indexPaths.first)![1]
            self.selectedItem =  indexPaths
            NotificationCenter.default.post(name : NSNotification.Name(rawValue: "selectionChanged") , object: self,userInfo: ["value" : (indexPaths.first)![1]])
        case "leftSideCollectionView":
            print("Left Side selected")
            addPresetLayout(presetLayouts[(indexPaths.first)![1]])
            leftSideColView.deselectItems(at: indexPaths)
        default:
            print("wrong Collection View Selected")
        
        }
    
        
    }
    func addPresetLayout(_ presetLayout: presetLayout){
        print("appDelefate:addPresetLayout")
        let insertAtIndexPath = IndexPath(item: self.count, section: 0)
        self.selectedIndex = count
        self.count = self.count + 1
        var indexPaths: Set<IndexPath> = []
        indexPaths.insert(insertAtIndexPath)
        self.sideColView.performBatchUpdates({
            self.sideColView.insertItems(at: indexPaths)
        }, completionHandler: nil)
        sideColView.item(at: insertAtIndexPath)?.textField?.stringValue = "\(presetLayout.hSize) Panel-H \n\(presetLayout.vSize) Panel-V \n\(presetLayout.countX) Cols \n\(presetLayout.countY) Rows"
        self.sideColView.deselectItems(at: self.selectedItem)
        self.sideColView.selectItems(at: indexPaths, scrollPosition: NSCollectionView.ScrollPosition.bottom)
        self.selectedItem = indexPaths
        NotificationCenter.default.post(name : NSNotification.Name(rawValue: "addLayout") , object: self ,userInfo: ["value" :presetLayout])

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        print("appDelegate:applicationWillTerminate")
        

    }
   
    
    @IBAction func addToPreset(_ sender: Any) {
        print("appDelegate:addtoPreSet")
        //add data to presetLayout
        let data = (sideColView.item(at: self.selectedIndex)?.textField?.stringValue)?.split(separator: "\n")
        var values = [Substring]()
        for row in data! {
            var temp =  row.trimmingCharacters(in: .whitespaces).split(separator: " ")
            values.append(temp[0])
        }
        presetLayouts.append(presetLayout(values[0],v: values[1],cx: values[2],cy: values[3]))
        //add item in left side collection view
        var indexPaths: Set<IndexPath> = []
        let insertAtIndexPath = IndexPath(item: self.leftcount, section: 0)
        self.leftcount = self.leftcount + 1
     
        indexPaths.insert(insertAtIndexPath)
        self.leftSideColView.performBatchUpdates({
            self.leftSideColView.insertItems(at: indexPaths)
        }, completionHandler: nil)
        writeToFile()
    
    }
    
}
class presetLayout {
    var hSize :Int
    var vSize :Int
    var countX :Int
    var countY :Int
    
    init() {
        self.hSize = 80
        self.vSize = 80
        self.countX = 1
        self.countY = 1
    
    }
    init(_ h :Substring , v :Substring , cx : Substring , cy : Substring) {
        self.hSize =  Int((String(h)))!
        self.vSize = Int((String(v)))!
        self.countX = Int((String(cx)))!
        self.countY = Int((String(cy)))!
        
    }
}

