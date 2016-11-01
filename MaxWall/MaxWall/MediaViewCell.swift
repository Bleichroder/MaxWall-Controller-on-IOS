//
//  MediaViewCell.swift
//  MaxWall
//
//  Created by HeHe on 16/6/1.
//  Copyright © 2016年 HeHe. All rights reserved.
//

import UIKit

class MediaViewCell: UITableViewCell {

    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var mediaName: UILabel!
    @IBOutlet weak var durantionTime: UILabel!
    @IBOutlet weak var mediaSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
