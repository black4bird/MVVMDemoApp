//
//  AppData.swift
//  ConsumeREST
//
//  Created by LNKN on 03/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import CoreLocation
class AppData: NSObject,CLLocationManagerDelegate{
    static let sharedInstance = AppData()

    let def = NSUserDefaults()
    let locationManager = CLLocationManager()

    let user_key = "CURRENT_USER"
    let user_lat = "CURRENT_LAT"
    let user_lon = "CURRENT_LON"
    let user_city = "CURRENT_CITY"
//    let default_lat = 60.1708
//    let default_lon = 24.9375
    let default_lat = 47.4925
    let default_lon = 19.0514
    
    private override init(){
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.startUpdatingLocation()
        if (CLLocationManager.authorizationStatus() != .Denied){
        }
        else{
            //Helsinki lat and lon
            def.setObject(default_lat, forKey: user_lat)
            def.setObject(default_lon, forKey: user_lon)
            def.setObject("Budapest", forKey: user_city)
        }
    }
    
    func setUserId(id: Int){
        def.setObject(id, forKey: user_key)
    }
    
    func getUserId()->Int{
    
        return def.objectForKey(user_key) as! Int
    }
    
    func getUserLat()->Double{
        return def.objectForKey(user_lat) as! Double
    }
    
    func getUserLon()->Double{
        return def.objectForKey(user_lon) as! Double
    }
    
    func getUserCity()->String{
        return def.objectForKey(user_city) as! String
    }
    
    //Delegate 
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations.first)
        
        let lat = Double((locationManager.location?.coordinate.latitude)!)
        let lon = Double((locationManager.location?.coordinate.longitude)!)
        def.setObject(lat, forKey: user_lat)
        def.setObject(lon, forKey: user_lon)
        print("lat: \(lat) , lon:\(lon)")
        //            let location = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!,
        //                longitude: (locationManager.location?.coordinate.longitude)!)
        //            def.setObject(default_lat, forKey: user_lat)
        //            def.setObject(default_lon, forKey: user_lon)
        let location = CLLocation(latitude: default_lat, longitude: default_lon)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, err) -> Void in
            if((err) != nil){
                print(err)
                self.def.setObject("undefined", forKey: self.user_city)
            }
            else{
                let pm = placemarks![0] as CLPlacemark
                let city = pm.locality
                self.def.setObject(city, forKey: self.user_city)
            }
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    @objc func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
}