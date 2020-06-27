//
//  ViewController.swift
//  Currency Value
//
//  Created by user on 24/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
var converterItems = [ConverterItem]()
class LatestCurrencyViewController: UIViewController {
    var rates: LatestApiModel?
    @IBOutlet weak var primaryCountryLabel: UILabel!
    @IBOutlet var latestDataSource: LatestCurrencyDataSource!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    var appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        if appDelegate?.isInternetAvailable() == false {
            print("Internet available ==> ")
            self.showAlertWithTitle(title: "Oops!", message: "Please check your network connection")
        } else {
            callApi()
        }
    }
    func callApi() {
        LatestModel.fetchLatestCurrencies { (response) in
            self.rates = response
            self.handleDatas()
        }
    }
    func handleDatas() {
        primaryCountryLabel.text = "1 Eur equal to"
        dateLabel.text = rates?.date! 
        let path = Bundle.main.path(forResource: "CountryData", ofType: "plist")
        let data = try! Data(contentsOf: URL.init(fileURLWithPath: path!))
        let listArray = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! NSArray
        
        for rate in (rates?.rates?.months)! {
            let filteredCountryData = listArray.filtered(using: NSPredicate(format : "code = %@", rate.countryCode!))
            for filteredCountryDataObject in filteredCountryData {
                let object = filteredCountryDataObject as? [String:Any]
                let converterItem = ConverterItem(currencyName: object!["name"] as! String,
                                                  country: object!["country"] as! String,
                                                  code: rate.countryCode!,
                                                  symbol: object!["symbol"] as! String,
                                                  amount: "\(String(describing: rate.money ?? 0))")
                converterItems.append(converterItem)
            }
        }
        self.configureTableView()
    }
    func configureTableView() {
        latestDataSource.rates = self.rates?.rates
        latestDataSource.converterItems = converterItems
        tableView.reloadData()
    }
}
