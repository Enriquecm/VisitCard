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
        if let allKeys = loadJsonInformation().allKeys {
            return allKeys.count
        }
        return 0
    }
    
    ///
    /// Return personal details
    ///
    class func personalDetails () -> [NSDictionary]
    {
        if dictInfo.isEmpty  {
            dictInfo = loadJsonInformationWithName("personal details") as! [NSDictionary]
            return dictInfo
        }else {
            return dictInfo
        }
    }
    
    ///
    /// Return education
    ///
    class func education () -> [NSDictionary]
    {
        if arrayEducation.isEmpty  {
            arrayEducation = loadJsonInformationWithName("education") as! [NSDictionary]
            return arrayEducation
        }else {
            return arrayEducation
        }
    }
    
    ///
    /// Return experience
    ///
    class func experience () -> [NSDictionary]
    {
        if arrayExperience.isEmpty  {
            arrayExperience = loadJsonInformationWithName("experience") as! [NSDictionary]
            return arrayExperience
        }else {
            return arrayExperience
        }
    }
    
    ///
    /// Return projects
    ///
    class func projects () -> [NSDictionary]
    {
        if arrayProjects.isEmpty  {
            arrayProjects = loadJsonInformationWithName("projects") as! [NSDictionary]
            return arrayProjects
        }else {
            return arrayProjects
        }
    }
    
    ///
    /// Return skills
    ///
    class func skills () -> [NSDictionary]
    {
        if arraySkills.isEmpty  {
            arraySkills = loadJsonInformationWithName("skills") as! [NSDictionary]
            return arraySkills
        }else {
            return arraySkills
        }
    }
    
    ///
    /// Return qualities
    ///
    class func qualities () -> [NSDictionary]
    {
        if arrayQualities.isEmpty  {
            arrayQualities = loadJsonInformationWithName("qualities") as! [NSDictionary]
            return arrayQualities
        }else {
            return arrayQualities
        }
    }
    
    ///
    /// Return volunteering
    ///
    class func volunteering () -> [NSDictionary]
    {
        if arrayVolunteering.isEmpty  {
            arrayVolunteering = loadJsonInformationWithName("volunteering") as! [NSDictionary]
            return arrayVolunteering
        }else {
            return arrayVolunteering
        }
    }
    
    ///
    /// Return honor and awards
    ///
    class func honor () -> [NSDictionary]
    {
        if arrayHonor.isEmpty  {
            arrayHonor = loadJsonInformationWithName("honororawards") as! [NSDictionary]
            return arrayHonor
        }else {
            return arrayHonor
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
