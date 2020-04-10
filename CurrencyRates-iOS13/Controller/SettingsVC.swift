//
//  SettingsVC.swift
//  CurrencyRates-iOS13
//
//  Created by Dennis Nesanoff on 10.04.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var showButton: UIButton!
    
    @IBAction func canselAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func showCurrencyForTheDate(_ sender: UIButton) {
        Model.shared.loadXMLfile(date: datePicker.date)
        dismiss(animated: true)
    }
}
