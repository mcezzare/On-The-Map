//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 16/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation
import UIKit

class TableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK : Access the debug on delegate property, used to debug the App and see requests and responses
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarted), name: .reloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
        
        reloadCompleted()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
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
        
        openWithSafari(studentInfo.mediaURL) // this is not working
        //if when back from browser the item should be not selected anymore
        //tableView.deselectRow(at: indexPath, animated: true)
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
    

}

