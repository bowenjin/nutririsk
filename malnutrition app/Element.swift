//
//  Element.swift
//  appbuilder
//
//  Created by Bowen Jin on 3/25/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//
import SwiftyJSON
import Foundation

class Element{
    var _id: String?
    var _class: String?
    var _content: [Element]?
    var _text: String?
    var _color: String?
    var _click: String?
    var _title: String?
    var _options: [String]?
    var _value:String?
    var _selectedIndex: Int?
    var _images: [String]?
    
    init(jsonObject: JSON){
        self._id = jsonObject["id"].string;
        self._class = jsonObject["class"].string;
        self._content = createContentArray(array: jsonObject["content"].arrayValue);
        self._images = createStringArray(array: jsonObject["images"].arrayValue);
        self._text = jsonObject["text"].string;
        self._color = jsonObject["color"].string;
        self._click = jsonObject["click"].string;
        self._title = jsonObject["title"].string;
        self._options = createStringArray(array: jsonObject["options"].arrayValue)
        if self._id != nil{
            DataStore.addElement(id: self._id!, element: self)
        }
    }
    
    init(){
        
    }
    
    private func createContentArray(array: Array<JSON>) -> [Element]?{
        var retArray = [Element?]();
        for element in array{
            retArray.append(Element(jsonObject: element));
        }
        if(retArray.count > 0){
            return retArray as? [Element];
        }
        return nil;
    }
    
    private func createStringArray(array: Array<JSON>) -> [String]?{
        var retArray = [String]();
        for element in array{
            retArray.append(element.stringValue);
        }
        if(retArray.count > 0){
            return retArray;
        }
        return nil;
    }
    
    public func toString() -> String{
        var retString = "";
        if let myClass = _class{
            if(myClass == "multiple-choice" || myClass == "dropdown" || myClass == "textfield" || myClass == "switch"){
                
                if(_value != nil && _text != nil){
                    retString += (_text! + ":");
                    retString += (_value! + "\n");
                }
            }
            else if(myClass == "screen"){
                if let title = _title{
                    retString += ("\n<<" + title + ">>\n")
                }
            }
            if let content = self._content{
                for element in content{
                    retString += element.toString();
                }
            }
        }
        return retString;
      
    }
    
    public func clear(){
        _value = nil;
        _selectedIndex = nil;
        if let content = self._content{
            for element in self._content!{
                element.clear();
            }
        }
    }
}
