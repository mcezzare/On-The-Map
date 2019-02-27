//
//  DataTableProvider.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 26/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import UIKit

protocol LocationSelectionDelegate : class {
    func didSelectLocation(info: StudentInformation)
}

class DataTableProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Delegates
    weak var delegate: LocationSelectionDelegate?
    
    // MARK : Access the debug on delegate property
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalStudents = StudentsLocation.shared.studentsInformation.count
        if appDelegate.DEBUG {
            print("DEBUG FROM DATA PROVIDER \(totalStudents)")
        }
        
        return totalStudents
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as! LocationCell
        cell.configWith(StudentsLocation.shared.studentsInformation[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInfo = StudentsLocation.shared.studentsInformation[indexPath.row]
        if appDelegate.DEBUG {
            print("DEBUG: Selecionando cell \(studentInfo)")
            print("DEBUG URL: \(studentInfo.mediaURL)")
        }

        delegate?.didSelectLocation(info: studentInfo) // this is not working
        //tableView.deselectRow(at: indexPath, animated: true)
    }
}
