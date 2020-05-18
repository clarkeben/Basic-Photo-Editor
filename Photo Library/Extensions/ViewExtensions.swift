//
//  ViewExtensions.swift
//  Photo Library
//
//  Created by Ben Clarke on 13/05/2020.
//  Copyright © 2020 Ben Clarke. All rights reserved.
//

import UIKit

//MARK: - ViewController

extension UIViewController {
    
    // Disclosure Indicator for tableview Cells
    func addDiscolsureIndicatorCell() -> UIView {
        let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 50))
        let accessoryViewImage = UIImageView(image: UIImage(named: K.images.chevron))
        accessoryViewImage.center = CGPoint(x: 12, y: 25)
        accessoryViewImage.image = accessoryViewImage.image?.withRenderingMode(.alwaysTemplate)
        accessoryViewImage.tintColor = UIColor(named: K.colours.tintColour)
        accessoryView.addSubview(accessoryViewImage)
        return accessoryView
    }
    
}

//MARK: - UIView

extension UIView {
}


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

//MARK: - UIButton

extension UIButton {
    
    func roundedBtn() {
        self.layer.backgroundColor = UIColor(named: K.colours.tintColour)?.cgColor
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.systemGray2.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.6
        self.layer.masksToBounds = false
        //self.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        //self.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
}

//MARK: - UIImageView

extension UIImageView {
    
    func roundedImg() {
        self.layer.cornerRadius = 10
    }
    
}
