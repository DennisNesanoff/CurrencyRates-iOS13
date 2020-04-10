//
//  ConverterVC.swift
//  CurrencyRates-iOS13
//
//  Created by Dennis Nesanoff on 09.04.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import UIKit

class ConverterVC: UIViewController {
    @IBOutlet var lableCoursesForDate: UILabel!
    @IBOutlet var buttonFrom: UIButton!
    @IBOutlet var buttonTo: UIButton!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    @IBOutlet var textFrom: UITextField!
    @IBOutlet var textTo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFrom.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshButtons()
        textFromEditingChanged(self)
        lableCoursesForDate.text = "Courses for date: \(Model.shared.currentDate)"
        navigationItem.rightBarButtonItem = nil
    }
    
    func refreshButtons() {
        buttonFrom.setTitle(Model.shared.toCurrency.CharCode, for: .normal)
        buttonTo.setTitle(Model.shared.toCurrency.CharCode, for: .normal)
    }
    
    @IBAction func pushFromAction(_ sender: UIButton) {
        let nc = storyboard?.instantiateViewController(withIdentifier: "SelectedCurrensyNSID") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrensyTableViewController).flagCurrency = .from
        nc.modalPresentationStyle = .fullScreen
        
        present(nc, animated: true)
    }
    
    @IBAction func pushToAction(_ sender: UIButton) {
        let nc = storyboard?.instantiateViewController(withIdentifier: "SelectedCurrensyNSID") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrensyTableViewController).flagCurrency = .to
        nc.modalPresentationStyle = .fullScreen
        
        present(nc, animated: true)
    }
    
    @IBAction func textFromEditingChanged(_ sender: AnyObject) {
        if let amount = Double(textFrom.text!) {
            textTo.text = Model.shared.convert(amount: amount)
        }
    }
    
    @IBAction func pushDoneButton(_ sender: UIBarButtonItem) {
        textFrom.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
}

extension ConverterVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationItem.rightBarButtonItem = doneButton
        return true
    }
}
