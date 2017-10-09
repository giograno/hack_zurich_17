//
//  ModeSelector.swift
//  hackZurich
//
//  Created by Giovanni Grano on 09.10.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import UIKit

class ModeSelector: UIViewController {

    @IBOutlet weak var touristMode: UIImageView!
    @IBOutlet weak var pubMode: UIImageView!
    
    var mode : Mode = Mode.tourist
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let touristRecognizer = UITapGestureRecognizer(target:self, action:  #selector(imageTapped))
        let pubRecognizer = UITapGestureRecognizer(target:self, action:  #selector(pubTapped))
        touristMode.isUserInteractionEnabled = true
        touristMode.addGestureRecognizer(touristRecognizer)
        pubMode.isUserInteractionEnabled = true
        pubMode.addGestureRecognizer(pubRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mode" {
            if let destinationController = segue.destination as? ViewController {
                destinationController.mode = mode
            }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        mode = Mode.tourist
        performSegue(withIdentifier: "mode", sender: nil)
    }
    
    @objc func pubTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        mode = Mode.pub
        performSegue(withIdentifier: "mode", sender: nil)
    }

}
