//
//  File.swift
//  Currency Value
//
//  Created by user on 24/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit
class LatestCurrencyDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var rates: LatestRates?
    var converterItems = [ConverterItem]()
    // MARK: - Table view Delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return converterItems.count 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? LatestTableViewCell else {
            return UITableViewCell()
        }
        let country = converterItems[indexPath.row]
//        cell..text = notificationsList[indexPath.row].message
        cell.countryCode.text = country.country
        cell.value.text = country.symbol + " " + country.amount
        print("image ", country.country)
        cell.logo.image = UIImage.init(named: country.country)

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell: LatestTableViewCell = (cell as? LatestTableViewCell)!
//        cell.cardAnimation()
    }
}


struct ConverterItem {
    /**
     *  Attributes here
     */
    var currencyName : String
    var country : String
    var code : String
    var symbol : String
    var amount : String
    var convertedAmount : String
    var convertedList : [ConverterItem]
    var isFreshLoad : Bool
    
    init(currencyName: String, country: String, code: String, symbol: String, amount: String) {
        self.currencyName = currencyName
        self.country = country
        self.code = code
        self.symbol = symbol
        self.amount = amount
        self.convertedAmount = self.amount
        self.isFreshLoad = false
        self.convertedList = []
    }
}
