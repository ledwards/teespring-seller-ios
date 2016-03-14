//
//  OrderCell.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 3/13/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
