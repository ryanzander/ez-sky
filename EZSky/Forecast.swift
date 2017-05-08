//
//  Forecast.swift
//  EZSky
//
//  Created by Ryan Zander on 4/6/17.
//  Copyright © 2017 Ryan Zander. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    
    private var _day: String!
    private var _weatherType: String!
    private var _highTemp: Double!
    private var _lowTemp: Double!
    private var _icon: String!
    
    
    var day: String {
        if _day == nil {
            _day = ""
        }
        return _day
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: Double {
        if _highTemp == nil {
            _highTemp = 0.0
        }
        return _highTemp
    }
    
    var lowTemp: Double {
        if _lowTemp == nil {
            _lowTemp = 0.0
        }
        return _lowTemp
    }
    
    var icon: String {
        if _icon == nil {
            _icon = ""
        }
        return _icon
    }
    
    init(weatherDict: Dictionary<String, AnyObject>){
        
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
            
            if let min = temp["min"] as? Double {
                // temp data is in kelvins, so we subtract to get degrees Celsius
                self._lowTemp = round(min - 273.15)
            }
            
            if let max = temp["max"] as? Double {
                self._highTemp = round(max - 273.15)
            }
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            
            if let details = weather[0]["description"] as? String {
                
                self._weatherType = details.capitalized
            }
            
            if let icon = weather[0]["icon"] as? String {
                
                self._icon = icon
            }
        }
        
        if let dt = weatherDict["dt"] as? Double {
            
            let date = Date(timeIntervalSince1970: dt)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            self._day = date.dayOfWeek()
            
        }
    }

}


extension Date {
    // returns day of week from a Date, ex. "Monday"
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}






