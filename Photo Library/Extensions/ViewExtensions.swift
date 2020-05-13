//
//  ViewExtensions.swift
//  Photo Library
//
//  Created by Ben Clarke on 13/05/2020.
//  Copyright © 2020 Ben Clarke. All rights reserved.
//

import UIKit

//MARK: - UItableViewExtension

extension UITableView {
    
}


//MARK: - UITableViewCell

extension UITableViewCell {
    
    func dropImgShadow() {
        self.layer.cornerRadius  = 8
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
}
