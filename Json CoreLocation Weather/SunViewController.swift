//
//  WeatherTableViewController.swift
//  Json CoreLocation Weather
//
//  Created by Yermakov Anton on 08.05.18.
//  Copyright © 2018 Yermakov Anton. All rights reserved.
//

import UIKit
import CoreLocation

class SunViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sunRiseLbl: UILabel!
    @IBOutlet weak var sunSetLbl: UILabel!
    
    var locationManager = CLLocationManager()
 

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
     }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        
        NetworkProcessor.sharedInstance.dowbloadJson(fromLoaction: location.coordinate, completion: { (results: Weather?) in
            if let weatherObject = results {
                DispatchQueue.main.async {

                    let sunrice = self.UTCToLocal(date: weatherObject.sunrise, fromFormat: "hh:mm:ss a", toFormat: "hh:mm:ss a")
                    let sunset = self.UTCToLocal(date: weatherObject.sunset, fromFormat: "hh:mm:ss a", toFormat: "hh:mm:ss a")
                    
                    self.sunRiseLbl.text = "Sunrice in your current location: \n\(sunrice)"
                    self.sunSetLbl.text = "Sunset in your current location: \n\(sunset)"
                }
            }
        }, errorHandling:{ (message) in
            if message != nil {
                DispatchQueue.main.async { [weak self] in
                    self?.alertErrorMessage(title: "Some error", message: message!)
                }
            }
        })
        
        locationManager.stopUpdatingLocation()
    }
 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherFromLocation(location: locationString)
        }
    }
    
    
    func updateWeatherFromLocation(location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks: [CLPlacemark]?, error) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    NetworkProcessor.sharedInstance.dowbloadJson(fromLoaction: location.coordinate, completion: { (results: Weather?) in
                        if let weatherObject = results {
                            DispatchQueue.main.async {
             
                                let sunrice = self.UTCToLocal(date: weatherObject.sunrise, fromFormat: "hh:mm:ss a", toFormat: "hh:mm:ss a")
                                let sunset = self.UTCToLocal(date: weatherObject.sunset, fromFormat: "hh:mm:ss a", toFormat: "hh:mm:ss a")
         
                                
                                self.sunRiseLbl.text = "Sunrise in city you searched, according to your local time: \n\(sunrice)"
                                self.sunSetLbl.text = "Sunset in city you searched, according to your local time: \n\(sunset)"
                            }
                           
                         
                        }
                    }, errorHandling:{ (message) in
                        if message != nil {
                            DispatchQueue.main.async { [weak self] in
                                self?.alertErrorMessage(title: "Some error", message: message!)
                            }
                        }
                    })
                }
            } else {
               self.alertErrorMessage(title: "Networking problems", message: "Place find a natworking connection")
            }
        }
    }
    
    
    private func alertErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }

} // class






