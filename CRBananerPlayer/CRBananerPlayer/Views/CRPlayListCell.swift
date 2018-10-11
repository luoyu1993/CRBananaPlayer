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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let titleX = self.isEditing ? 8 : 20 as CGFloat
        titleLabel?.frame = CGRect.init(x: titleX, y: 8, width: self.contentView.cr_width - 50 - 10 - titleX, height: self.contentView.cr_height)
        
        let progressLabelX = self.titleLabel!.frame.maxX
        progressLabel?.frame = CGRect.init(x: progressLabelX, y: 8, width: 50, height: self.contentView.cr_height)
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
        UIView.animate(withDuration: 0.3) {
            if editing {
                self.titleLabel?.cr_x = 8
            } else {
                self.titleLabel?.cr_x = 20
            }
        }
        super.setEditing(editing, animated: animated)
    }
}
