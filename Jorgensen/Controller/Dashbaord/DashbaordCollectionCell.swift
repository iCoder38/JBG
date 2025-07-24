//
//  DashbaordCollectionCell.swift
//  Jorgensen
//
//  Created by Apple on 03/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class DashbaordCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var viewCellBG:UIView! {
        didSet {
            viewCellBG.layer.cornerRadius = 6
            viewCellBG.clipsToBounds = true
        }
    }

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgItem : UIImageView!
    
}
