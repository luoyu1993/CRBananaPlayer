//
//  CRFileTool.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2018/1/20.
//  Copyright © 2018年 CRMO. All rights reserved.
//

import UIKit

class CRFileTool: NSObject {
    
    static let audioFolderName = ""
    
    /// 获取文件夹里所有音频文件的路径
    ///
    /// - Returns: 音频文件路径集合
    func audioList() -> [String]? {
        let audioPath = self.audioPath()!
        let files = FileManager.default.subpaths(atPath: audioPath)
        guard let _files = files else {return nil}
        let sortFiles = _files.sorted()
        var mp3Files : [String] = Array()
        for file in sortFiles {
            if isAudioFormat(atpath: file) {
                let fullPath = audioPath + "/" + file
                mp3Files.append(fullPath)
            }
        }
        return mp3Files
    }
    
    func documentPath() -> String! {
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documnetPath = documentPaths[0]
        return documnetPath
    }
    
    /// 获取音频保存目录
    ///
    /// - Returns: 音频文件保存目录
    func audioPath() -> String! {
        let documentPath = self.documentPath()
        let audioPath = documentPath! + CRFileTool.audioFolderName
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: audioPath) {
            let url = URL.init(fileURLWithPath: audioPath)
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("文件夹建立失败")
            }
        }
        return audioPath
    }
    
    func isAudioFormat(atpath path: String) -> Bool {
        let pathCompnents = path.components(separatedBy: ".")
        if pathCompnents.contains("mp3") {
            return true
        }
        return false
    }
}
