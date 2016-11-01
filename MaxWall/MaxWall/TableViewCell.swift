//
//  TableViewCell.swift
//  MaxWall
//
//  Created by HeHe on 16/5/30.
//  Copyright © 2016年 HeHe. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var programImage: UIImageView!
    @IBOutlet weak var programName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
