//
//  Constants.swift
//  EZSky
//
//  Created by Ryan Zander on 5/4/17.
//  Copyright © 2017 Ryan Zander. All rights reserved.
//

import Foundation


let BASE_URL = "http://api.openweathermap.org/data/2.5/"
let LAT = "lat="
let LON = "&lon="
let APP_ID = "&appid="
let API_KEY = "e853861efe7b26eed77d7cc7d36ba1d8"

let WEATHER_URL = "\(BASE_URL)weather?\(LAT)\(Location.sharedInstance.latitude!)\(LON)\(Location.sharedInstance.longitude!)\(APP_ID)\(API_KEY)"

let FORECAST_URL = "\(BASE_URL)forecast/daily?\(LAT)\(Location.sharedInstance.latitude!)\(LON)\(Location.sharedInstance.longitude!)\(APP_ID)\(API_KEY)"


typealias DownloadComplete = () -> ()
