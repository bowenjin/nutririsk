//
//  PickerCell.swift
//  appbuilder
//
//  Created by Bowen Jin on 3/25/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell{
    var element: Element?
    var selectedIndex: Int?
    @IBOutlet weak var pickerView: UIPickerView!
    func set(element: Element?, delegate: ScreenController){
        self.element = element;
        pickerView.delegate = delegate;
        if let selectedIndex = element?._selectedIndex{
            pickerView.selectRow(selectedIndex, inComponent: 0, animated: false);
        }
    }
    
}
