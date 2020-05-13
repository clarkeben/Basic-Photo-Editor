//
//  ImageTableViewCell.swift
//  Photo Library
//
//  Created by Ben Clarke on 13/05/2020.
//  Copyright © 2020 Ben Clarke. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        formatImg()
        
        // Fade in images slightly 
        cellImg.alpha = 0
        UIView.animate(withDuration: 1.0) {
            [weak self]  in
            self?.cellImg.alpha = 1.0
        }
    }
    
    func formatImg() {
        cellImg.layer.cornerRadius = 8
    }
    
}
