//
//  CRPlayList.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2018/2/4.
//  Copyright © 2018年 CRMO. All rights reserved.
//

import UIKit

class CRPlayList: NSObject {
    
    private var playList: [CRAudio]
    private let fileTool: CRFileTool
    private var currentIndex: NSInteger?
    
    override init() {
        playList = Array()
        fileTool = CRFileTool()
        super.init()
    }
  
    // MARK:- API
    
    /// 播放列表
    ///
    /// - Returns: 播放列表
    func list() -> Array<CRAudio>? {
        refreshPlayList()
        return playList
    }
    
    /// 下一首
    ///
    /// - Returns: 下一首
    func next() -> CRAudio? {
        guard let index = currentIndex else {
            return nil
        }
        
        if playList.count == 0 {
            return nil
        }
        
        if index == playList.count - 1 {
            return nil
        }
        
        currentIndex = index + 1
        return playList[currentIndex!]
    }
    
    /// 上一首
    ///
    /// - Returns: 上一首
    func previous() -> CRAudio? {
        guard let index = currentIndex else {
            return nil
        }
        if playList.count == 0 {
            return nil
        }
        if currentIndex == 0 {
            return nil
        }
        currentIndex = index - 1
        return playList[currentIndex!]
    }
    
    /// 当前播放的
    ///
    /// - Returns: 当前播放的
    func current() -> CRAudio? {
        guard let index = currentIndex else {
            return nil
        }
        if playList.count == 0 {
            return nil
        }
        return playList[index]
    }
    
    /// 设置当前播放的
    ///
    /// - Parameter index: 当前播放的index
    /// - Returns: 是否成功
    func setCurrent(index: NSInteger) -> Bool {
        if index < 0 || index >= playList.count {
            return false
        }
        currentIndex = index
        return true
    }
    
    /// 删除指定下标音频
    ///
    /// - Parameter index: 下标
    func delete(indexes: [NSInteger]) {
        for index in indexes {
            let audio = playList[index]
            do {
                try FileManager.default.removeItem(atPath: audio.filePath!)
            } catch {
                print("Error:\(error)")
            }
        }
        self.refreshPlayList()
        currentIndex = 0
    }
    
    func updateProgress(progress: TimeInterval) {
        guard let index = currentIndex else {
            fatalError("index为空")
        }
        let audio = playList[index]
        
        // 已经播放完成的不更新进度
        if let finish = audio.isFinish,
            finish == true {
            return
        }
        
        audio.current = progress
        UserDefaults.standard.set(progress, forKey: audio.name!)
    }
    
    // MARK:- Private
    
    fileprivate func refreshPlayList() {
        if let list = fileTool.audioList() {
            playList.removeAll()
            for path in list {
                let audio = CRAudio(path: path)
                let progress = UserDefaults.standard.object(forKey: audio.name!)
                audio.current = progress as? TimeInterval
                playList.append(audio)
            }
        }
    }
}
