//
//  CRSettingViewController.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2018/9/16.
//  Copyright © 2018年 CRMO. All rights reserved.
//

import UIKit

class CRSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableview : UITableView?
    var titles : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hexString: "#f6d977")
        tableview = UITableView.init(frame: CGRect.init(x: 0, y: 200, width: self.view.bounds.width, height: self.view.bounds.height), style: UITableViewStyle.plain)
        tableview?.delegate = self
        tableview?.dataSource = self
        tableview?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableview!)
        titles = ["上传音频", "关于"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CRSettingViewControllerCell"
        var cell = tableview?.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = CRSettingCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        }
        let aCell = cell as! CRSettingCell
        aCell.titleLabel!.text = titles![indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        if row == 0 {
            let uploadVc = storyboard.instantiateViewController(withIdentifier: "CRUploadViewController")
            if let _uploadVc = (uploadVc as? CRUploadViewController) {
                self.cw_push(_uploadVc)
            }
        } else if row == 1 {
            let aboutVc = storyboard.instantiateViewController(withIdentifier: "CRAboutViewController")
            if let _aboutVc = (aboutVc as? CRAboutViewController) {
                self.cw_push(_aboutVc)
            }
        }
    }
}
