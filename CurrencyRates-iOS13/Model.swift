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

class Model: NSObject, XMLParserDelegate {
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory,
                                                   FileManager.SearchPathDomainMask.userDomainMask,
                                                   true)[0]+"/XML_daily.asp.xml"
    
    static let shared = Model()
    var currensies = [Currency]()
    
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
    
    // download XML from cbr.ru and saved
    func loadXMLfile(date: Date?) {
        var urlString = "https://www.cbr.ru/scripts/XML_daily.asp?date_req="
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            urlString += dateFormatter.string(from: date!)
        }
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else { return }
            let urlForSave = URL(fileURLWithPath: self.path)
            do {
                try data?.write(to: urlForSave)
                print(self.path)
            } catch {
                print(error)
            }
        }.resume()
        
    }
    
    func parseXML() {
        currensies = []
        let parser = XMLParser(contentsOf: urlForXML!)
        parser?.delegate = self
        parser?.parse()
        
        print(currensies)
    }
    
    var currentCurrency: Currency?
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName: String?, attributes: [String : String]) {
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
