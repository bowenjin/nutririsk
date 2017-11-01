//
//  Util.swift
//  appbuilder
//
//  Created by Bowen Jin on 3/25/17.
//  Copyright © 2017 Bowen Jin. All rights reserved.
//

import Foundation
import SystemConfiguration
import SwiftyJSON

class Utility{
    static func errorHandler(error: String){
        var error = error;
        DispatchQueue.main.async {
            if error.contains("Optional(Error"){
                error = "An error occured!";
            }
            let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            
            topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    static func readFromFile(fileName: String, ext: String) -> String?{
//        let file = fileName //this is the file. we will write to and read from it
//        
//        
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            
//            let path = dir.appendingPathComponent(file)
//            
//            do {
//                let fileContent = try
//                String(contentsOf: path, encoding: String.Encoding.utf8)
//                return fileContent;
//            }
//            catch {
//                return nil;
//            }
//        }
//        return nil;
        if let filepath = Bundle.main.path(forResource: fileName, ofType: ext)
        {
            do
            {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                return contents;
                
            }
            catch
            {
                return nil;// contents could not be loaded
            }
        }
        else
        {
            return nil;// example.txt not found!
        }
    }
}
