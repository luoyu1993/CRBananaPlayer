//
//  CRUploadViewController.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2018/9/16.
//  Copyright © 2018年 CRMO. All rights reserved.
//

import UIKit

class CRUploadViewController: UIViewController, GCDWebUploaderDelegate {

    var webUploader: GCDWebUploader?
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var freeSizeLabel: UILabel!
    @IBOutlet weak var totalSizeLabel: UILabel!
    
    // MARK: Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startService()
        updateDiskCapacity()
        UIApplication.shared.isIdleTimerDisabled = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webUploader?.stop()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    // MARK: 服务
    
    fileprivate func startService() {
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        var documnetPath = documentPaths[0]
        documnetPath.append("/audio")
        do {
            try FileManager.default.createDirectory(atPath: documnetPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            
        }
        
        webUploader = GCDWebUploader.init(uploadDirectory: documnetPath)
        webUploader?.delegate = self
        webUploader?.allowHiddenItems = true
        webUploader?.start(withPort: 8888, bonjourName: nil)
        
        tipLabel.backgroundColor = UIColor.init(hexString: "#F2F2F2")
        tipLabel.layer.cornerRadius = 5
        tipLabel.clipsToBounds = true
        
        if let localIP = getLocalIPAddressForCurrentWiFi() {
            tipLabel.text = String.init(format: "http://%@:8888", localIP)
        } else {
            tipLabel.text = "请连接Wi-Fi"
        }
    }
    
    // MARK: 手机容量
    
    func updateDiskCapacity() {
        let freeDiskSize = getFreeDiskSize()
        let totalDiskSize = getTotalDiskSize()
        progress.setProgress((totalDiskSize - freeDiskSize) / totalDiskSize, animated: true)
        freeSizeLabel.text = String(format: "剩余：%.1fG", freeDiskSize)
        totalSizeLabel.text = String(format: "容量：%.1fG", totalDiskSize)
    }
    
    func getFreeDiskSize() -> Float {
        do {
            let info = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            let freeSizeNumber = info[.systemFreeSize] as! NSNumber
            let freeSize = freeSizeNumber.floatValue / 1000.0 / 1000.0 / 1000.0
            return freeSize
        } catch {
            print("getFreeDiskSize fail")
        }
        return 0
    }
    
    func getTotalDiskSize() -> Float {
        do {
            let info = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            let totalSizeNumber = info[.systemSize] as! NSNumber
            let totalSize = totalSizeNumber.floatValue / 1000.0 / 1000.0 / 1000.0
            return totalSize
        } catch {
            print("getTotalDiskSize fail")
        }
        return 0
    }
    
    // MARK: Tool
    
    // 获取当前wifi的IP地址
    func getLocalIPAddressForCurrentWiFi() -> String? {
        var address: String?
        
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
    }
}
