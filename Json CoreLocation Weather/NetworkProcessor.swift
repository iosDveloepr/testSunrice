//
//  NetworkProcessor.swift
//  Json CoreLocation Weather
//
//  Created by Anton Yermakov on 08.05.18.
//  Copyright © 2018 Yermakov Anton. All rights reserved.
//

import Foundation
import CoreLocation

typealias ErrorHandler = (_ msg: String?) -> Void

class NetworkProcessor{
    
    private init() {}
    static let sharedInstance = NetworkProcessor()
    
     let basePath = "https://api.sunrise-sunset.org/json?"
    
    func dowbloadJson(fromLoaction location: CLLocationCoordinate2D, completion: @escaping (Weather) -> (), errorHandling: ErrorHandler?) {
        
        
        let url = basePath + "lat=\(location.latitude)&lng=\(location.longitude)"
 
        print(url)
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                 errorHandling?(error?.localizedDescription)
            } else {
                errorHandling?(nil)
            }
            
         
            
            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    if let result = json["results"] as? [String : Any] {
                        if let weatherObject = try? Weather(json: result) {
                                   completion(weatherObject)
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    
    
    
} // class
