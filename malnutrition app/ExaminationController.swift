//
//  ExaminationController.swift
//  malnutrition app
//
//  Created by Bowen Jin on 12/1/16.
//  Copyright © 2016 Bowen Jin. All rights reserved.
//


import UIKit
import SwiftyJSON

class ExaminationController: BaseController{
    
    @IBOutlet weak var symptomsButton: BaseButton!
    
    @IBOutlet weak var assessmentButton: BaseButton!
    
    @IBOutlet weak var clearNoteButton: BaseButton!
    @IBOutlet weak var makeNoteButton: BaseButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        symptomsButton.addTarget(self, action: #selector(symptomsButtonClicked), for: .touchUpInside)
        assessmentButton.addTarget(self, action: #selector(assessmentButtonClicked), for: .touchUpInside)
        
        makeNoteButton.addTarget(self, action: #selector(makeNoteButtonClicked(sender:)), for: .touchUpInside)
        
        clearNoteButton.addTarget(self, action: #selector(clearNoteButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
         let thisController = self;
        
//        symptomsButton.layer.borderWidth = 1;
//        symptomsButton.layer.borderColor = symptomsButton.tintColor.cgColor
//        
//        assessmentButton.layer.borderWidth = 1;
//        assessmentButton.layer.borderColor = assessmentButton.tintColor.cgColor;
        
//        self.screenName = "Examination Screen"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        AppDelegate.loadedAssessments = false;
        AppDelegate.loadedSymptoms = false;
    }
    
    func assessmentButtonClicked(){
        DataStore.get().loadAssessment(callback: {
            let rootItem = DataStore.get().rootItemAssessmentQuiz;
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AssessmentController") as! AssessmentController
            controller.setItem(rootItem: rootItem.nextItems[0]);
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(controller, animated: true);
            }
        }, errorHandler: {error in
            
        });
        
    }
    
    func symptomsButtonClicked(){
//        DataStore.get().loadSymptoms(callback: {
//            let rootItem = DataStore.get().rootItemExamination;
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "ItemTableController") as! ItemTableController
//            print(rootItem.nextItems[0]);
//            controller.setItem(item: rootItem.nextItems[0]);
//            DispatchQueue.main.async {
//                self.navigationController?.pushViewController(controller, animated: true);
//            }
//        }, errorHandler: {error in
//            
//        });
        
//        let navigationController = UINavigationController()
        let initialViewController = ScreenController();
//        navigationController.viewControllers = [initialViewController];
//        AppDelegate.shared.window?.rootViewController = navigationController
//        AppDelegate.shared.window?.makeKeyAndVisible()
        if let string = Utility.readFromFile(fileName: "test", ext: "json"){
            print(string);
            if let dataFromString = string.data(using: .utf8, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                if(json == JSON.null){
                    Utility.errorHandler(error: "Invalid json, could not parse");
                }
                let array = json.arrayValue;
                for element in array{
                    if(element["class"].stringValue == "main-screen"){
                        let mainScreen = Element(jsonObject: element)
                        initialViewController.set(element: mainScreen);
                        
                    }
                    else{
                        Element(jsonObject: element);
                    }
                }
            }
             navigationController?.pushViewController(initialViewController, animated: true)
        }
        else{
            DataStore.get().errorHandler(error: "Unable to read from json file");
        }
    }
    
    func makeNoteButtonClicked(sender: BaseButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NoteEditController") as! NoteEditController
        let note = Note(text: DataStore.get().getNoteString());
        controller.setNote(note: note, isEditingExisting: false);
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func clearNoteButtonClicked(sender: BaseButton){
        let alertController = UIAlertController(title: "Clear Note", message: "Are you sure you want to clear this note?", preferredStyle: UIAlertControllerStyle.alert)
        let clearAction = UIAlertAction(title: "Clear", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            DataStore.get().clearNote();

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(clearAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }

}
