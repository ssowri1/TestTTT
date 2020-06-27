//
//  ConverterApiModel.swift
//  Currency Value
//
//  Created by user on 26/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import ObjectMapper
class ConverterApiModel: Mappable {
    var currencies: [Currencies] = []
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        for (key, value) in map.JSON {
            let currency = Currencies()
            currency.countryCode = key
            currency.money = value
            currencies += [currency]
        }
    }
}

class ConverterResponse: Mappable {
    var amount: Int?
    var base: String?
    var date: String?
    var rates: ConverterReult?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        amount <- map["amount"]
        base <- map["base"]
        date <- map["date"]
        rates <- map["rates"]
    }
}

class ConverterReult: Mappable {
    var currencies: [Currencies] = []
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        for (key, value) in map.JSON {
            let currency = Currencies()
            currency.countryCode = key
            currency.money = value
            currencies += [currency]
        }
    }
}



class Currencies {
    var countryCode: String?
    var money: Any?
}
