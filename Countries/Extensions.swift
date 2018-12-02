//
//  Extensions.swift
//  Countries
//
//  Created by Apple on 29/11/18.
//  Copyright © 2018 Dony. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    // Call Alert
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
