//
//  Location.swift
//  EZSky
//
//  Created by Ryan Zander on 5/5/17.
//  Copyright © 2017 Ryan Zander. All rights reserved.
//


import CoreLocation

class Location {
    
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
    
}
