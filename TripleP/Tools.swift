//
//  Tools.swift
//  TripleP
//
//  Created by John Whisker on 2/22/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField

class Tools {
    public static func initSkyText(placeHolder: String, title: String, keyboardType :UIKeyboardType?,isSecureContent: Bool, Rect: CGRect)-> SkyFloatingLabelTextField{
        let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
        let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
        let testText = SkyFloatingLabelTextField.init(frame: Rect)
        testText.placeholder = placeHolder
        testText.title = title
        testText.tintColor = overcastBlueColor
        testText.textColor = darkGreyColor
        testText.lineColor = lightGreyColor
        testText.selectedTitleColor = overcastBlueColor
        testText.selectedLineColor = overcastBlueColor
        testText.lineHeight = 1.0
        testText.selectedLineHeight = 2.0
        testText.isSecureTextEntry = isSecureContent
        guard keyboardType != nil else {
            testText.keyboardType = .default
            return testText
        }
        
        testText.keyboardType = keyboardType!
        
        return testText
    }
    
    public static func isEmpty (UITextFields: NSArray) -> Bool {
        for textField in UITextFields {
            let exam = textField as! SkyFloatingLabelTextField
            if exam.text == "" {
                return true
            }
        }
        return false
    }
}

// MARK Extenstion of UIViewController
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
