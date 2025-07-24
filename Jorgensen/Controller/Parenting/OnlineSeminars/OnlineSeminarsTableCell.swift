//
//  OnlineSeminarsTableCell.swift
//  Jorgensen
//
//  Created by Apple on 04/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class OnlineSeminarsTableCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel! {
        didSet {
            lblName.textAlignment = .left
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
