//
//  Assignment.swift
//  iAssign
//
//  Created by Ian Thomas on 10/10/16.
//  Copyright © 2016 KKIT Creations. All rights reserved.
//
/*
 SQLite Book List
 
 
 This sample application is primarily focused on using the SQLite database with an iPhone application, and secondarily with leveraging that database to respond to low memory warnings. In addition, the sample demonstrates one approach to implementing a master-detail interface
 
 Build Requirements
 Mac OS X 10.5.3, Xcode 3.1, iPhone OS 2.0.
 
 Runtime Requirements
 Mac OS X 10.5.3, iPhone OS 2.0.
 
 Circa June 2009
 */

import UIKit

class Assignment: NSObject, NSCoding {
    
    var name = ""
    var note = ""
    var done = false
    var exam = false
    var dueDate = Date()
    var photoUrlString = ""
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        note = aDecoder.decodeObject(forKey: "note") as! String
        done = aDecoder.decodeBool(forKey: "done")
        exam = aDecoder.decodeBool(forKey: "exam")
        dueDate = aDecoder.decodeObject(forKey: "dueDate") as! Date
        photoUrlString = aDecoder.decodeObject(forKey: "photoUrlString") as! String
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(done, forKey: "done")
        aCoder.encode(exam, forKey: "exam")
        aCoder.encode(note, forKey: "note")
        aCoder.encode(dueDate, forKey: "dueDate")
        aCoder.encode(photoUrlString, forKey: "photoUrlString")
    }
}
