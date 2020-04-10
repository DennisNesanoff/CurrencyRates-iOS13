//
//  SelectCurrensyTableViewController.swift
//  CurrencyRates-iOS13
//
//  Created by Dennis Nesanoff on 10.04.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import UIKit

enum FlagCurrencySelected {
    case from
    case to
}
class SelectCurrensyTableViewController: UITableViewController {
    @IBOutlet var cancelButton: UIBarButtonItem!
    var flagCurrency = FlagCurrencySelected.from
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tappedCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Model.shared.currensies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentCurrency = Model.shared.currensies[indexPath.row]
        cell.textLabel?.text = currentCurrency.CharCode

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency = Model.shared.currensies[indexPath.row]
        switch flagCurrency {
        case .from:
            Model.shared.fromCurrency = selectedCurrency
        case .to:
            Model.shared.toCurrency = selectedCurrency
        }
        
        dismiss(animated: true)
    }
}
