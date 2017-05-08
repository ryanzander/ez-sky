//
//  WeatherCell.swift
//  EZSky
//
//  Created by Ryan Zander on 4/6/17.
//  Copyright © 2017 Ryan Zander. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var weatherIconIV: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    func configureCell(forecast: Forecast) {
        
        dayLabel.text = forecast.day
        weatherTypeLabel.text = forecast.weatherType
        let highInt = Int(forecast.highTemp)
        let lowInt = Int(forecast.lowTemp)
        highTempLabel.text = "\(highInt)°"
        lowTempLabel.text = "\(lowInt)°"
        
        let imageName = self.getImageName(forecast.icon)
        weatherIconIV.image = UIImage(named: imageName)
        
    }
    
    // we match the set of icon names returned by the api with our weather images
    func getImageName(_ icon: String) -> String {
        
        var imageName = ""
        
        switch icon {
            
        case "03d", "03n", "04d", "04n", "50d", "50n":
            imageName = "Cloudy"
            
        case "01d", "01n":
            imageName = "Sunny"
            
        case "11d", "11n":
            imageName = "Lightning"
            
        case "02d", "02n":
            imageName = "Partially Cloudy"
            
        case "13d", "13n":
            imageName = "Snow"
            
        case "09d", "09n", "10d", "10n":
            imageName = "Rainy"
            
        default:
            imageName = "Partially Cloudy"
        }
        
        return imageName
    }
  

}
