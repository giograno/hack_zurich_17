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
    
    /// the `UIView` which contain the loading sentences and the activity indicator
    static var messageFrame = UIView()
    /// the activity indicator
    static var activityIndicator = UIActivityIndicatorView()
    /// the label for the current sentences
    static var strLabel = UILabel()
    
    static let myColor = UIColor(red: 1.0, green: 0.76, blue: 0.03, alpha: 1.0)

    static func setNavigationControllerStatusBar(_ myView: UIViewController, title: String, color: CIColor, style: UIBarStyle) {
        let navigation = myView.navigationController!
        navigation.navigationBar.barStyle = style
        navigation.navigationBar.barTintColor = UIColor(ciColor: color)
        navigation.navigationBar.isTranslucent = false
        navigation.navigationBar.tintColor = UIColor.black
        myView.navigationItem.title = title
    }
    
    static func setMapsController(_ myView: UIViewController, title: String, color: CIColor, style: UIBarStyle, button: UIBarButtonItem) {
        let navigation = myView.navigationController!
        navigation.navigationBar.barStyle = style
        navigation.navigationBar.barTintColor = UIColor(ciColor: color)
        navigation.navigationBar.isTranslucent = false
        navigation.navigationBar.tintColor = UIColor.black
        myView.navigationItem.title = title
        
        button.tintColor = UIColor.black
        myView.navigationItem.rightBarButtonItem = button
    }
    
    static func progressBarDisplayer(_ targetVC: UIViewController, msg:String, indicator:Bool) {
        
        let height = myHeightForView(msg, width: 200)
        
        strLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: height))
        strLabel.numberOfLines = 0
        strLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        strLabel.text = msg
        strLabel.font = strLabel.font.withSize(20)
        strLabel.textAlignment = .center
        strLabel.center = CGPoint(x: 125, y: (height/2 + 20.0))
        strLabel.textColor = UIColor.black
        
        let size: CGFloat = 260
        var screeHeight: CGFloat
        screeHeight = targetVC.view.frame.size.height - 64

        let screenWidth = targetVC.view.frame.size.width
        
        let frame = CGRect(x: (screenWidth / 2) - (size / 2), y: (screeHeight / 2) - (height / 2), width: size, height: height)
        messageFrame = UIView(frame: frame)
        
        messageFrame.layer.cornerRadius = 15
        
        messageFrame.backgroundColor = Utils.myColor
        if (indicator) {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.center = CGPoint(x: 125, y: 35)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        targetVC.view.addSubview(messageFrame)
    }
    
    fileprivate static func myHeightForView(_ text: String, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        label.sizeToFit()
        if (label.frame.height <= 50) {
            return 50.0 + 75.0
        } else {
            return label.frame.height + 75.0
        }
    }
    
    /// Removes the progress bar from a given view
    static func removeProgressBar(_ targetVC: UIViewController) {
        messageFrame.removeFromSuperview()
    }
}
