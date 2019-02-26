//
//  LocationCell.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 17/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    static let identifier = "LocationCell"
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelUrl: UILabel!
    
    // MARK: Configure cell with basic information about Student Location
    func configWith(_ info: StudentInformation) {
        labelName.text = info.labelName
        labelUrl.text = info.mediaURL
    }
    
}
