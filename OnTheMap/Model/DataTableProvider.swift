//
//  DataTableProvider.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 26/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation
import UIKit

protocol LocationSelectionDelegate: class {
    func didSelectLocation(info: StudentInformation)
}

class DataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: LocationSelectionDelegate?
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsLocation.shared.studentsInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as! LocationCell
        cell.configWith(StudentsLocation.shared.studentsInformation[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectLocation(info: StudentsLocation.shared.studentsInformation[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
