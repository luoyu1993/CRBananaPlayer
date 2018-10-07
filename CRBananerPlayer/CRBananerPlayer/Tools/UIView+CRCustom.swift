//
//  UIView+CRCustom.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2018/9/16.
//  Copyright © 2018年 CRMO. All rights reserved.
//

import Foundation

extension UIView {
    var cr_width : CGFloat {
        get {
            return self.bounds.width
        }
        
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    var cr_height : CGFloat {
        get {
            return self.bounds.height
        }
        
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    var cr_x : CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set (newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
    }
    
    var cr_y : CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set (newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame
        }
    }
}
