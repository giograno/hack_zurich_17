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
import MaterialComponents.MaterialAppBar
import MaterialComponents.MaterialTextFields
import MaterialComponents.MDCFlatButton

// Handle the first user input view
class ViewController: UIViewController, UITextFieldDelegate {

    // Material Components navigation bar
    let appBar = MDCAppBar()
        
    // Switch outlets
    @IBOutlet weak var sightseeing_switch: UISwitch!
    @IBOutlet weak var bars_switch: UISwitch!
    @IBOutlet weak var coffee_switch: UISwitch!
    
    // Material Components Text Fields for the positions
    @IBOutlet weak var startingPosition: MDCTextField!
    @IBOutlet weak var endingPosition: MDCTextField!
    
    // Button to Trigger the map search
    @IBOutlet weak var search: MDCFlatButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Settting for Navigation Controller
        addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = UIColor(red: 1.0, green: 0.76, blue: 0.03, alpha: 1.0)
        appBar.navigationBar.tintColor = UIColor.black
        appBar.addSubviewsToParent()
        
        
        title = "Computational Tourism"
        
        // Setting the placeholders
        self.view.addSubview(startingPosition)
        self.view.addSubview(endingPosition)
        
        startingPosition.placeholder = "Starting Point"
        endingPosition.placeholder = "Ending Point"
        
        setupButton()
        setupSlider()
        setupTextField()
    }
    
    func setupButton() {
        search.setTitle("Search", for: .normal)
    }
    
    @IBAction func startSearch(_ sender: Any) {
        // to implement
        print("To implement")
        self.performSegue(withIdentifier: "GenerateMap", sender: self)
    }
    
    func setupSlider() {
        let slider = MDCSlider(frame: CGRect(x: 67, y: 450, width: 260, height: 75))
        slider.minimumValue = 0
        slider.maximumValue = 5
        slider.numberOfDiscreteValues = 8
        
        slider.addTarget(self,
                         action: #selector(didChangeSliderValue(senderSlider:)),
                         for: .valueChanged)
        view.addSubview(slider)
    }
    
    func didChangeSliderValue(senderSlider:MDCSlider) {
        print("Did change slider value to: %@", senderSlider.value)
    }
    
    func setupTextField() {
        let startingPositionController = MDCTextInputControllerDefault(textInput: startingPosition)
        startingPositionController.isFloatingEnabled = false
        startingPosition.delegate = self
        
        let endingPositionController = MDCTextInputControllerDefault(textInput: endingPosition)
        endingPositionController.isFloatingEnabled = false
        endingPosition.delegate = self
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

