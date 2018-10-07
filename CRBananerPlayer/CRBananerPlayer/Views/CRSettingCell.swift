//
//  CRSettingCell.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2018/9/16.
//  Copyright © 2018年 CRMO. All rights reserved.
//

import UIKit

class CRSettingCell: UITableViewCell {

    var titleLabel : UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.selectionStyle = UITableViewCellSelectionStyle.none
        titleLabel = UILabel.init(frame: CGRect.init(x: 20, y: 20, width: self.bounds.width - 20, height: self.contentView.cr_height))
        self.contentView.addSubview(titleLabel!)
    }
}
