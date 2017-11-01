//
//  ViewController.swift
//  appbuilder
//
//  Created by Bowen Jin on 3/25/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import UIKit
import SwiftyJSON

class ScreenController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    var element:Element?
    
    var pickerIndexPath: IndexPath? = nil;
    func pickerIsShown() -> Bool{
        return pickerIndexPath != nil;
    }
    var pickerCellRowHeight: CGFloat = 100;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround();
        tableView.tableFooterView = UIView();
        if(self.element?._title != nil){
            self.title = self.element?._title;
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func set(element: Element?){
        self.element = element;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _class = element?._class else {
            Utility.errorHandler(error: "Class is not defined for this element");
            return UITableViewCell();
        }
        if _class != "screen" && _class != "main-screen"{
            Utility.errorHandler(error: "Invalid element type, element must be a of type 'screen'");
            return UITableViewCell();
        }
        guard self.element != nil else {
            Utility.errorHandler(error: "Could not load the JSON");
            return UITableViewCell();
        }
        guard element?._content != nil else {
            Utility.errorHandler(error: "Content is not defined for this screen");
            return UITableViewCell();
        }
        
        if (self.pickerIsShown() && (self.pickerIndexPath?.section == indexPath.section) && indexPath.row == 1){
            
            var dropdownCell = self.tableView.cellForRow(at: IndexPath(row:indexPath.row - 1, section: indexPath.section))
            if(!(dropdownCell is DropdownCell)){
                dropdownCell = self.tableView.cellForRow(at: indexPath)
            }
            let dropdownCell2 = dropdownCell as! DropdownCell
            let cellElement = dropdownCell2.element
            let array = Bundle.main.loadNibNamed("PickerCell", owner: self, options: nil);
            let cell = array![0] as! PickerCell;
            cell.set(element: cellElement, delegate: self);
            return cell;
//            var dropdownCell = self.tableView.cellForRow(at: IndexPath(row:indexPath.row, section: indexPath.section))
////            if (!(dropdownCell is DropdownCell)){
////                dropdownCell = self.tableView.cellForRow(at: IndexPath(row:indexPath.row , section: indexPath.section))
////            }
//            if let dropdownCell2 = dropdownCell as? DropdownCell{
//                cell.set(element: cellElement, delegate: self, selectedIndex:dropdownCell2.selectedIndex);
//                return cell;
//            }
//            return UITableViewCell();
            
        }
        var cellElement:Element?
        if(self.pickerIsShown() && ((self.pickerIndexPath?.row)! < indexPath.section)){
            cellElement = element?._content?[indexPath.section];
        }
        else{
            cellElement = element?._content?[indexPath.section];
        }
        if(cellElement?._class == "dropdown"){
            
            let array = Bundle.main.loadNibNamed("DropdownCell", owner: self, options: nil);
            let cell = array![0] as! DropdownCell;
            cell.set(element: cellElement);
            return cell;
        }
        if(cellElement?._class == "textfield"){
            let array = Bundle.main.loadNibNamed("TextfieldCell2", owner: self, options: nil);
            let cell = array![0] as! TextfieldCell2;
            cell.set(element: cellElement);
            return cell;
        }
        if(cellElement?._class == "switch"){
            let array = Bundle.main.loadNibNamed("SwitchCell", owner: self, options: nil);
            let cell = array![0] as! SwitchCell;
            cell.set(element: cellElement);
            return cell;
        }
        if(cellElement?._class == "button"){
            let array = Bundle.main.loadNibNamed("ButtonCell", owner: self, options: nil);
            let cell = array![0] as! ButtonCell;
            cell.set(element: cellElement, parentController: self);
            return cell;

        }
        if(cellElement?._class == "label"){
            let array = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil);
            let cell = array![0] as! LabelCell;
            cell.set(element: cellElement);
            return cell;
        }
        if(cellElement?._class == "multiple-choice"){
//            if(indexPath.row == 0){
//                let array = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil);
//                let cell = array![0] as! LabelCell;
//                cell.set(element: cellElement);
//                return cell;
//            }
//            else{
                let element = Element();
                element._text = cellElement?._options?[indexPath.row]
                
                let array = Bundle.main.loadNibNamed("RadioCell", owner: self, options: nil);
                let cell = array![0] as! RadioCell;
                cell.set(element: element);
                if(cellElement?._selectedIndex == indexPath.row){
                    cell.accessoryType = .checkmark;
                }
                return cell;
//            }
        }
        if(cellElement?._class == "image-slider"){
            let array = Bundle.main.loadNibNamed("ItemTableCell", owner: self, options: nil);
            let cell = array![0] as! ItemTableCell;
            cell.setElement(element: cellElement!);
            return cell;
        }
        if(cellElement?._class == "make-note-button"){
            let element = Element();
            element._text = cellElement?._options?[indexPath.row]
            
            let array = Bundle.main.loadNibNamed("MakeNoteCell", owner: self, options: nil);
            let cell = array![0] as! UITableViewCell;
//            cell.set(element: element);
            return cell;
        }
        if(cellElement?._class == "reset-note-button"){
            let element = Element();
            element._text = cellElement?._options?[indexPath.row]
            
            let array = Bundle.main.loadNibNamed("ResetNoteCell", owner: self, options: nil);
            let cell = array![0] as! UITableViewCell;
            //            cell.set(element: element);
            return cell;
        }
        return UITableViewCell();
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellElement = element?._content?[section];
        if(cellElement?._class == "multiple-choice"){
            return (cellElement?._options!.count)!;
        }
        var rows = 1;
        if(pickerIndexPath?.section == section){
            rows = rows + 1;
        }
        return rows;
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 0;
        if let numberOfChildren = self.element?._content?.count{
            sections = numberOfChildren;
        }
        else{
            sections = 0;
        }
        return sections;
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath);
//        if(cell is RadioCell){
//            cell?.accessoryType = .none;
//        }
//    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath);
        let cellElement = element?._content?[indexPath.section];

        if(cell is DropdownCell){
            self.tableView.beginUpdates();
            
            if (self.pickerIsShown() && self.pickerIndexPath!.section == indexPath.section){
                //hidePicker
                hidePicker();
            }else {
                if (self.pickerIsShown()){
                    //hide picker
                    hidePicker();
                }
            
                self.pickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section);
                tableView.insertRows(at: [pickerIndexPath!], with: .automatic);

                
            }
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.endUpdates();

        }
        else if(cell is LabelCell){
            let labelCell = cell as! LabelCell;
            self.tableView.deselectRow(at: indexPath, animated: true)

            guard let elementId = element?._click else{
//                Utility.errorHandler(error: "click is not defined for this button");
                return;
                
            }
            guard let newElement = DataStore.getElement(id: elementId) else{
                Utility.errorHandler(error: "This button referencing a non-existent screen");
                return;
            }
            
            let screenController = ScreenController();
            screenController.set(element: newElement);
            if newElement._class == "main-screen"{
                self.navigationController?.popToRootViewController(animated: true);
            }
            else{
                self.navigationController?.pushViewController(screenController, animated: true)
            }
        }
        else if(cell is RadioCell){
            //check the row and uncheck other rows in section
            self.tableView.deselectRow(at: indexPath, animated: true)
            cell?.accessoryType = .checkmark
            let rowsCount = self.tableView.numberOfRows(inSection: indexPath.section)
            for i in 0..<rowsCount  {
                let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section))
                if(i != indexPath.row){
                    cell?.accessoryType = .none;
                }
            }
            
            //set the element values
            let cellElement = element?._content?[indexPath.section]
            cellElement?._selectedIndex = indexPath.row;
            cellElement?._value = cellElement?._options?[indexPath.row];
        }
        else if(cell is ButtonCell){
            let buttonCell = cell as! ButtonCell
            buttonCell.buttonClicked();
        }
        else if(cell is MakeNoteCell){
            tableView.deselectRow(at: indexPath, animated: true)
            let noteString = DataStore.elementsToString();
            let icd10String = DataStore.scanForIcd10Codes(noteString: noteString);
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NoteEditController") as! NoteEditController
            let note = Note(text: icd10String + noteString);
            controller.setNote(note: note, isEditingExisting: false);
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        else if(cell is ResetNoteCell){
            tableView.deselectRow(at: indexPath, animated: true)
            let alertController = UIAlertController(title: "Clear Note", message: "Are you sure you want to clear this note?", preferredStyle: UIAlertControllerStyle.alert)
            let clearAction = UIAlertAction(title: "Clear", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
                DataStore.clearElements();
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
    
    
//            let radioCell = cell as! RadioCell;
//            self.tableView.deselectRow(at: indexPath, animated: true)
        
//            guard let elementId = element?._click else{
//                //                Utility.errorHandler(error: "click is not defined for this button");
//                return;
//                
//            }
//            guard let newElement = DataStore.getElement(id: elementId) else{
//                Utility.errorHandler(error: "This button referencing a non-existent screen");
//                return;
//            }
//            
//            let screenController = ScreenController();
//            screenController.set(element: newElement);
//            if newElement._class == "main-screen"{
//                self.navigationController?.popToRootViewController(animated: true);
//            }
//            else{
//                self.navigationController?.pushViewController(screenController, animated: true)
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let cellElement = element?._content?[section];
        if(cellElement?._class == "multiple-choice"){
            return cellElement?._text;
        }
        return nil;
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let cellElement = element?._content?[section];
        if(cellElement?._class == "multiple-choice"){
            return " ";
        }
        return nil;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = self.tableView.rowHeight;
        rowHeight = 50;
        let cellElement = element?._content?[indexPath.section];
        if(cellElement?._class == "multiple-choice"){
            tableView.estimatedRowHeight = 140;
            return UITableViewAutomaticDimension;
        }
        if(cellElement?._class == "image-slider"){
            tableView.estimatedRowHeight = 140;
            return 110;
        }
        if (self.pickerIsShown() && (self.pickerIndexPath?.section == indexPath.section) && indexPath.row == 1){
            rowHeight = self.pickerCellRowHeight;
        }
        
        return rowHeight;
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    func hidePicker(){
        self.tableView.deleteRows(at: [self.pickerIndexPath!], with: .automatic);
        self.pickerIndexPath = nil;
    }
    
    func showNewPicker(indexPath: IndexPath){
        let newIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func calculateNewPickerIndexPath(selectedIndexPath: IndexPath) -> IndexPath{
        
        var newIndexPath:IndexPath?;
        
        if (self.pickerIsShown() && (self.pickerIndexPath!.row < selectedIndexPath.row)){
            newIndexPath = IndexPath(row: selectedIndexPath.row - 1, section: 0)
        }
        else {
            newIndexPath = IndexPath(row: selectedIndexPath.row, section: 0);
        }
        return newIndexPath!;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let pickerIndexPath = self.pickerIndexPath{
            let dropdownIndexPath = IndexPath(row: pickerIndexPath.row - 1, section: pickerIndexPath.section)
            var cell = self.tableView.cellForRow(at: dropdownIndexPath)
            if(!(cell is DropdownCell)){
                cell = self.tableView.cellForRow(at: pickerIndexPath)
            }
            let dropdownCell  = cell as! DropdownCell
            dropdownCell.valueLabel.text = dropdownCell.element?._options?[row]
            dropdownCell.element?._selectedIndex = row;
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let dropdownIndexPath = IndexPath(row: pickerIndexPath!.row - 1, section: pickerIndexPath!.section)
        var cell = self.tableView.cellForRow(at: dropdownIndexPath)
        if(!(cell is DropdownCell)){
            cell = self.tableView.cellForRow(at: pickerIndexPath!)
        }
        let dropdownCell  = cell as! DropdownCell
        if let options = dropdownCell.element?._options{
            return options.count;
        }
        else{
            Utility.errorHandler(error: "Dropdown cell has no options defined");
            return 0;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dropdownIndexPath = IndexPath(row: pickerIndexPath!.row - 1, section: pickerIndexPath!.section)
        var cell = self.tableView.cellForRow(at: dropdownIndexPath)
        if(!(cell is DropdownCell)){
            cell = self.tableView.cellForRow(at: pickerIndexPath!)
        }
        let dropdownCell  = cell as! DropdownCell
        if(row < (dropdownCell.element?._options!.count)!){
            return dropdownCell.element?._options![row]
        }
        return "";
    }
}

//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
//    
//    func showProgressBar(msg:String, _ indicator:Bool, width: CGFloat) {
//        DispatchQueue.main.async {
//            if(self.view.viewWithTag(200) != nil){
//                self.view.viewWithTag(200)?.isHidden = false;
//            }
//            else{
//                var messageFrame = UIView()
//                var activityIndicator = UIActivityIndicatorView()
//                var strLabel = UILabel()
//                strLabel.layer.zPosition = 9;
//                messageFrame.layer.zPosition = 9;
//                activityIndicator.layer.zPosition = 9;
//                
//                
//                strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
//                strLabel.text = msg
//                strLabel.textColor = UIColor.white
//                messageFrame = UIView(frame: CGRect(x: self.view.frame.midX - width/2, y: self.view.frame.midY - 25 , width: width, height: 50))
//                messageFrame.layer.cornerRadius = 15
//                messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
//                if indicator {
//                    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
//                    activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//                    activityIndicator.startAnimating()
//                    messageFrame.addSubview(activityIndicator)
//                }
//                messageFrame.addSubview(strLabel)
//                messageFrame.tag = 200;
//                self.view.addSubview(messageFrame)
//            }
//        }
//    }
//    
//    func hideProgressBar(){
//        DispatchQueue.main.async {
//            if(self.view.viewWithTag(200) != nil){
//                self.view.viewWithTag(200)?.isHidden = true;
//            }
//        }
//    }
//}
