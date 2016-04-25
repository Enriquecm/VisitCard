//
//  DatabaseManager.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 18/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

private var dictInfo            = [NSDictionary]()
private var arrayEducation      = [NSDictionary]()
private var arrayExperience     = [NSDictionary]()
private var arrayProjects       = [NSDictionary]()
private var arraySkills         = [NSDictionary]()
private var arrayQualities      = [NSDictionary]()
private var arrayVolunteering   = [NSDictionary]()
private var arrayHonor          = [NSDictionary]()

class DatabaseManager {
    
    ///
    /// Return the number of sections
    ///
    class func numberOfSectionsInInformation() -> Int {
        return loadInformationArray().count
    }
    
    ///
    /// Return all information in JSON file
    ///
    class func loadInformationArray() -> [AnyObject] {
        let path = NSBundle.mainBundle().pathForResource("InformationV2", ofType: "json")
        
        if let data = try? NSData(contentsOfFile: path!, options: []),
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary {
            
            let info = json["information"] as? [AnyObject] ?? []
            return info
        }
        return []
    }
    
    private class func loadPlistInformationWithName(name: String) -> AnyObject {
        if let value: AnyObject = loadPlistInformation()[name] {
            return value
        }
        return []
    }
    
    private class func loadPlistInformation() -> AnyObject {
        if let path = NSBundle.mainBundle().pathForResource("Data", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                return dict
            }
        }
        return []
    }
}
