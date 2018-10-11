//
//  CRBAudioTool.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2017/10/29.
//  Copyright © 2017年 CRMO. All rights reserved.
//

import UIKit
import AVFoundation

class CRAudioTool: NSObject, AVAudioPlayerDelegate {
    
    var player : AVAudioPlayer? = nil
    var toltalTime : TimeInterval = 0
    var currentTime : TimeInterval = 0
    var timer : Timer? = nil
    var delegate : CRBananerPlayerDelegate?
    
    // MARK:- 单例
    static let defaultAudio = CRAudioTool();
    private override init() {
        super.init()
    }
    
    // MARK:- API
    func openFile(filePath: String) -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [AVAudioSessionCategoryOptions.mixWithOthers, AVAudioSessionCategoryOptions.allowBluetooth, AVAudioSessionCategoryOptions.duckOthers])
        } catch {
            print("Error:\(error)")
        }
        
        
        if let isPlaying = player?.isPlaying {
            if isPlaying {
                player?.stop()
            }
        }
        
        player = nil
        
        do {
            let fileUrl = URL(fileURLWithPath: filePath)
            player = try AVAudioPlayer(contentsOf: fileUrl)
            player?.delegate = self
            if let time = player?.duration {
                toltalTime = time
            }
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    // 播放音频
    func play() {
        timer?.invalidate()
        timer = nil
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            if let time = self.player?.currentTime {
                if self.currentTime == time {
                    return
                }
                
                self.currentTime = time
                self.delegate?.playerProgresDidUpdate(audioTool: self, total: self.toltalTime, current: self.currentTime)
            }
        })
        timer?.fire()
        guard let _player = player else {return}
        _player.play()
    }
    
    // 暂停音频
    func pause() {
        guard let _player = player else {return}
        _player.pause()
        timer?.fireDate = NSDate.distantFuture
    }
    
    // 停止音频
    func stop() {
        guard let _player = player else {return}
        _player.stop()
        timer?.invalidate()
        timer = nil
    }
    
    // 设置进度
    func seekTo(progress : Double) {
        self.pause()
        self.player?.currentTime = progress * toltalTime
        self.play()
    }
    
    // MARK: AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.delegate?.playerDidEnd(audioTool: self, total: self.toltalTime)
    }
}

protocol CRBananerPlayerDelegate {
    // 进度更新
    func playerProgresDidUpdate(audioTool: CRAudioTool, total : TimeInterval, current : TimeInterval)
    // 播放结束
    func playerDidEnd(audioTool: CRAudioTool, total: TimeInterval)
    // 播放开始
    func playerDidStart(audioTool: CRAudioTool)
}
