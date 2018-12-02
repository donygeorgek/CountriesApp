//
//  CountryDetailViewController.swift
//  Countries
//
//  Created by Apple on 29/11/18.
//  Copyright © 2018 Dony. All rights reserved.
//

import UIKit
import RealmSwift

class CountryDetailViewController: UIViewController {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var callingCodeLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var subRegionLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var currenciesLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    
    var countryData: CountryDataModel?
    var offlineCountry: CountryData?
    var isOfflineData = false
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isOfflineData == false {
            if let countryName = countryData?.name, realm.objects(CountryData.self).filter("name=%@",countryName).count != 0 {
                saveButton.isHidden = true
            }
            countryFlagImageView.imageFromServerURL(countryData?.flag, placeHolder: nil)
            countryNameLabel.text = countryData?.name
            capitalLabel.text = countryData?.capital
            callingCodeLabel.text = countryData?.callingCodes?.joined(separator: ", ")
            regionLabel.text = countryData?.region
            subRegionLabel.text = countryData?.subregion
            timeZoneLabel.text = countryData?.timezones?.joined(separator: ", ")
            var currencies = [String]()
            if let currienciesArr = countryData?.currencies {
                for cu in currienciesArr {
                    if let name = cu.name {
                        currencies.append(name)
                    }
                }
            }
            currenciesLabel.text = currencies.joined(separator: ", ")
            var languages = [String]()
            if let languagesArr = countryData?.languages {
                for la in languagesArr {
                    if let name = la.name {
                        languages.append(name)
                    }
                }
            }
            languagesLabel.text = languages.joined(separator: ", ")
        } else {
            saveButton.isHidden = true
            countryFlagImageView.imageFromServerURL(offlineCountry?.flag, placeHolder: nil)
            countryNameLabel.text = offlineCountry?.name
            capitalLabel.text = offlineCountry?.capital
            callingCodeLabel.text = offlineCountry?.callingCodes
            regionLabel.text = offlineCountry?.region
            subRegionLabel.text = offlineCountry?.subregion
            timeZoneLabel.text = offlineCountry?.timezones
            currenciesLabel.text = offlineCountry?.currencies
            languagesLabel.text = offlineCountry?.languages
        }
        
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let saveCountry = CountryData()
        saveCountry.name = countryNameLabel.text ?? ""
        saveCountry.flag = countryData?.flag ?? ""
        saveCountry.capital = capitalLabel.text ?? ""
        saveCountry.callingCodes = callingCodeLabel.text ?? ""
        saveCountry.region = regionLabel.text ?? ""
        saveCountry.subregion = subRegionLabel.text ?? ""
        saveCountry.timezones = timeZoneLabel.text ?? ""
        saveCountry.currencies = currenciesLabel.text ?? ""
        saveCountry.languages = languagesLabel.text ?? ""
        saveCountry.imageData = ""
        try! realm.write {
            realm.add(saveCountry)
        }
        let alert = UIAlertController.init(title: "Alert!", message: "Country Saved Successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
}
