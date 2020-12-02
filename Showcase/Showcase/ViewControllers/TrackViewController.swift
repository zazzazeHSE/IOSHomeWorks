//
//  TrackViewController.swift
//  Showcase
//
//  Created by Егор on 01.12.2020.
//

import UIKit
import CoreData

class TrackViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    @IBOutlet weak var locationText: UITextView!
    @IBOutlet weak var toggleSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        locationText.layer.cornerRadius = 5.0
    }
    
    @IBAction func changeToggle(_ sender: Any) {
        if toggleSwitch.isOn{
            if !CLLocationManager.locationServicesEnabled(){
                toggleSwitch.isOn = false
            } else {
                if locationManager == nil{
                    locationManager = CLLocationManager()
                    locationManager.delegate = self
                    locationManager.distanceFilter = 10.0
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.requestWhenInUseAuthorization()
                }
                locationManager.startUpdatingLocation()
            }
        } else {
            if locationManager != nil{
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[locations.count - 1] as CLLocation
        self.locationText.text = location.description
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationText.text = "failed with error: \(error.localizedDescription)"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
