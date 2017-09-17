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

//    // Material Components navigation bar
//    let appBar = MDCAppBar()
    
    // Switch outlets
    @IBOutlet weak var sightseeing_switch: UISwitch!
    @IBOutlet weak var bars_switch: UISwitch!
    @IBOutlet weak var coffee_switch: UISwitch!
    
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

//    override func viewWillAppear(_ animated: Bool) {
//        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showPopup(_:)))
//        edit.tintColor = UIColor.white
//        self.appBar.navigationBar.rightBarButtonItem = edit
//    }
    
//    func showPopup(_ sender: UIBarButtonItem) {
//        let messageString = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur " +
//            "ultricies diam libero, eget porta arcu feugiat sit amet. Maecenas placerat felis sed risus " +
//            "maximus tempus. Integer feugiat, augue in pellentesque dictum, justo erat ultricies leo, " +
//            "quis eleifend nisi eros dictum mi. In finibus vulputate eros, in luctus diam auctor in. " +
//            "Aliquam fringilla neque at augue dictum iaculis. Etiam ac pellentesque lectus. Aenean " +
//            "vestibulum, tortor nec cursus euismod, lectus tortor rhoncus massa, eu interdum lectus urna " +
//            "ut nulla. Phasellus elementum lorem sit amet sapien dictum, vel cursus est semper. Aenean " +
//            "vel turpis maximus, accumsan dui quis, cursus turpis. Nunc a tincidunt nunc, ut tempus " +
//            "libero. Morbi ut orci laoreet, luctus neque nec, rhoncus enim. Cras dui erat, blandit ac " +
//            "malesuada vitae, fringilla ac ante. Nullam dui diam, condimentum vitae mi et, dictum " +
//        "euismod libero. Aliquam commodo urna vitae massa convallis aliquet."
//        
//        let materialAlertController = MDCAlertController(title: nil, message: messageString)
//        
//        let action = MDCAlertAction(title:"OK") { (_) in print("OK") }
//        
//        materialAlertController.addAction(action)
//        
//        self.present(materialAlertController, animated: true, completion: nil)
//    }
    
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

