//
//  HintsTableViewCell.swift
//  Currency Value
//
//  Created by Sowrirajan S on 27/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class HintsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
