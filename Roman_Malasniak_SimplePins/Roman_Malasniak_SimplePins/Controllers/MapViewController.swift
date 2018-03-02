//
//  MapViewController.swift
//  Roman_Malasniak_SimplePins
//
//  Created by Roman Malasnyak on 2/28/18.
//  Copyright © 2018 Roman Malasnyak. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class MapViewController: UIViewController,CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    
    var locationManager = CLLocationManager()
    
    var annotationsCoordinates = [Annotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        setUpMap()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(printAnnotations))
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        setUpData()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        map.addGestureRecognizer(gestureRecognizer)
        
        let fetchRequest:NSFetchRequest<Annotation> = Annotation.fetchRequest()
        do {
            let annotationsCoordinates = try PersistenceService.context.fetch(fetchRequest)
            self.annotationsCoordinates = annotationsCoordinates
        }
        catch {
            print(error)
        }
        updateAnnotationPins()
        
        print(context)
        
    }
    
    func updateAnnotationPins() {
        for item in annotationsCoordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = item.latitude
            annotation.coordinate.longitude = item.longtitude
            self.map.addAnnotation(annotation)
        }
    }
    
    func loadData() {
        let fetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Annotation")
        do {
            try(context.execute(fetch1))
        }
        catch {
            print(error)
        }
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: map)
        
        let locationCoordinates = self.map.convert(location, toCoordinateFrom: self.map)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locationCoordinates
        
        self.map.removeAnnotation(annotation)
        
        self.map.addAnnotation(annotation)
        
        let pinningAnnotation = Annotation(context: PersistenceService.context)
        pinningAnnotation.latitude = annotation.coordinate.latitude
        pinningAnnotation.longtitude = annotation.coordinate.longitude
        
        PersistenceService.saveContext()
        annotationsCoordinates.append(pinningAnnotation)
        
        print(annotationsCoordinates)
        
    }
    
    func setUpData() {
        let user1 = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        user1.email = "Roman"
        
        let info1 = NSEntityDescription.insertNewObject(forEntityName: "Annotation", into: context) as! Annotation
        info1.latitude = 29.4328
        info1.longtitude = 12.8423
        info1.user = user1
        
        let user2 = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        user2.email = "Vika"
        
        let info2 = NSEntityDescription.insertNewObject(forEntityName: "Annotation", into: context) as! Annotation
        info2.latitude = 28.4328
        info2.longtitude = 11.8423
        info2.user = user2
        
        let user3 = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        user3.email = "Misha"
        
        let info3 = NSEntityDescription.insertNewObject(forEntityName: "Annotation", into: context) as! Annotation
        info3.latitude = 30.4328
        info3.longtitude = 13.8423
        info3.user = user3
        
        do {
            try(context.save())
        }
        catch {
            print(error)
        }
        loadData()
    }
    
    
    @objc func handleLogout() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func setUpMap() {
        map.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        map.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        map.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        map.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    let map: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        return map
    }()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("got your location")
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: (manager.location?.coordinate)!, span: span)
        map.setRegion(region, animated: true)
    }
    
}
