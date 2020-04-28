//
//  DocumentViewController.swift
//  assign4
//
//  Created by Josh on 4/25/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import UIKit
import MapKit

class CirclesViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    

    @IBOutlet var circleView: CircleView!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func exitView(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func satSwitch(sender: Any){
        if let uiSwitch = sender as? UISegmentedControl {
            if(uiSwitch.selectedSegmentIndex == 0){
                mapView.mapType = .standard
            } else {
                mapView.mapType = .satellite
            }
        }
    }
    
    var circlesDocument: CirclesDocument?
    var locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    
    @objc func doTap(recog: UITapGestureRecognizer) {
        let loc = recog.location(in: view)
        circlesDocument?.container?.circles.append(Circle(c: loc, r: 100))
        circleView.setNeedsDisplay()
        circlesDocument?.updateChangeCount(.done)
    }
    
    @objc func doTapExit(recog: UITapGestureRecognizer) {
        dismiss(animated: true) {
            self.circlesDocument?.close(completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.allowsBackgroundLocationUpdates = true
        if(CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() ==   .authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return ((gestureRecognizer == self.tapRecog) && (otherGestureRecognizer == self.doubleTapRecog))
    }
    
    var tapRecog: UITapGestureRecognizer!
    var doubleTapRecog: UITapGestureRecognizer!
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() ==   .authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        <#code#>
    }
    
    func centerMap(loc: CLLocationCoordinate2D){
        let radius: CLLocationDistance = 300
        let region = MKCoordinateRegion(center: loc, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if lastLocation == nil {
            lastLocation = locations.first
        } else {
            guard let latest = locations.first else { return }
            centerMap(loc: latest.coordinate)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access the document
        circlesDocument?.open(completionHandler: { (success) in
            if !success {
                self.presentWarningWith(title: "Error", message: "Document can't be viewed.") {
                    self.dismiss(animated: true)
                }
            }
        })
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.circlesDocument?.close(completionHandler: nil)
        }
    }
}


extension UIViewController {
    
    // MARK: - Factories
    
    /// Returns an alert controller with the passed title and message.
    func makeAlertWith(title: String, message: String) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    // MARK: - Imperatives
    
    /// Presents a warning alert with the provided title and message.
    func presentWarningWith(title: String, message: String, handler: Optional<() -> ()> = nil) {
        let alert = makeAlertWith(title: title, message: message)
        _ = alert.addActionWith(title: "Ok", style: .default)
        
        present(alert, animated: true, completion: handler)
    }
}

extension UIAlertController {
    
    // MARK: - Imperatives
    
    /// Adds a new alert action to the alert controller.
    func addActionWith(title: String, style: UIAlertAction.Style = .default, handler: Optional<(UIAlertAction) -> Swift.Void> = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        addAction(action)
        
        return action
    }
}
