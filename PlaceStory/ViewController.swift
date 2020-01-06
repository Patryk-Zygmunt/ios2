//
//  ViewController.swift
//  PlaceStory
//
//  Created by user163099 on 1/5/20.
//  Copyright © 2020 user163099. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import EzPopup
import Cosmos


class ViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var direction: UILabel!
    @IBOutlet weak var type: UILabel!
    // @IBOutlet weak var rate: CosmosView!
    @IBOutlet weak var imahe: UIImageView!
    @IBOutlet weak var name: UILabel!
    var locationManager = CLLocationManager()
    var  places:[[String:Any]]=[]
    var index:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    locationManager.requestAlwaysAuthorization()
    locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    @IBOutlet weak var nLoc: UILabel!
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.first != nil {
            print(locations.last!.coordinate.latitude)
            print(locations.last!.coordinate.longitude)
            loadPLaces( lat: (String(locations.last!.coordinate.latitude)), lng: (String(locations.last!.coordinate.longitude)))
        }
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
               /// print(placemarks!.description)
                
                self.nLoc.text = placemarks!.last!.locality
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    @IBAction func next(_ sender: Any) {
        index+=1;
        loadPlace()
    }
    
    @IBAction func prev(_ sender: Any) {
        index-=1;
        loadPlace()

    }
    @IBAction func moreInfo(_ sender: Any) {
        showCustomDialog()
    }
    
    fileprivate func loadPLaces(lat:String,lng:String) {
    let url = "http://www.mocky.io/v2/5e1352d3310000a575d47756"
        
        //let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?language=pl&key=AIzaSyB_JnpJt-zK0owgInVIVPw277su2b2slJI&radius=10000&location=\(lat),\(lng)"
  // 1
  Alamofire.request(url,
                    method: .get)
  .validate()
  .responseJSON { response in
    guard response.result.isSuccess else {
      print(  String(describing: response.result.error!))
      return
    }

    let value = response.result.value as? [String: Any]
    let arr = value!["results"] as! [[String: Any]]
    
    self.places = arr.filter {$0["photos"] != nil }
    print(self.places)
    self.loadPlace()
  }
        
    }
        fileprivate func loadPlace() {
            
            let place : [String: Any] = self.places[index]
           // rate.rating = Double(place["rating"] as! Int)
            let photo = (place["photos"] as! [[String: Any]])[0]["photo_reference"] as! String
            self.name.text = place["name"] as! String
            self.direction.text = place["vicinity"] as! String
            let tpes = place["types"] as! [String]
            self.type.text = tpes[0].replacingOccurrences(of: "_", with: " ")


            let url = URL(string:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&photoreference="+photo+"&key=AIzaSyB_JnpJt-zK0owgInVIVPw277su2b2slJI")
         let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        
            DispatchQueue.main.async {
                
                self.imahe.image  = UIImage(data: data!)!
                
            }       }
        
        task.resume()
    }
    
        func showCustomDialog(animated: Bool = true) {

        // Create a custom view controller
            let contentVC = MyPopupController.instantiate()
// init YourViewController

// Init popup view controller with content is your content view controller
let popupVC = PopupViewController(contentController: contentVC!, popupWidth: 400, popupHeight: 600)

// show it by call present(_ , animated:) method from a current UIViewController
present(popupVC, animated: true)
    }
    
    
}
