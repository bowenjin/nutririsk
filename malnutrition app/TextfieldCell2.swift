//
//  TextfieldCell.swift
//  appbuilder
//
//  Created by Bowen Jin on 3/25/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit

class TextfieldCell2: UITableViewCell, UITextFieldDelegate{
    var element: Element?
    @IBOutlet weak var textfield: UITextField!
    
    func set(element: Element?){
        self.element = element;
        textfield.placeholder = element?._text;
        textfield.delegate = self;
        textfield.text = element?._value;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        element?._value = textField.text
    }
}
