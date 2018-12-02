//
//  CountryDetailTableViewCell.swift
//  Countries
//
//  Created by Apple on 29/11/18.
//  Copyright © 2018 Dony. All rights reserved.
//

import UIKit

class CountryDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    var countryObject: CountryDataModel? {
        didSet {
            countryFlagImageView.imageFromServerURL(countryObject?.flag, placeHolder: nil)
            countryNameLabel.text = countryObject?.name
        }
    }
    
    var offlineCountry: CountryData? {
        didSet {
            countryFlagImageView.imageFromServerURL(offlineCountry?.flag, placeHolder: nil)
            countryNameLabel.text = offlineCountry?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
