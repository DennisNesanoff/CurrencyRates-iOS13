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
    
    class func rouble() -> Currency {
        let rub = Currency()
        rub.CharCode = "RUR"
        rub.Name = "Российский рубль"
        rub.Nominal = "1"
        rub.nominalDouble = 1
        rub.Value = "1"
        rub.valueDouble = 1
        
        return rub
    }
}

class Model: NSObject, XMLParserDelegate {
    static let shared = Model()
    var currensies = [Currency]()
    var currentDate = String()
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory,
                                                   FileManager.SearchPathDomainMask.userDomainMask,
                                                   true)[0]+"/XML_daily.asp.xml"
    var fromCurrency = Currency.rouble()
    var toCurrency = Currency.rouble()
    
    func convert(amount: Double?) -> String {
        if amount == nil {
            return ""
        }
        
        let d = ((fromCurrency.nominalDouble! * fromCurrency.valueDouble!) / (toCurrency.nominalDouble! * toCurrency.valueDouble!)) * amount!
        
        return String(d)
    }
    
    var pathForXML: String {
        if FileManager.default.fileExists(atPath: path) {
            return path
        } else {
            return Bundle.main.path(forResource: "XML_daily.asp", ofType: "xml")!
        }
    }
    
    var urlForXML: URL? {
        return URL(fileURLWithPath: pathForXML)
    }
    
    // MARK: - Download XML from cbr.ru and saved
    func loadXMLfile(date: Date?) {
        var urlString = "https://www.cbr.ru/scripts/XML_daily.asp?date_req="
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            urlString += dateFormatter.string(from: date!)
        }
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
//            var globalError: String?
            guard error == nil else {
//                print(error)
//                globalError = error?.localizedDescription
                return
            }
            let urlForSave = URL(fileURLWithPath: self.path)
            do {
                try data?.write(to: urlForSave)
                self.parseXML()
                print(self.path)
            } catch {
                print(error)
//                globalError = error.localizedDescription
            }
            
//            if let error = globalError {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "errorWhenLoadingXML"), object: self, userInfo: ["ErrorName": globalError])
//            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startLoadingXML"), object: self)
        }.resume()
        
    }
    
    // MARK: - Parse XML
    func parseXML() {
        currensies = [Currency()]
        let parser = XMLParser(contentsOf: urlForXML!)
        parser?.delegate = self
        parser?.parse()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dateRefreshed"), object: self)
        
        for currensy in currensies {
            if currensy.CharCode == fromCurrency.CharCode {
                fromCurrency = currensy
            }
            if currensy.CharCode == toCurrency.CharCode {
                toCurrency = currensy
            }
        }
    }
    
    var currentCurrency: Currency?
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName: String?, attributes attributeDict: [String : String]) {
        if elementName == "ValCurs" {
            if let currentDateString = attributeDict["Date"] {
                currentDate = currentDateString
            }
        }
        if elementName == "Valute" {
            currentCurrency = Currency()
        }
    }
    
    var currentCaracters = ""
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCaracters = string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName: String?) {
        switch elementName {
        case "NumCode":
            currentCurrency?.NumCode = currentCaracters
        case "CharCode":
            currentCurrency?.CharCode = currentCaracters
        case "Nominal":
            currentCurrency?.Nominal = currentCaracters
            currentCurrency?.nominalDouble = Double(currentCaracters.replacingOccurrences(of: ",", with: "."))
        case "Name":
            currentCurrency?.Name = currentCaracters
        case "Value":
            currentCurrency?.Value = currentCaracters
            currentCurrency?.valueDouble = Double(currentCaracters.replacingOccurrences(of: ",", with: "."))
        case "Valute":
            currensies.append(currentCurrency!)
        default:
            return
        }
    }
}
