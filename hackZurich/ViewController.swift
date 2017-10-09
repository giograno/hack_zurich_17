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

// Handle the first user input view
class ViewController: UIViewController, UITextFieldDelegate {
    
    // handle the sightseing or the pub crawling mdoe
    var mode: Mode = Mode.tourist
    
    // Material Components Text Fields for the positions
    @IBOutlet weak var startingPosition: MDCTextField!
    @IBOutlet weak var endingPosition: MDCTextField!
    
    @IBOutlet weak var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.setNavigationControllerStatusBar(self, title: "CityExplorer", color: CIColor(color: Utils.myColor), style: UIBarStyle.default)
        
        // Setting the placeholders
        self.view.addSubview(startingPosition)
        self.view.addSubview(endingPosition)
        
        startingPosition.placeholder = "Starting Point"
        endingPosition.placeholder = "Ending Point"
        endingPosition.text = "Technopark, Zurich, Switzerland"
        startingPosition.text = "Technopark, Zurich, Switzerland"
        
        setupSlider()
        setupTextField()
    }
    
    func setupSlider() {
        let slider = MDCSlider(frame: CGRect(x: 67, y: 350, width: 260, height: 75))
        slider.minimumValue = 0
        slider.maximumValue = 5
        slider.numberOfDiscreteValues = 8
        
        slider.addTarget(self,
                         action: #selector(didChangeSliderValue(senderSlider:)),
                         for: .valueChanged)
        view.addSubview(slider)
    }
    
    @IBAction func search(_ sender: Any) {
        print("here")
        self.performSegue(withIdentifier: "GenerateMap", sender: self)
    }
    
    @objc func didChangeSliderValue(senderSlider:MDCSlider) {
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

