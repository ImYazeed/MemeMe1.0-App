//
//  textFieldDelegate.swift
//  MemeMe1.0-App
//
//  Created by Yazeed ALZahrani on 1/2/19.
//  Copyright © 2019 Yazeed ALZahrani. All rights reserved.
//

import UIKit

class textFieldDelegate: NSObject,UITextFieldDelegate {

    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if ((textField.tag == 0 && textField.text == defaultTopText) || (textField.tag == 1 && textField.text == defaultBottomText)) {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
