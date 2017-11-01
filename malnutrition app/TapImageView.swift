//
//  TappableImage.swift
//  malnutrition app
//
//  Created by Bowen Jin on 4/17/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import Foundation
import UIKit

class TapImageView: UIImageView, UIGestureRecognizerDelegate{
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    override func awakeFromNib() {
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(onTapped));
        
        tapGestureRecognizer!.cancelsTouchesInView = true;
        tapGestureRecognizer!.delegate = self;
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    
    func onTapped(){
        print("TapImageView was tapped!")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller : PictureViewController = storyBoard.instantiateViewController(withIdentifier: "PictureViewController") as! PictureViewController
        if let image = self.image{
            controller.setImage(image: image);
        }
        
        UIApplication.topViewController()?.present(controller, animated: true, completion: nil);
    }
    
}
