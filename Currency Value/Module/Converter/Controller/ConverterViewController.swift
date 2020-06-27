//
//  ConverterViewController.swift
//  Currency Value
//
//  Created by Sowrirajan S on 24/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import DropDown
import Firebase
class ConverterViewController: UIViewController {
    @IBOutlet weak var fromCountryButton: UIButton!
    @IBOutlet weak var toCountryButton: UIButton!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    var isFromButtonClicked = true
    let dropDown = DropDown()
    var currencyArray: [Currencies]?
    var appDelegate = UIApplication.shared.delegate as? AppDelegate

    @IBOutlet weak var fromSymbol: UILabel!
    @IBOutlet weak var fromImage: UIImageView!
    @IBOutlet weak var toImage: UIImageView!
    @IBOutlet weak var toSymbol: UILabel!
    var convertedArray = [ConverterItem]()

    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var dateButton: UILabel!
    //MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("moneyConverterApi").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            BASEURL = snapshot.value as! String
            print("BaseUrl ",BASEURL)
            if BASEURL.count != 0 {
                // The view to which the drop down will appear on
                self.dropDown.anchorView = self.fromCountryButton // UIView or UIBarButtonItem
                self.callApi()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func callApi() {
        ConverterModel.fetchCurrencies { (response) in
            self.currencyArray = response.currencies
            self.handleResponse(response.currencies)
        }
    }
    override func viewDidLayoutSubviews() {
        toImage.dropShadow(color: .black, offSet: CGSize(width: 0, height: 1))
        fromImage.dropShadow(color: .black, offSet: CGSize(width: 1, height: 0))
        convertButton.dropShadow(color: .black, offSet: CGSize(width: 1, height: 0))
    }
    func handleResponse(_ array: [Currencies]) {
        convertedArray = handleDatas()
        var dropDownArray = [String]()
        for item in convertedArray {
            dropDownArray.append(item.country)
        }
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = dropDownArray
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            let country = self.convertedArray[index]
            if self.isFromButtonClicked {
                self.fromImage.image = UIImage.init(named: country.country)
                self.fromSymbol.text = country.symbol
                self.fromCountryButton.setTitle(country.country, for: .normal)
            } else {
                self.toImage.image = UIImage.init(named: country.country)
                self.toSymbol.text = country.symbol
                self.toCountryButton.setTitle(country.country, for: .normal)
            }
        }
    }
    @IBAction func showDropDown(_ sender: UIButton) {
        if sender.tag == 11 {
            isFromButtonClicked = true
        } else {
            isFromButtonClicked = false
        }
        dropDown.show()
    }
    func handleDatas() -> [ConverterItem] {
        let path = Bundle.main.path(forResource: "CountryData", ofType: "plist")
        let data = try! Data(contentsOf: URL.init(fileURLWithPath: path!))
        let listArray = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! NSArray
        
        for rate in currencyArray! {
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
        return converterItems
    }
    @IBAction func convertAction(_ sender: Any) {
        if appDelegate?.isInternetAvailable() == false {
            print("Internet available ==> ")
            self.showAlertWithTitle(title: "Oops!", message: "Please check your network connection")
        }
        if currencyTextField.text?.isEmpty == true {
            self.showAlertWithTitle(title: "Oops!", message: "Please enter your input money")
            return
        }
        let amount = currencyTextField.text!
        var fromCountry = fromCountryButton.titleLabel?.text!
        var toCountry = toCountryButton.titleLabel?.text!
        for item in convertedArray {
            if item.country == fromCountry {
                fromCountry = item.code
            }
            if item.country == toCountry {
                toCountry = item.code
            }
        }
        let path = "\(BASEURL)latest?amount=" + "\(amount)" +
            "&from=\(fromCountry ?? "")" +
            "&to=\(toCountry ?? "")"
        ConverterModel.convertCurrencies(path: path) { (response) in
            let money = "\(String(describing: (response.rates?.currencies[0].money) ?? 0))"
            let symbol = response.rates?.currencies[0].countryCode
            print(money, symbol ?? "")
            DispatchQueue.main.async {
                self.resultLabel.text = money + " " + symbol!
                self.dateButton.text = response.date
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension UIViewController {
    /// Shows alert with no action for ok button
    /// - Parameters:
    ///   - title: Title to show on alert
    ///   - message: Message to show on alert
    ///   - completion: handler function to perform after presenting alert
    func showAlertWithTitle(title: String?, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}
