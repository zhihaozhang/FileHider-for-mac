//
//  DragDestinationView.swift
//  FileHider
//
//  Created by Chih-Hao on 2018/1/22.
//  Copyright © 2018年 Chih-Hao. All rights reserved.
//

import Cocoa

protocol FileDragDelegate : class{
   
    func didFinishDrag(_ filePath:String)
    
}

class DragDestinationView: NSView {

    weak var delegate: FileDragDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let sourceDragMask = sender.draggingSourceOperationMask()
        let pboard = sender.draggingPasteboard()
        let dragTypes = pboard.types! as NSArray
        if dragTypes.contains(NSFilenamesPboardType) {
            if sourceDragMask.contains([.link]) {
                return .link
            }
            if sourceDragMask.contains([.copy]) {
                return .copy
            }
        }
        return .generic
    }
    
    
    override func performDragOperation(_ sender: NSDraggingInfo?)-> Bool {
        let pboard = sender?.draggingPasteboard()
        let dragTypes = pboard!.types! as NSArray
        if dragTypes.contains(NSFilenamesPboardType) {
            let files = (pboard?.propertyList(forType: NSFilenamesPboardType))! as!  Array<String>
            let numberOfFiles = files.count
            if numberOfFiles > 0 {
                let filePath = files[0] as String
                //代理通知
                if let delegate = self.delegate {
                    NSLog("filePath \(filePath)")
                    delegate.didFinishDrag(filePath)
                }
            }
        }
        return true
    }

  
    
}
