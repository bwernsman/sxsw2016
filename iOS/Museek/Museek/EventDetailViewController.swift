//
//  ShowDetailViewController.swift
//  Museek
//
//  Created by Eric Rincon on 3/15/16.
//  Copyright © 2016 Museek. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController {
    
    var eventIndex:Int = -1
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    @IBOutlet weak var bandNameLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lyftButton: UIButton! {
        didSet {
            lyftButton.setTitleColor(.whiteColor(), forState: .Normal)
            lyftButton.layer.backgroundColor = UIColor(red:0.92, green:0.04, blue:0.55, alpha:1.0).CGColor
            lyftButton.layer.borderColor = UIColor(red:0.92, green:0.04, blue:0.55, alpha:1.0).CGColor
            lyftButton.layer.borderWidth = 1
            lyftButton.layer.cornerRadius = 8
        }
    }
    

    var event: Event? {
        didSet {
            eventNameLabel.text = event?.name.value
            bandNameLabel.text = event?.band.value?.name.value
        }
    }

    //Need to change lat and long
    @IBAction func requestLyft() {
        let application = UIApplication.sharedApplication()
        let lyftAppURL = NSURL(string: "lyft://ridetype?id=&destination[latitude]=\(localData.eventLat[eventIndex])&destination[longitude]=\(localData.eventLong[eventIndex])")!
        
        if application.canOpenURL(lyftAppURL) {
            application.openURL(lyftAppURL)
        } else {
            let lyftAppStoreURL = NSURL(string: "https://itunes.apple.com/us/app/lyft-on-demand-ridesharing/id529379082?mt=8")!
            application.openURL(lyftAppStoreURL)
        }
    }
    
    //Can I do this??
    override func viewDidLoad() {
        print(eventIndex)
        bandNameLabel.text = localData.bandNames[eventIndex]
        eventNameLabel.text = "Location: " + localData.locationNames[eventIndex]
        eventDescriptionLabel.text = localData.eventDescriptions[eventIndex]
        
        locationManager.delegate = self
        handleAuthorizationStatus(CLLocationManager.authorizationStatus())
        
        // Drop a pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(localData.eventLat[eventIndex],localData.eventLong[eventIndex])
        dropPin.title = localData.locationNames[eventIndex]
        mapView.addAnnotation(dropPin)
        
        //Show annotation
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("tapFunction:"))
        eventDescriptionLabel.addGestureRecognizer(tap)
        eventDescriptionLabel.userInteractionEnabled = true
        
        let item = UIBarButtonItem(title: "Donate", style: .Plain, target: self, action: "barButtonItemClicked:")
        self.navigationItem.rightBarButtonItem = item
    }
    
    func barButtonItemClicked(sender:UIButton!){
        self.performSegueWithIdentifier("donateShow", sender: self);
        
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        performSegueWithIdentifier("webView", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "webView" {
            let secondVC: WebViewController = segue.destinationViewController as! WebViewController
            secondVC.websiteURL = localData.websiteName[eventIndex]
            secondVC.name = localData.bandNames[eventIndex]
            secondVC.hidesBottomBarWhenPushed = true
        }
        else if(segue.identifier == "donateShow"){
            let secondVC: paymentViewController = segue.destinationViewController as! paymentViewController
            secondVC.index = eventIndex
            secondVC.hidesBottomBarWhenPushed = true
        }
    }

    
    private func handleAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .Denied, .Restricted:
            fatalError("Location access was denied or restricted.")
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }

}

extension EventDetailViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        handleAuthorizationStatus(status)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //currentLocation = locations.last
        
        let userLocation: CLLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let latDelta: CLLocationDegrees = 0.075
        let longDelta: CLLocationDegrees = 0.075
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
}
