//
//  CurrentWeather.swift
//  EZSky
//
//  Created by Ryan Zander on 5/4/17.
//  Copyright © 2017 Ryan Zander. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _weatherDetails: String!
    var _icon: String!
    var _currentTemp: Double!
    
    
    var cityName: String {
        
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    var weatherType: String {
        
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var weatherDetails: String {
        
        if _weatherDetails == nil {
            _weatherDetails = ""
        }
        return _weatherDetails
    }
    
    var icon: String {
        
        if _icon == nil {
            _icon = ""
        }
        return _icon
    }
    
    var currentTemp: Double {
        
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    
    
    
    func downloadCurrentWeatherData(completed: @escaping DownloadComplete) {
        
        // Download current weather data
        Alamofire.request(WEATHER_URL).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                    
                    if let description = weather[0]["description"] as? String {
                        self._weatherDetails = description.capitalized
                        print(self._weatherDetails)
                    }
                    
                    if let icon = weather[0]["icon"] as? String {
                        self._icon = icon
                        print(self._icon)
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    
                    if let currentTemperature = main["temp"] as? Double {
                        
                        // the API gives temp in kelvins, so we convert to celsius
                        self._currentTemp = round(currentTemperature - 273.15)
                        let tempInt = Int(self._currentTemp)
                        print(tempInt)
                    }
                }
            }
            completed()
        }
    }
}
