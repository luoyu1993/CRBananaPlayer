//
//  CRPlayViewController.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2017/10/31.
//  Copyright © 2017年 CRMO. All rights reserved.
//

import UIKit
import MediaPlayer

enum CRPlayViewState {
    case Stop
    case Play
    case Pause
}

enum CRPlayViewControl {
    case current
    case next
    case previous
}


class CRPlayViewController: UIViewController, CRBananerPlayerDelegate {
    
    var currentAudio : CRAudio?
    var playList : CRPlayList?
    
    // MARK:- 属性
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var progressView: UISlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    var state: CRPlayViewState = .Stop
    let audioTool = CRAudioTool.defaultAudio
    
    // MARK:- Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        audioTool.delegate = self
        progressView.setThumbImage(UIImage.init(named: "player_slider"), for: .normal) 
        progressView.addTarget(self, action: #selector(onSliderTouchDown(sender:)), for: .touchDown)
        progressView.addTarget(self, action: #selector(onProgressChange(sender:)) , for: .touchCancel)
        progressView.addTarget(self, action: #selector(onProgressChange(sender:)) , for: .touchUpOutside)
        progressView.addTarget(self, action: #selector(onProgressChange(sender:)) , for: .touchUpInside)
        self.listenRemoteCommondCenterEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.playAudio(with: .current)
        super.viewWillAppear(animated)
    }
    
    // MARK:- 点击事件
    
    @IBAction func tapPlayButton(_ sender: Any) {
        switch state {
        case .Stop:
            self.playCurrentAudio()
        case .Play:
            self.pause()
        case .Pause:
            self.play()
        }
    }
   
    @IBAction func tapNextButton(_ sender: Any) {
        self.playNextAudio()
    }
    
    @IBAction func tapPreviousButton(_ sender: Any) {
        self.playPreviousAudio()
    }
    
    /// 监听控制中心事件
    func listenRemoteCommondCenterEvents() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.changePlaybackPositionCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            let positionEvent =  event as! MPChangePlaybackPositionCommandEvent
            print("event:\(positionEvent.positionTime)")
            print("totalTime:\(self.audioTool.toltalTime)")
            self.audioTool.seekTo(progress: Double(positionEvent.positionTime / self.audioTool.toltalTime))
            return .success
        }
        
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.play()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.pause()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.playPreviousAudio()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.playNextAudio()
            return .success
        }
    }
    
    // MARK:- 播放控制
    
    func play() {
        audioTool.play()
        playButton?.setImage(UIImage.init(named: "player_pause"), for: .normal)
        state = .Play
    }
    
    func pause() {
        audioTool.pause()
        playButton?.setImage(UIImage.init(named: "player_play"), for: .normal)
        state = .Pause
    }
    
    func playNextAudio() {
        playAudio(with: .next)
    }
    
    func playPreviousAudio() {
        playAudio(with: .previous)
    }
    
    func playCurrentAudio() {
        playAudio(with: .current)
    }
    
    func playAudio(with control: CRPlayViewControl) {
        switch control {
        case .current:
            if currentAudio?.filePath == playList?.current()?.filePath {
                return
            }
            currentAudio = playList!.current()
            break
        case .next:
            currentAudio = playList!.next()
            break
        case .previous:
            currentAudio = playList!.previous()
            break
        }
        
        audioTool.stop()
        
        titleLabel.text = currentAudio?.name
        coverImageView.image = currentAudio?.coverImage()
        
        let path = currentAudio?.filePath
        
        guard let _path = path else {
            let alert = UIAlertController(title: nil, message: "没有更多了", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if audioTool.openFile(filePath: _path) {
            if let playProgress = currentAudio?.progress,
                let finish = currentAudio?.isFinish,
                finish == false {
                audioTool.seekTo(progress: playProgress)
            } else {
                audioTool.play()
            }
            playButton.setImage(UIImage.init(named: "player_pause"), for: .normal)
            progressView.setValue(0.0, animated: true)
        }
        state = .Play
        
        var audioInfo = Dictionary<String, Any>()
        audioInfo.updateValue(currentAudio!.name!, forKey: MPMediaItemPropertyTitle)
        audioInfo.updateValue(NSNumber.init(value: audioTool.toltalTime), forKey: MPMediaItemPropertyPlaybackDuration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = audioInfo
    }
    
    // MARK:- CRBananerPlayerDelegate
    
    func playerProgresDidUpdate(audioTool: CRAudioTool, total: TimeInterval, current: TimeInterval) {
        playButton.setImage(UIImage.init(named: "player_pause"), for: .normal)
        progressView.setValue(Float(current/total), animated: true)
        progressLabel.text = timeString(current)
        durationLabel.text = timeString(total)
        playList?.updateProgress(progress: current)
    }
    
    func playerDidEnd(audioTool: CRAudioTool, total: TimeInterval) {
        playList?.updateProgress(progress: total)
        self.playNextAudio()
    }
    
    func playerDidStart(audioTool: CRAudioTool) {
    }
    
    // MARK:- Slider
    
    @objc func onProgressChange(sender: UISlider) {
        print("停止拖动进度条，更新进度")
        let value = sender.value
        audioTool.seekTo(progress: Double(value))
    }
    
    @objc func onSliderTouchDown(sender: UISlider) {
        print("开始拖动进度条")
        audioTool.pause()
    }
    
    private let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()
    
    func timeString(_ time: TimeInterval) -> String {
        return formatter.string(from: time)!
    }
}
