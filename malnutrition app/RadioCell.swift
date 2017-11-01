//
//  RadioCell.swift
//  appbuilder
//
//  Created by Bowen Jin on 4/3/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit

class RadioCell: UITableViewCell{
    
    var element: Element?
    
    @IBOutlet weak var label: UILabel!
    func set(element: Element?){
        self.element = element;
        self.label.text = element?._text;
    }
    
    
}
