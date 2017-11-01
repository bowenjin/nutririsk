//
//  PickerCell.swift
//  appbuilder
//
//  Created by Bowen Jin on 3/25/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//
import UIKit

class DropdownCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var element:Element?
    var selectedIndex:Int?
    func set(element: Element?){
        self.element = element;
        titleLabel.text = element?._text
        //valueLabel.text = currentValue
        self.selectedIndex = 0;
    }
    
}
