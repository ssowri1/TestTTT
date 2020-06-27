//
//  LatestApiModel.swift
//  Currency Value
//
//  Created by user on 24/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import ObjectMapper
class LatestApiModel: Mappable {
    var amount: Int?
    var base: String?
    var date: String?
    var rates: LatestRates?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        amount <- map["amount"]
        base <- map["base"]
        date <- map["date"]
        rates <- map["rates"]
    }
}

class LatestRates: Mappable {
    var months: [StatsMonth] = []
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        for (key, value) in map.JSON {
            let month = StatsMonth()
            month.countryCode = key
            month.money = value
            months += [month]
        }
    }
}

class StatsMonth {
    var countryCode: String?
    var money: Any?
}
