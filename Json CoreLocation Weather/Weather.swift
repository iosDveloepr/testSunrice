//
//  Weather.swift
//  Json CoreLocation Weather
//
//  Created by Yermakov Anton on 08.05.18.
//  Copyright © 2018 Yermakov Anton. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    
    var sunrise : String
    var sunset : String

    
    enum SerializationError : Error {
        case missing(String)
    }
    
    init (json: [String: Any]) throws {
        
        guard let sunrise = json["sunrise"] as? String else { throw SerializationError.missing("The sunrise is missing")}
        guard let sunset = json["sunset"] as? String else { throw SerializationError.missing("The sunset is missing")}
        
        
        self.sunrise = sunrise
        self.sunset = sunset
     
    }
    
    
    
} // class






