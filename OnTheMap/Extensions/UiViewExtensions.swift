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

// MARK: concentrate all Notifications of the app
extension Notification.Name {
    static let reload = Notification.Name("reload")
    static let reloadStarted = Notification.Name("reloadStarted")
    static let reloadCompleted = Notification.Name("reloadCompleted")
}
