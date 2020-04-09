//
//  Model.swift
//  CurrencyRates-iOS13
//
//  Created by Dennis Nesanoff on 09.04.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import UIKit

class Currency {
    var NumCode: String?
    var CharCode: String?
    var Nominal: String?
    var nominalDouble: Double?
    
    var Name: String?
    
    var Value: String?
    var valueDouble: Double?
}

class Model: NSObject {
    internal init(currensies: [Currency] = [Currency]()) {
        self.currensies = currensies
    }
    
    static let shared = Model()
    var currensies = [Currency]()
    
    var pathForXML: String {
        return ""
    }
    
    var urlForXML: URL? {
        return nil
    }
    
    // download XML from cbr.ru and saved
    func loadXMLfile(date: Date) {
        
    }
    
    func parseXML() {
        
    }
}
