//
//  ViewController.swift
//  hackZurich
//
//  Created by Giovanni Grano on 16.09.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import UIKit
import ArcGIS
import MaterialComponents.MaterialSlider
import MaterialComponents.MaterialTextFields
import MaterialComponents.MaterialDialogs

import CoreLocation
import AddressBookUI

// Handle the first user input view
class ViewController: UIViewController, UITextFieldDelegate {
    
    // handle the sightseing or the pub crawling mdoe
    var mode: Mode = Mode.tourist
    
    // Material Components Text Fields for the positions

    @IBOutlet weak var startingPosition: UITextField!
    @IBOutlet weak var endingPosition: UITextField!
    @IBOutlet weak var timePerSite: UITextField!
    @IBOutlet weak var totalTime: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    var staring : Place = Place(lat: 0, lon: 0, name: "dummy")
    var ending : Place = Place(lat: 0, lon: 0, name: "dummy")
    
    var validCall : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.setNavigationControllerStatusBar(self, title: "CityExplorer", color: CIColor(color: Utils.myColor), style: UIBarStyle.default)
        
        // Setting the placeholders
        self.view.addSubview(startingPosition)
        self.view.addSubview(endingPosition)
        
        startingPosition.placeholder = "Starting Point"
        endingPosition.placeholder = "Ending Point"
        
        setupTextField()
    }
    
    @IBAction func search(_ sender: Any) {
        
        let group = DispatchGroup()
        group.enter()
        forwardGeocoding(address: startingPosition.text!, position: "starting") {
            print("ending starting")
            group.leave()
        }
        group.enter()
        forwardGeocoding(address: endingPosition.text!, position: "ending") {
            print("ending beginning")
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            print("everything is done")
            if self.validCall == true {
                self.performSegue(withIdentifier: "GenerateMap", sender: self)
            }
        })
        
    }
    
    func setupTextField() {
        self.startingPosition.delegate = self
        self.endingPosition.delegate = self
    }
    
    func forwardGeocoding(address: String, position: String, completion: @escaping () -> ()){
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                self.showAlertForAddress(address: address)
                self.validCall = false
                return
            }
            
            if let place = placemarks {
                if place.count > 0  {
                    let place = placemarks?[0]
                    let location = place?.location
                    let coordinate = location?.coordinate
                    let coords : Place = Place(lat: Double((coordinate?.latitude)!), lon: Double((coordinate?.longitude)!), name: "dummy")
                    
                    if position == "starting" {
                        self.staring = coords
                    } else {
                        self.ending = coords
                    }
                    
                    print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                    self.validCall = true
                }
            } else {
                print("error")
                self.showAlertForAddress(address: address)
                self.validCall = false
            }
            completion()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GenerateMap" {
            if let destinationController = segue.destination as? MapController {
                destinationController.time = Double(self.timePerSite.text!)!
                destinationController.total_time = self.totalTime.text!
                destinationController.staringPoint = self.staring
                destinationController.endingPoint = self.ending
            }
        }
    }
    
    func showAlertForAddress(address: String) {
        let alertController = MDCAlertController(title: "That's not correct!",
                                                 message: "That address seems to do not exist: \(address)")
        let action = MDCAlertAction(title:"OK") { (action) in print("OK") }
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

