//
//  CountryModel.swift
//  Countries
//
//  Created by Apple on 29/11/18.
//  Copyright © 2018 Dony. All rights reserved.
//

import Foundation
import RealmSwift

struct CountryDataModel: Codable {
    var name: String?
    var flag: String?
    var capital: String?
    var callingCodes: [String]?
    var region: String?
    var subregion: String?
    var timezones: [String]?
    var currencies: [CurrencyModel]?
    var languages: [LanguageModel]?
}

struct CurrencyModel: Codable {
    var code: String?
    var name: String?
    var symbol: String?
}

struct LanguageModel: Codable {
    var iso639_1: String?
    var iso639_2: String?
    var name: String?
    var nativeName: String?
}

class CountryData: Object {
    @objc dynamic var name = ""
    @objc dynamic var flag = ""
    @objc dynamic var capital = ""
    @objc dynamic var callingCodes = ""
    @objc dynamic var region = ""
    @objc dynamic var subregion = ""
    @objc dynamic var timezones = ""
    @objc dynamic var currencies = ""
    @objc dynamic var languages = ""
    @objc dynamic var imageData = ""
}



