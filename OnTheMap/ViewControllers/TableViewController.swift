//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 16/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation
import UIKit

class TableViewController : UIViewController, LocationSelectionDelegate  {
    
    // MARK: OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataProvider: DataTableProvider!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Delegates
    //    let locationSelectionDelegate = LocationSelectionDelegate()
    
    
    // MARK: Lyfe cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarted), name: .reloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
        
        //        dataProvider.delegate = locationSelectionDelegate
        dataProvider.delegate? = self // IS CRASHING WITH NIL VALUE
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        
        reloadCompleted()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Helpers
    
    @objc func reloadStarted() {
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
        }
    }
    
    @objc func reloadCompleted() {
        performUIUpdatesOnMain {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - LocationSelectionDelegate
    
    func didSelectLocation(info: StudentInformation) {
        openWithSafari(info.mediaURL)
    }

    /*
     // MARK : Delegate Methods
     // MARK : Init data and datasources
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return StudentsLocation.shared.studentsInformation.count
     }
     
     // MARK : Data Table and cell information
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as! LocationCell
     cell.configWith(StudentsLocation.shared.studentsInformation[indexPath.row])
     return cell
     }
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let studentInformation = StudentsLocation.shared.studentsInformation[indexPath.row]
     openWithSafari(studentInformation.mediaURL)
     }
     
     */
    
    
}

