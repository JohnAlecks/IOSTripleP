//
//  ViewController.swift
//  TripleP
//
//  Created by John Whisker on 2/7/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import ALLoadingView
protocol ViewControllerProtocols: class {
    func pinPoint()
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var iSeeButton: UIButton!
    
    @IBAction func zoomInPressed(_ sender: UIButton) {
        zoomLevel += 0.5
        mapView.animate(toZoom: zoomLevel)
    }
   
    @IBAction func zoomOutPressed(_ sender: UIButton) {
        zoomLevel -= 0.5
        mapView.animate(toZoom: zoomLevel)
    }
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var checkInfo: UIButton!
    var zoomLevel: Float = 20.0
    var currentTrackingStatus = true
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D! = nil
    
    let marker = GMSMarker()
    
    @IBAction func Checked(_ sender: UIButton) {
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadButtonStyle()
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        guard Shared.share.fromLogin != nil else {
             ALLoadingView.manager.showLoadingView(ofType: .basic)
            performSegue(withIdentifier: "LoginView", sender: nil)
            ALLoadingView.manager.hideLoadingView()
            return
        }
        
        uploadToServer()
        if getCurrentLocation() {
            LoadMapView()
        }
        
    }
    
    func uploadToServer () {
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




//MARK: Map Section
extension ViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    
    func LoadMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: zoomLevel)
        mapView.camera = camera
        loadPin()
        
        
//        checkInfo.frame.origin.x = 179
//        checkInfo.frame.origin.y = 492
//        checkInfo.frame.size = CGSize.init(width: 125 , height: 56)
//        mapView?.addSubview(checkInfo)
    }
    
    func loadButtonStyle() {
        checkInfo.frame = CGRect(x: 248, y: 492, width: 60, height: 60)
        checkInfo.layer.cornerRadius = 0.5 * checkInfo.bounds.size.width
        checkInfo.clipsToBounds = true
        iSeeButton.clipsToBounds = true
        iSeeButton.layer.cornerRadius = 20
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popUp" {
            let isee = segue.destination as! ISeeViewController
            isee.delegate = self
        }
    }
    func loadPin(){
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Current Location"
//        marker.map = mapView
//        marker.icon = #imageLiteral(resourceName: "ArrowMarker")
//        marker.isFlat = true
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
extension ViewController: ViewControllerProtocols {
    func pinPoint() {
        print("you nailed it")
        let policeMarker = GMSMarker()
        policeMarker.appearAnimation = kGMSMarkerAnimationPop
        policeMarker.position = currentLocation
        policeMarker.title = "Police"
        policeMarker.map = mapView
    }
}
