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
        
        setupTextField()
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

