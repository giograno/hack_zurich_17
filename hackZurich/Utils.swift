//
//  Utils.swift
//  hackZurich
//
//  Created by Giovanni Grano on 16.09.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import UIKit

class Utils {
    /// various types of colors for MyUnimol UI
    
    let instance = Utils()
    
    static let myColor = UIColor(red: 1.0, green: 0.76, blue: 0.03, alpha: 1.0)

    static func setNavigationControllerStatusBar(_ myView: UIViewController, title: String, color: CIColor, style: UIBarStyle) {
        let navigation = myView.navigationController!
        navigation.navigationBar.barStyle = style
        navigation.navigationBar.barTintColor = UIColor(ciColor: color)
        navigation.navigationBar.isTranslucent = false
        navigation.navigationBar.tintColor = UIColor.black
        myView.navigationItem.title = title
    }
}
