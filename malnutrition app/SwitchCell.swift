//
//  SwitchCell.swift
//  appbuilder
//
//  Created by Bowen Jin on 3/25/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell{
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var _switch: UISwitch!
    
    var element: Element?
    
    func set(element: Element?){
        self.element = element;
        label.text = element?._text;
    }
}
