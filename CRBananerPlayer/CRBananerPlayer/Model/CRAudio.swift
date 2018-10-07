//
//  CRAudio.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2018/1/20.
//  Copyright © 2018年 CRMO. All rights reserved.
//

import UIKit
import AVFoundation

class CRAudio: NSObject {
    var name: String?
    var filePath: String?
    var fileSize: String?
    var author: String?
    var album: String?
    var current: TimeInterval?
    var duration: TimeInterval?
    var fromApp: String?
    var like: Bool = false
    
    var progressText: String? {
        guard let finish = self.isFinish() else {
            return nil
        }
        if finish {
            return "已播完"
        } else {
            let aProgress = Int((current! / duration!) * 100)
            if aProgress == 0 {
                return nil
            } else {
                return "已听\(aProgress)%"
            }
        }
    }
    
    var progress: Double? {
        guard let _current = current, let _duration = duration else {
            return nil
        }
        return _current / _duration
    }

    init(path: String) {
        super.init()
        self.filePath = path
        self.name = self.fileName(ofPath: path)
        let fileURL = URL.init(fileURLWithPath: path)
        let asset = AVURLAsset.init(url: fileURL)
        self.duration = CMTimeGetSeconds(asset.duration)
    }
    
    func fileName(ofPath path: String) -> String? {
        let components = path.components(separatedBy: "/")
        let title = components.last
        return title
    }
    
    func isFinish() -> Bool? {
        guard let _current = current, let _duration = duration else {
            return nil
        }
        if Double(round(100*_current)/100) == Double(round(100*_duration)/100) {
            return true
        } else {
            let aProgress = Int((current! / duration!) * 100)
            return false
        }
    }
    
    func coverImage() -> UIImage? {
        guard let path = self.filePath else {
            return nil
        }
        let fileURL = URL.init(fileURLWithPath: path)
        let asset = AVURLAsset.init(url: fileURL)
        var data : Data?
        for format in asset.availableMetadataFormats {
            for meta in asset.metadata(forFormat: format) {
                if meta.commonKey == .commonKeyArtwork {
                    data = meta.dataValue
                }
            }
        }
        
        guard let _data = data else {
            return UIImage.init(named: "player_default_cover")
        }
        
        return UIImage.init(data: _data)
    }
}

