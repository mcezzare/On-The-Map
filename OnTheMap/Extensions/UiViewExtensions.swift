//
//  Extensions.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 12/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: Customize Buttons
    
    func makeRoundedCorners(radius: CGFloat = 4){
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
}
