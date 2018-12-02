//
//  ApiHelper.swift
//  Countries
//
//  Created by Apple on 29/11/18.
//  Copyright © 2018 Dony. All rights reserved.
//

import Foundation
import SystemConfiguration

class ApiHelper {
    
    // Reguest Get API
    class func requestGetApi(apiString: String, success:@escaping ([CountryDataModel]?) -> Void, failure:@escaping (String) -> Void) {
        let urlwithPercentEscapes = apiString.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let urlString = urlwithPercentEscapes, let url = URL(string: urlString) else {
            failure("error")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil, let error = error {
                failure(error.localizedDescription)
            }
            guard let data = data else { return }
            let object = try? JSONDecoder().decode([CountryDataModel].self, from: data)
            success(object)
            }.resume()
    }
    
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
