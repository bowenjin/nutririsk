//
//  ButtonCell.swift
//  appbuilder
//
//  Created by Bowen Jin on 3/26/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit

class ButtonCell:UITableViewCell{
    @IBOutlet weak var button: UIButton!
    var parentController: ScreenController?
    var element: Element?
    func set(element: Element?, parentController: ScreenController?){
        self.element = element;
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button.setTitle(element?._text, for: .normal);
        self.parentController = parentController;
    }
    
    func buttonClicked(){
        print("buttonClicked")
        guard let elementId = element?._click else{
            Utility.errorHandler(error: "click is not defined for this button");
            return;

        }
        guard let newElement = DataStore.getElement(id: elementId) else{
            Utility.errorHandler(error: "This button referencing a non-existent screen");
            return;
        }
        
        let screenController = ScreenController();
        screenController.set(element: newElement);
        if newElement._class == "main-screen"{
            parentController?.navigationController?.popToRootViewController(animated: true)
        }
        else{
            parentController?.navigationController?.pushViewController(screenController, animated: true)
        }
        
        
    }
}
