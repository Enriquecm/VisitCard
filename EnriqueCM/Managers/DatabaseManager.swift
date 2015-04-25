//
//  DatabaseManager.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 18/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

private var dictInfo = [NSDictionary]()
private var arrayEducation = [NSDictionary]()
private var arrayExperience = [NSDictionary]()

class DatabaseManager {
    
    /**
    Return the number of sections
    **/
    class func numberOfSectionsInInformation() -> Int {
        if let allKeys = loadJsonInformation().allKeys {
            return allKeys.count
        }
        return 0
    }
    
    /**
    Return personal details
    **/
    class func personalDetails () -> [NSDictionary]
    {
        if dictInfo.isEmpty  {
            dictInfo = loadJsonInformationWithName("personal details") as! [NSDictionary]
            return dictInfo
        }else {
            return dictInfo
        }
    }
    
    /**
    Return education
    **/
    class func education () -> [NSDictionary]
    {
        if arrayEducation.isEmpty  {
            arrayEducation = loadJsonInformationWithName("education") as! [NSDictionary]
            return arrayEducation
        }else {
            return arrayEducation
        }
    }
    
    /**
    Return experience
    **/
    class func experience () -> [NSDictionary]
    {
        if arrayExperience.isEmpty  {
            arrayExperience = loadJsonInformationWithName("experience") as! [NSDictionary]
            return arrayExperience
        }else {
            return arrayExperience
        }
    }
    
    private class func loadJsonInformationWithName(name: String) -> AnyObject
    {
        if let value: AnyObject = loadJsonInformation()[name] {
            return value
        }
        return []
    }
    
    private class func loadJsonInformation() -> AnyObject
    {
        let path = NSBundle.mainBundle().pathForResource("Information", ofType: "json")
        var error:NSError? = nil
        if let data = NSData(contentsOfFile: path!, options:nil, error:&error),
            json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error:&error) as? NSDictionary,
            team = json["information"] as? NSDictionary {
                return team
        }
        return []
    }
    
    private class func loadPlistInformationWithName(name: String) -> AnyObject
    {
        if var value: AnyObject = loadPlistInformation()[name] {
            return value
        }
        return []
    }
    
    private class func loadPlistInformation() -> AnyObject
    {
        if let path = NSBundle.mainBundle().pathForResource("Data", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                return dict
            }
        }
        return []
    }
}
