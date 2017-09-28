//
//  CityParse.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 18/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

struct CitySingleData {
    var city: String
    var zipCode: String
}

open class CityParser: NSObject {
    var parser: XMLParser
    var currentProvince: String = ""
    var currentCity: String = ""
    var currentZipCode: String = ""
    var addCity: Bool = false
    var dataArray = [String: [CitySingleData]]()
    var subDataArray = [CitySingleData]()

    init(url: URL) {
        parser = XMLParser(contentsOf: url)!
        super.init()
        parser.delegate = self
    }

    func parseXML() -> [String: [CitySingleData]] {
        parser.parse()
        return dataArray
    }
    
    
     open class func searchNameByID(_ inputID: String, _ returnClosure: @escaping (_ name: String? ) -> Void) {
        
        fetchCityData { (array) in
            if let array = array {
                for data in array {
                    for singleData: CitySingleData in data.value {
                        if singleData.zipCode == inputID {
                            returnClosure(singleData.city)
                        }
                    }
                }
            }
            else {
                returnClosure(nil)
            }
            
        }
        
    }
    
}

extension CityParser: XMLParserDelegate {
   open func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        switch elementName {
        case "province":
            if let name = attributeDict["name"] {
                currentProvince = name
            }
        case "city":
            if let name = attributeDict["name"] {
                currentCity = name
                addCity = true
            }
        case "district":
            if addCity || !currentZipCode.isEmpty {
                if let zipCode = attributeDict["zipcode"] {
                    currentZipCode = zipCode
                }
            }

        default:
            break
        }
    }

   open func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?) {
        switch elementName {
        case "province":
            dataArray[currentProvince] = Array(subDataArray)
            subDataArray.removeAll()
            currentProvince = ""
            currentZipCode = ""
        case "city":
            let data = CitySingleData(city: currentCity, zipCode: currentZipCode)
            subDataArray.append(data)
            currentCity = ""
            addCity = false
        default:
            break
        }
    }
}

func fetchCityData(_ dataClosure: @escaping (_ data: [String: [CitySingleData]]?) -> Void) {
    DispatchQueue.global().async {
        var retData: [String: [CitySingleData]]?
        if let url = Bundle.main.url(forResource: "china_city_data", withExtension: "xml") {
            let parse = CityParser(url: url)
            retData = parse.parseXML()
        }

        DispatchQueue.main.sync {
            dataClosure(retData)
        }
    }
}
