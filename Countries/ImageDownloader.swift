//
//  ImageDownloader.swift
//  Countries
//
//  Created by Apple on 29/11/18.
//  Copyright © 2018 Dony. All rights reserved.
//

import Foundation
import UIKit


let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func imageFromServerURL(_ URLString: String?, placeHolder: UIImage?) {
        self.image = nil
        guard let imageString = URLString else {
            return
        }
        if let cachedImage = imageCache.object(forKey: NSString(string: imageString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: imageString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: imageString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
