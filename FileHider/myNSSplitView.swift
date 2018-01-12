//
//  myNSSplitView.swift
//  FileHider
//
//  Created by Chih-Hao on 2018/1/12.
//  Copyright © 2018年 Chih-Hao. All rights reserved.
//

import Cocoa

class myNSSplitView: NSSplitView {
    
    override var dividerThickness:CGFloat{
        get {return 0.5}
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        
        // Drawing code here.
    }
    
}
