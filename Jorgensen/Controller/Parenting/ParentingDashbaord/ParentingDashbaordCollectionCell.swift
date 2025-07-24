//
//  ParentingDashbaordCollectionCell.swift
//  Jorgensen
//
//  Created by Apple on 04/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ParentingDashbaordCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgTitle:UIImageView!
    
    @IBOutlet weak var viewCellBG:UIView! {
        didSet {
            viewCellBG.layer.cornerRadius = 6
            viewCellBG.clipsToBounds = true
        }
    }
    
}
