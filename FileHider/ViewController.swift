//
//  ViewController.swift
//  FileHider
//
//  Created by Chih-Hao on 2018/1/11.
//  Copyright © 2018年 Chih-Hao. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var dragView: DragDestinationView!
    @IBOutlet weak var tableview: NSTableView!
    @IBOutlet var infoTextView: NSTextView!
    @IBOutlet var fileName: NSTextField!
    
    @IBOutlet var toggleButton: NSSegmentedControl!
    
    @IBOutlet var fileImage: NSImageView!
    
    
    var filesList : [URL] = []
    
    @IBAction func deleteRow(_ sender: Any) {
        if tableview.selectedRow >= 0 {
            filesList.remove(at: tableview.selectedRow)
            tableview.reloadData()
            
            infoTextView.string = ""
            fileImage.image = nil
            fileName.stringValue = ""
            toggleButton.isHidden = true
        }
       
    }
    
    
    var selectedItem : URL? {
        didSet {
            guard let selectedUrl = selectedItem else {
                return
            }
            
            infoTextView.string = ""
            
             fileImage.image = NSWorkspace.shared().icon(forFile: selectedUrl.path)
            
            let infoString = infoAbout(url: selectedUrl)
            if !infoString.isEmpty {
                let formattedText = formatInfoText(infoString)
                infoTextView.textStorage?.setAttributedString(formattedText)
            }
        
        }
        
    }
    
    @IBOutlet weak var splitView: NSSplitView!
    
    var selectedFolder: URL? {
        didSet {
            if let selectedFolder = selectedFolder{
                filesList.append(selectedFolder)
                self.tableview.reloadData()
                self.tableview.scrollRowToVisible(0)
            }
        }
        
    }
    
    @IBAction func onOffToggle(_ sender: Any) {
        var path: String = ""
        
        if let len = selectedItem?.pathComponents.count{
            for i in 1...len-2{
                path += "/" + (selectedItem?.pathComponents[i])!
            }
        }
        
        let task = Process()
        
        task.launchPath = "/bin/mv"
        
        if (sender as AnyObject).selectedSegment == 1{   // hide
            if((selectedItem?.lastPathComponent)!.hasPrefix(".")){
                let start = (selectedItem?.lastPathComponent)!.index((selectedItem?.lastPathComponent)!.startIndex, offsetBy: 1);
                let str1 = (selectedItem?.lastPathComponent)!.substring(from: start)
                
                task.arguments = [path + "/" + str1,path + "/" + (selectedItem?.lastPathComponent)!]
                
                for i in 0..<filesList.count {
                    if filesList[i].absoluteString == selectedItem?.absoluteString{
                        
                        var fileName = "file:"
                        var fileNameArray = filesList[i].absoluteString.components(separatedBy: "/")
                        
                        for i in 1..<fileNameArray.count - 2{
                            fileName += "/"+fileNameArray[i]
                        }
                        
                        if fileNameArray[fileNameArray.count - 1] == ""{
                            fileName += "/" + fileNameArray[fileNameArray.count - 2]
                        }else{
                            fileName += "/" + fileNameArray[fileNameArray.count - 2] + "/" + fileNameArray[fileNameArray.count - 1]
                        }
                        
                        filesList[i] = URL(string:fileName)!
                    }
                }
            }else{
                task.arguments = [path + "/" + (selectedItem?.lastPathComponent)!,path + "/" + "."+(selectedItem?.lastPathComponent)!]
                
                for i in 0..<filesList.count {
                    if filesList[i].absoluteString == selectedItem?.absoluteString{
                        
                        var fileName = "file:"
                        var fileNameArray = filesList[i].absoluteString.components(separatedBy: "/")
                        
                        for i in 1..<fileNameArray.count - 2{
                            fileName += "/"+fileNameArray[i]
                        }
                        
                        if fileNameArray[fileNameArray.count - 1] == ""{
                            fileName += "/." + fileNameArray[fileNameArray.count - 2]
                        }else{
                            fileName += "/" + fileNameArray[fileNameArray.count - 2] + "/." + fileNameArray[fileNameArray.count - 1]
                        }
                        
                        filesList[i] = URL(string:fileName)!
                    }
                }
            }
        }else{ // unhide
            var fileNameOfSelectedItem = "file:"
            var fileNameOfSelectedItemArray = (selectedItem?.absoluteString.components(separatedBy: "/"))
            
            for i in 1..<(fileNameOfSelectedItemArray?.count)! - 2{
                fileNameOfSelectedItem += "/"+fileNameOfSelectedItemArray![i]
            }
        
            
            
            if((selectedItem?.lastPathComponent)!.hasPrefix(".")){
                
                if fileNameOfSelectedItemArray![(fileNameOfSelectedItemArray?.count)! - 1] == ""{
                    fileNameOfSelectedItem += "/" + fileNameOfSelectedItemArray![(fileNameOfSelectedItemArray?.count)! - 2]
                }else{
                    fileNameOfSelectedItem += "/" + fileNameOfSelectedItemArray![(fileNameOfSelectedItemArray?.count)! - 2] + "/" + fileNameOfSelectedItemArray![(fileNameOfSelectedItemArray?.count)! - 1]
                }
                
                let start = (selectedItem?.lastPathComponent)!.index((selectedItem?.lastPathComponent)!.startIndex, offsetBy: 1);
                let str1 = (selectedItem?.lastPathComponent)!.substring(from: start)
                
                task.arguments = [path + "/" + (selectedItem?.lastPathComponent)!,path + "/" + str1]
                
                
                for i in 0..<filesList.count {
                    if filesList[i].absoluteString == fileNameOfSelectedItem{
                        var fileName = "file:"
                        var fileNameArray = filesList[i].absoluteString.components(separatedBy: "/")
                        for i in 1..<fileNameArray.count - 2{
                            fileName += "/"+fileNameArray[i]
                        }
                        
                        if fileNameArray[fileNameArray.count - 1] == ""{
                            let hiddenfileName = fileNameArray[fileNameArray.count - 2]
                            let start = hiddenfileName.index(hiddenfileName.startIndex, offsetBy: 1)
                            let unhiddenFileName : String? = hiddenfileName.substring(from: start)
                            
                            fileName += "/" + str1
                        }else{
                            let hiddenfileName = fileNameArray[fileNameArray.count - 1]
                            let start = hiddenfileName.index(hiddenfileName.startIndex, offsetBy: 1)
                            let unhiddenFileName : String? = hiddenfileName.substring(from: start)
                            
                            fileName += "/" + fileNameArray[fileNameArray.count - 2] + "/" + unhiddenFileName!
                        }
                        filesList[i] = URL(string:fileName)!
                    }
                }
                
                
            }else{
                if fileNameOfSelectedItemArray![(fileNameOfSelectedItemArray?.count)! - 1] == ""{
                    fileNameOfSelectedItem += "/." + fileNameOfSelectedItemArray![(fileNameOfSelectedItemArray?.count)! - 2]
                }else{
                    fileNameOfSelectedItem += "/" + fileNameOfSelectedItemArray![(fileNameOfSelectedItemArray?.count)! - 2] + "/." + fileNameOfSelectedItemArray![(fileNameOfSelectedItemArray?.count)! - 1]
                }
                task.arguments = [path + "/" + "."+(selectedItem?.lastPathComponent)!,path + "/" + (selectedItem?.lastPathComponent)!]
                
                
                for i in 0..<filesList.count {
                    if filesList[i].absoluteString == fileNameOfSelectedItem{
                        var fileName = "file:"
                        var fileNameArray = filesList[i].absoluteString.components(separatedBy: "/")
                        for i in 1..<fileNameArray.count - 2{
                            fileName += "/"+fileNameArray[i]
                        }
                        
                        if fileNameArray[fileNameArray.count - 1] == ""{
                            let hiddenfileName = fileNameArray[fileNameArray.count - 2]
                           
                            fileName += "/" + hiddenfileName
                        }else{
                            
                            let hiddenfileName = fileNameArray[fileNameArray.count - 1]
                          
                            fileName += "/" + fileNameArray[fileNameArray.count - 2] + "/" + hiddenfileName
                        }
                        filesList[i] = URL(string:fileName)!
                    }
                }
            }
        }
        
        
        task.launch()
        task.waitUntilExit()
        
    }
    
    @IBAction func selectFile(_ sender: Any) {
        
        let openPanel = NSOpenPanel()
        
        openPanel.message = "Please select file to Hide"
        openPanel.canChooseDirectories = true
        //    openPanel.allowsMultipleSelection = true
        
        openPanel.beginSheetModal(for: view.window!, completionHandler: {(result) in
            if result == NSModalResponseOK{
                self.selectedFolder = openPanel.url!
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        self.view.layer?.backgroundColor=NSColor.white.cgColor

        self.dragView.delegate  = self as! FileDragDelegate
        
        toggleButton.isHidden = true
        
        let defaults = UserDefaults.standard
        if let filesListFromUserDefaults = defaults.array(forKey: "filesPath2"){
            var tmpFilePath : [String] = filesListFromUserDefaults as! [String]
            for str in tmpFilePath{
                self.filesList.append(URL(string: str)!)
            }
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear() {
        let defaults = UserDefaults.standard
        var array : [String] = []
        for url in filesList{
            array.append(url.absoluteString)
        }
        defaults.set(array, forKey: "filesPath2")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func infoAbout(url: URL) -> String {
        let fileManager = FileManager.default
        
        do {
            let attributes = try fileManager.attributesOfItem(atPath: url.path)
            var report: [String] = ["\(url.path)", ""]
            
            for (key, value) in attributes {
                // ignore NSFileExtendedAttributes as it is a messy dictionary
                if key.rawValue == "NSFileExtendedAttributes" { continue }
                report.append("\(key.rawValue):\t \(value)")
            }
            return report.joined(separator: "\n")
        } catch {
            return "No information available for \(url.path)"
        }
    }
    
    func formatInfoText(_ text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle.default().mutableCopy() as? NSMutableParagraphStyle
        paragraphStyle?.minimumLineHeight = 24
        paragraphStyle?.alignment = .left
        paragraphStyle?.tabStops = [ NSTextTab(type: .leftTabStopType, location: 240) ]
        
        let textAttributes: [String: Any] = [
            NSFontAttributeName: NSFont.systemFont(ofSize: 14),
            NSParagraphStyleAttributeName: paragraphStyle ?? NSParagraphStyle.default()
        ]
        
        let formattedText = NSAttributedString(string: text, attributes: textAttributes)
        return formattedText
    }
}



extension ViewController: NSTableViewDelegate,NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filesList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let item = filesList[row]
        
        
        let fileIcon = NSWorkspace.shared().icon(forFile: item.path)
        
        
        if let cell = tableView.make(withIdentifier: "FileCell", owner: nil)
            as? fileCellView {
            
            cell.myFileNameText?.stringValue = item.lastPathComponent
            cell.myimageview?.image = fileIcon
            return cell
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableview.selectedRow < 0 {
            selectedItem = nil
            return
        }
        
        selectedItem = filesList[tableview.selectedRow]
        
        fileName.stringValue = (selectedItem?.lastPathComponent)!
        
        toggleButton.isHidden = false
        
        if(fileName.stringValue.hasPrefix(".")){
            toggleButton.selectedSegment = 1
        }else{
            toggleButton.selectedSegment = 0
        }
    }
    
    
}

extension ViewController: FileDragDelegate {
    func didFinishDrag(_ filePath:String) {
        let url = NSURL(fileURLWithPath: filePath)
        
        filesList.append(url as URL)
        print(url)
        tableview.reloadData()
        
    }
}

