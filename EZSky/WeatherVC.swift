//
//  WeatherVC.swift
//  EZSky
//
//  Created by Ryan Zander on 4/5/17.
//  Copyright © 2017 Ryan Zander. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var weatherIconIV: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    // refresh control allows pull tableview to update UI
    private let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
      
        tableView.delegate = self
        tableView.dataSource = self
        
        // assign refreshControl to the tableView and configure it
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshData(sender:)), for: .valueChanged)
        
        currentWeather = CurrentWeather()
        
        locationManager.requestWhenInUseAuthorization()
        locationAuthStatus()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func locationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            // if authorized, we get the device's location
            currentLocation = locationManager.location
            
            // we assign the lat and long to our Location singleton class to access elsewhere
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadCurrentWeatherData {
                
                self.downloadForecastData {
                    self.updateUI()
                    // if we were updating from a pull-to-refresh, we end refreshing
                    self.refreshControl.endRefreshing()
                }
            }
        }
        
    }
    
    func refreshData(sender: Any) {
    
        // to refresh the data, we call locationAuthStatus function again
        locationAuthStatus()
    }
    
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        
        // Download forecast data
        Alamofire.request(FORECAST_URL).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    // empty the forecasts array before filling it to avoid repeating content when refreshing
                    self.forecasts = [Forecast]()
                    
                    for obj in list {
                        
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        
                        print(obj)
                    }
                    // reload tableView data to display the new forecast data
                    self.tableView.reloadData()
                }
                
            }
            completed()
        }
    }
  

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell {
            
            
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
            
        } else {
            return WeatherCell()
        }
    }
    
    
    func updateUI() {
        
        // updates the main UI for current weather data
        // tableview will get updated right after data for tableview is received
        
        dateLabel.text = currentWeather.date
        let tempInt = Int(currentWeather.currentTemp)
        currentTempLabel.text = "\(tempInt)°"
        weatherTypeLabel.text = currentWeather.weatherDetails
        cityLabel.text = currentWeather.cityName
        let imageName = self.getImageName(currentWeather.icon)
        weatherIconIV.image = UIImage(named: imageName)
    }
    
    
    
    
    func getImageName(_ icon: String) -> String {
        
        // weather api returns icon names, so we match these with our weather images
        
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

