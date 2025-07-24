//
//  AgingDashboardTableCell.swift
//  Jorgensen
//
//  Created by Apple on 04/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AgingDashboardTableCell: UITableViewCell {

    @IBOutlet weak var viewbg:UIView! {
        didSet {
            viewbg.layer.cornerRadius = 6
            viewbg.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgImage:UIImageView!
    
    @IBOutlet weak var lblName:UILabel! {
        didSet {
            lblName.backgroundColor = APP_BUTTON_COLOR
            lblName.textColor = .white
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
