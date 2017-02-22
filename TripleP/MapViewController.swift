//
//  MapViewController.swift
//  TripleP
//
//  Created by John Whisker on 2/20/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import ALLoadingView
import InteractiveSideMenu

protocol ViewControllerProtocols: class {
    func pinPoint()
}


class MapViewController: MenuItemContentViewController, ViewControllerProtocols {
    internal func pinPoint() {
        let pin = GMSMarker.init(position: currentLocation)
        pin.appearAnimation = GMSMarkerAnimation.pop
        pin.map = mapView
    }

    
    // Variables
    
    var didCall = false
    var zoomLevel: Float = 20.0
    var currentTrackingStatus = true
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D! = nil
    let marker = GMSMarker()
    
    // UI elements & functions
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var iSeeButton: UIButton!
    @IBOutlet weak var checkInfo: UIButton!
    
    @IBAction func zoomInPressed(_ sender: Any) {
        zoomLevel += 0.5
        mapView.animate(toZoom: zoomLevel)

        
    }
    
    @IBAction func showMenu(_ sender: Any) {
        showMenu()
    }
    
    @IBAction func zoomOutPressed(_ sender: Any) {
        zoomLevel -= 0.5
        mapView.animate(toZoom: zoomLevel)
    }
  
    @IBAction func Checked(_ sender: Any) {
        if currentTrackingStatus {
            locationManager.stopUpdatingHeading()
            locationManager.stopUpdatingLocation()
            currentTrackingStatus = false
            checkInfo.backgroundColor = .gray
        } else {
            locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
            if zoomLevel != 20 {
                zoomLevel = 20
                mapView.animate(toZoom: zoomLevel)
            }
            currentTrackingStatus = true
            checkInfo.backgroundColor = UIColor(red:0.26, green:0.52, blue:0.96, alpha:1.0)
        }
        

        
    }
    
}

//MARK: Basic Function
extension MapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if getCurrentLocation() {
            LoadMapView()
            loadButtonStyle()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "popUp" {
                let isee = segue.destination as! ISeeViewController
                isee.delegate = self
            }
    }


}

//MARK: Map & Location Section

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    
    func LoadMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: zoomLevel)
        
        mapView.camera = camera
        loadPin()
        
    }
    
    func loadButtonStyle() {
        checkInfo.frame = CGRect(x: 248, y: 492, width: 60, height: 60)
        checkInfo.layer.cornerRadius = 0.5 * checkInfo.bounds.size.width
        checkInfo.clipsToBounds = true
        iSeeButton.clipsToBounds = true
        iSeeButton.layer.cornerRadius = 20
    }
    
    func loadPin(){
        mapView.isMyLocationEnabled = true
    }
    
    func getCurrentLocation() -> Bool {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            currentTrackingStatus = true
        }
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationsArray = locations as NSArray
        let locationObject = locationsArray.lastObject as! CLLocation
        currentLocation = locationObject.coordinate
        marker.position = currentLocation
        mapView?.animate(toLocation: currentLocation)
        if !didCall {
            //retriveDataFromServer()
            didCall = true
        }
        print(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView?.animate(toBearing: newHeading.magneticHeading)
        mapView?.animate(toViewingAngle: 45)
        marker.rotation = newHeading.magneticHeading
        marker.tracksViewChanges = true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        UIView.animate(withDuration: 5.0, animations: { () -> Void in
            self.mapView?.tintColor = .blue
        }, completion: {(finished) in
            // Stop tracking view changes to allow CPU to idle.
            self.marker.tracksViewChanges = false
        })
    }
}

// MARK: Server stuffs
extension MapViewController {
    
    func retriveDataFromServer () {
        
        Alamofire.request("http://api.triplep-backend.10.101.21.143.xip.io/v1/pins?latitude=\(String.init(currentLocation.latitude))&longtitude=\(String.init(currentLocation.longitude))").responseJSON { response in
            if let JSON = response.result.value  {
                let json = JSON as! NSDictionary
                print(json)
            }
        }
    }
    func uploadToServer (isPin: Bool) {
        if isPin {
            
        } else {
            guard Shared.share.fromLogin["type"] as! String == "SignUp" else {
                return
            }
            let parameters: [String: AnyObject] = [
                "user" : [
                    "first_name":Shared.share.fromLogin["first_name"] as AnyObject,
                    "last_name": Shared.share.fromLogin["last_name"] as AnyObject,
                    "phone":Shared.share.fromLogin["phone_number"] as AnyObject,
                    "password": Shared.share.fromLogin["password"] as AnyObject
                    ] as AnyObject
            ]
            print (parameters)
            Alamofire.request("http://api.triplep-backend.10.101.21.133.xip.io/v1/users", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                print(response)
            }
        }
        
    }
    
}
