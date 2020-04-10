//
//  CourcesController.swift
//  CurrencyRates-iOS13
//
//  Created by Dennis Nesanoff on 09.04.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import UIKit

class CourcesController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default
            .addObserver(
                forName: NSNotification.Name(rawValue: "startLoadingXML"),
                object: nil,
                queue: nil) { notification in
                    print(notification)
                    DispatchQueue.main.async {
                        let activityIndicator = UIActivityIndicatorView(style: .medium)
                        activityIndicator.stopAnimating()
                        self.navigationItem.rightBarButtonItem?.customView = activityIndicator
                    }
        }
        
        NotificationCenter.default
            .addObserver(
                forName: NSNotification.Name(rawValue: "dateRefreshed"),
                object: nil,
                queue: nil) { notification in
                    print(notification)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.title = Model.shared.currentDate
                        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.pushRefreshAction(_:)))
                        self.navigationItem.rightBarButtonItem = barButtonItem
                    }
        }
        
//        NotificationCenter.default
//            .addObserver(
//                forName: NSNotification.Name(rawValue: "errorWhenLoadingXML"),
//                object: nil, queue: nil) { notification in
//                    let errorName = notification.userInfo?["ErrorName"]
//                    print(errorName)
//                    DispatchQueue.main.async {
//                        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.pushRefreshAction(_:)))
//                        self.navigationItem.rightBarButtonItem = barButtonItem
//                    }
//        }
        
        title = Model.shared.currentDate
        Model.shared.loadXMLfile(date: nil)
    }
    
    @IBAction func pushRefreshAction(_ sender: UIBarButtonItem) {
        Model.shared.loadXMLfile(date: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.currensies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let courseForCell = Model.shared.currensies[indexPath.row]
        cell.textLabel?.text = courseForCell.CharCode
        cell.detailTextLabel?.text = courseForCell.Value
        
        return cell
    }
}
