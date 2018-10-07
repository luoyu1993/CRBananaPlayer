//
//  CRPlayListViewController.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2018/1/28.
//  Copyright © 2018年 CRMO. All rights reserved.
//

import UIKit

class CRPlayListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mutibleOperationToolBar: UIToolbar!
    static let cellIdentifier = "PlayListCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nodataView: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    
    lazy var playViewController : CRPlayViewController = {
        var vc = self.storyboard?.instantiateViewController(withIdentifier: "CRPlayViewController") as! CRPlayViewController
        vc.playList = playList
        return vc
    }()
    
    let playList = CRPlayList()
    var dataList = Array<CRAudio>()
    
    @IBOutlet weak var editItem: UIBarButtonItem!
    @IBOutlet weak var settingItem: UIBarButtonItem!
    
    /** 全选模式 **/
    var isSelectAll = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CRPlayListCell.self, forCellReuseIdentifier: CRPlayListViewController.cellIdentifier)
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true
        self.title = "播放列表"
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "#f6d977")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataList = playList.list()!
        reloadData()
        super.viewWillAppear(animated)
    }
    
    func reloadData() {
        if dataList.count == 0 {
            nodataView.isHidden = false
            tableView.isHidden = true
            uploadButton.layer.cornerRadius = uploadButton.cr_height / 2
            uploadButton.clipsToBounds = true
            uploadButton.backgroundColor = UIColor.init(hexString: "#3B7CEE")
            uploadButton.tintColor = UIColor.white
        } else {
            nodataView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    // MARK:- TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CRPlayListViewController.cellIdentifier, for: indexPath) as? CRPlayListCell else {
            fatalError("Error")
        }
        
        let audio = dataList[indexPath.row]
        if playList.current() == audio {
            cell.titleLabel?.textColor = UIColor.init(hexString: "#3B7CEE")
        } else {
            cell.titleLabel?.textColor = UIColor.black
        }
        cell.titleLabel?.text = audio.name
        cell.progressLabel?.text = audio.progressText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        } else {
            // 点击非当前播放音频先暂停播放
            let audio = dataList[indexPath.row]
            if playList.current()?.filePath != audio.filePath {
                playViewController.pause()
            }
            _ = playList.setCurrent(index: indexPath.row)
            self.navigationController?.pushViewController(playViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return UITableViewCellEditingStyle.delete
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.deleteCell(indexPathes: [indexPath])
    }
    
    private func deleteCell(indexPathes: [IndexPath]?) {
        guard let _indexPathes = indexPathes else {
            return
        }
        
        var indexes: [Int] = Array()
        for indexPath in _indexPathes {
            indexes.append(indexPath.row)
        }
        
        playList.delete(indexes: indexes)
        dataList.removeAll()
        dataList.append(contentsOf: playList.list()!)
        self.reloadData()
    }
    
    // MARK:- 按钮点击事件
    
    @IBAction func tapEditItem(_ sender: UIBarButtonItem) {
        playViewController.pause()
        isSelectAll = false
        if tableView.isEditing {
            // 编辑模式
            sender.image = UIImage.init(named: "list_edit")
            mutibleOperationToolBar.isHidden = true
        } else {
            // 退出编辑模式
            sender.image = UIImage.init(named: "list_edit_done")
            mutibleOperationToolBar.isHidden = false
        }
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    @IBAction func tapPlaying(_ sender: Any) {
        self.navigationController?.pushViewController(playViewController, animated: true)
    }
    
    @IBAction func tapSettingItem(_ sender: Any) {
        let vc = CRSettingViewController.init()
        self.cw_showDefaultDrawerViewController(vc)
    }
    
    @IBAction func selectAllAction(_ sender: Any) {
        if !tableView.isEditing {
            return
        }
        
        isSelectAll = !isSelectAll
        let totalRows = tableView.numberOfRows(inSection: 0)
        
        for row in 0..<totalRows {
            if isSelectAll {
                tableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.none)
            } else {
                tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
            }
        }
    }
    
    @IBAction func tapUpload(_ sender: Any) {
        let uploadVc = self.storyboard?.instantiateViewController(withIdentifier: "CRUploadViewController")
        self.navigationController?.pushViewController(uploadVc!, animated: true)
    }
    
    @IBAction func mutibleDeleteAction(_ sender: Any) {
        self.deleteCell(indexPathes: tableView.indexPathsForSelectedRows)
//        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
    }
}
