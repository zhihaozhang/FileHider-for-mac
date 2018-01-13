//
//  ViewController.swift
//  FileHider
//
//  Created by Chih-Hao on 2018/1/11.
//  Copyright © 2018年 Chih-Hao. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var tableview: NSTableView!
    @IBOutlet var infoTextView: NSTextView!
    @IBOutlet var fileName: NSTextField!
    
    @IBOutlet var toggleButton: NSSegmentedControl!
    
    @IBOutlet var fileImage: NSImageView!
    
    var filesList : [URL] = []
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
                print(self.filesList)
            }
        }
        
    }
    
    @IBAction func onOffToggle(_ sender: Any) {
        if (sender as AnyObject).selectedSegment == 1{
            print("hide")
        }else{
            print("show")
        }
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

        toggleButton.isHidden = true

        // Do any additional setup after loading the view.
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
    }
    
    
}

