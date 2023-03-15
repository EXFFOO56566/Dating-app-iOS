//
//  UserLocationCell.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/15/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class UserLocationCell: UITableViewCell,GMSMapViewDelegate, CLLocationManagerDelegate {
    
    
 @IBOutlet var mapView: GMSMapView!
 @IBOutlet var addressLabel: UILabel!
 @IBOutlet var viewHeight: NSLayoutConstraint!
    
    var addressLat = 0.0
    var addressLng = 0.0
    var locationManager = CLLocationManager()
    let marker = GMSMarker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapView.delegate = self
        self.locationManager.delegate = self
    }
    
    
    func forwardGeoCode (address : String){
        GoogleGeoCodeManager.sharedInstance.geoCode(address: address) { (success, authError, error) in
            if success != nil {
                for i in success!.results{
                    self.addressLat = i.geometry.location.lat
                    self.addressLng = i.geometry.location.lng
                }
                print(self.addressLat,self.addressLng)
                let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude:self.addressLat, longitude:self.addressLng), zoom: 9.0)
                self.mapView.camera = camera
                self.marker.position = CLLocationCoordinate2D(latitude: self.addressLat, longitude: self.addressLng)
                self.marker.title = ""
                self.marker.snippet = ""
                self.marker.map = self.mapView
                self.mapView.isUserInteractionEnabled = false
            }
            else if authError != nil {
                print(authError?.errorMessage)
            }
            else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
