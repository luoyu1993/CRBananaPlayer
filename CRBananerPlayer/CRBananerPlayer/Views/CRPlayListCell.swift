//
//  CRPlayListCell.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2018/3/11.
//  Copyright © 2018年 CRMO. All rights reserved.
//

import UIKit

class CRPlayListCell: UITableViewCell {

    var titleLabel : UILabel?
    var progressLabel : UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        titleLabel = UILabel.init(frame: CGRect.init(x: 20, y: 8, width: self.contentView.cr_width - 50, height: self.contentView.cr_height))
        progressLabel = UILabel.init(frame: CGRect.init(x: titleLabel!.frame.maxX, y: 8, width: 50, height: self.contentView.cr_height))
        progressLabel?.textColor = UIColor.lightGray
        progressLabel?.font = UIFont.systemFont(ofSize: 12)
        
        self.contentView.addSubview(titleLabel!)
        self.contentView.addSubview(progressLabel!)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        UIView.animate(withDuration: 0.3) {
            if editing {
                self.titleLabel?.cr_x = 8
                self.progressLabel?.cr_x = self.titleLabel!.frame.maxX
            } else {
                self.titleLabel?.cr_x = 20
                self.progressLabel?.cr_x = self.titleLabel!.frame.maxX + 20
            }
        }
    }
}
