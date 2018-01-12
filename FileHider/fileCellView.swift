//
//  fileCellView.swift
//  FileHider
//
//  Created by Chih-Hao on 2018/1/12.
//  Copyright © 2018年 Chih-Hao. All rights reserved.
//

import Cocoa

class fileCellView: NSTableCellView {

    @IBOutlet weak var myimageview: NSImageView!
    
    @IBOutlet weak var myFileNameText: NSTextField!
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
