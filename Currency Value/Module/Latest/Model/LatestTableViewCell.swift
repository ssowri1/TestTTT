//
//  LatestTableViewCell.swift
//  Currency Value
//
//  Created by user on 24/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class LatestTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var countryCode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
