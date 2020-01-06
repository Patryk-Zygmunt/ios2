//
//  PopupViewController.swift
//  PlaceStory
//
//  Created by user163099 on 1/6/20.
//  Copyright © 2020 user163099. All rights reserved.
//
import WebKit
import UIKit

class MyPopupController: UIViewController,WKUIDelegate {

    
    @IBOutlet weak var web: WKWebView!

     static func instantiate() -> MyPopupController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(MyPopupController.self)") as? MyPopupController
    }
    
       override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        web = WKWebView(frame: .zero, configuration: webConfiguration)
        web.uiDelegate = self
        view = web
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let myURL = URL(string:"https://www.google.com/maps/place/37%C2%B019'56.4%22N+122%C2%B001'52.4%22W/@37.3323314,-122.0312186,17z/data=!4m6!3m5!1s0x0:0x0!4b1!8m2!3d37.3323314!4d-122.0312186")
        let myRequest = URLRequest(url: myURL!)
        web.load(myRequest)
        print(myRequest)
}

        // Do any additional setup after loading the view.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


