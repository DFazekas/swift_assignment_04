//
//  MyDataTableViewCell.swift
//  Assignment_04
//
//  Created by Devon on 2018-12-04.
//  Copyright © 2018 PROG31975. All rights reserved.
//

import UIKit

class MyDataTableViewCell: UITableViewCell {

    @IBOutlet var myScore : UILabel!
    @IBOutlet var myName : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
