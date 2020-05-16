//
//  AnimationViewExtensions.swift
//  Photo Library
//
//  Created by Ben Clarke on 13/05/2020.
//  Copyright © 2020 Ben Clarke. All rights reserved.
//

import UIKit

//MARK: - UItableView Extensions

extension UITableView {
    
    func reloadWithBounceAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        
        var delayCounter = 0
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            
            delayCounter += 1
        }
    }
}

extension UITableViewCell {
    
    func fadeInCell() {
        self.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
            self.alpha = 1.0
        }
    }
    
    
}
