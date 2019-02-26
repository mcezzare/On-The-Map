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
    
    // Required by protocol, not working Yet
    func didSelectLocation(info: StudentInformation) {
        print("DEBUG: Calling safari")
        self.openWithSafari(info.mediaURL)
    }
    
}

