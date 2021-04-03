//
//  MapViewController.swift
//  Friends
//
//  Created by Gorazd Kunej on 01/04/2021.
//

import UIKit
import Mapbox

class MapViewController: ContainerChildViewController {
    
    var mapView: MGLMapView!
    var annotations = [MGLPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "mapbox://styles/mapbox/streets-v11")
        mapView = MGLMapView(frame: view.frame, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.setCenter(CLLocationCoordinate2D(latitude: 51.40, longitude: 14.06), zoomLevel: 2.5, animated: false)
        view.addSubview(mapView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UsersModel.shared.users.isEmpty {
            UsersModel.shared.getUsers(count: 5) { (result) in
                if case let .success(users) = result {
                    DispatchQueue.main.async {
                        self.addAnotations()
                    }
                    print("Friends users: \(users)")
                }
            }
        } else {
            addAnotations()
        }
    }
    
    func addAnotations(){
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
    
        for item in UsersModel.shared.users {
            if let _ = item.image {
                addAnotation(for: item)
            } else {
                self.downloadImage(for: item)
            }
        }
    }
    
    private func addAnotation(for user: User) {
        guard
            let location = user.location?.coordinates,
            let latitude = location.latitude,
            let longitude = location.longitude,
            let lat = Double(latitude),
            let long = Double(longitude)
        else { return }
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.title = user.login?.username
        annotation.subtitle = user.countryString
        
        annotations.append(annotation)
        
        mapView.addAnnotation(annotation)
    }
}

//MARK: - Delegates and data sources
//MARK: MGLMapViewDelegate
extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return nil //UIButton(type: .infoDark)
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        guard let user = UsersModel.shared.users.first(where: {
            $0.login?.username == annotation.title
        }) else {
            return
        }
        delegate?.openPanel(for: user)
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        guard let user = UsersModel.shared.users.first(where: {
            $0.login?.username == annotation.title
        }) else {
            return nil
        }
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = FriendAnnotationView(reuseIdentifier: reuseIdentifier, user: user)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        var reuseIdentifier = "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
        if let title = annotation.title {
            reuseIdentifier += title!
        }
        if let subtitle = annotation.subtitle {
            reuseIdentifier += subtitle!
        }
        
        guard let user = UsersModel.shared.users.first(where: {
            $0.login?.username == annotation.title
        }) else {
            return nil
        }
    
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifier)
        
        if let userImage = user.image {
            annotationImage = MGLAnnotationImage(image:(userImage.getImage()?.circle)! , reuseIdentifier: reuseIdentifier)
        } else {
            annotationImage = MGLAnnotationImage(image:UIImage(named: "pin")! , reuseIdentifier: reuseIdentifier)
        }
        
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        mapView.deselectAnnotation(annotation, animated: false)
    }
}


extension MapViewController {
    func downloadImage(for item: User) {
        
        guard let imageURL = item.picture?.medium?.url
            else {
                print("Missing image url in user detail.")
                return
        }
        
        UsersModel.shared.getUserImage(with: imageURL) { result in
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.addAnotation(for: item)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
