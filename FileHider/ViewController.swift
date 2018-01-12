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
    
    
    var filesList : [URL] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func openFile(_ sender: Any) {
        
        let openPanel = NSOpenPanel()
        
        openPanel.message = "Please select file to Hide"
        openPanel.canChooseDirectories = true
    //    openPanel.allowsMultipleSelection = true
        
        openPanel.beginSheetModal(for: view.window!, completionHandler: {(result) in
            if result == NSModalResponseOK{
            //  self.selectedFolder = openPanel.url!
            }
        })
        
    }

}



extension ViewController: NSTableViewDelegate,NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filesList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let item = filesList[row]
        
        let fileIcon = NSWorkspace.shared().icon(forFile: item.path)
        
        if let cell = tableview.make(withIdentifier: "FileCell", owner: nil) as? fileCellView {
            cell.myFileNameText?.stringValue = item.lastPathComponent
            cell.myimageview?.image = fileIcon
            return cell
        }
        
        return nil
    }
    
    
}

