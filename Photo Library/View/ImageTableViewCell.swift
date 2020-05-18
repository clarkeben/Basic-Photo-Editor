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
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        formatImg()
    }
    
    func formatImg() {
        cellImg.layer.cornerRadius = 8
        // Further IMG formating
    }
    
}
