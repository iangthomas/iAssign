//
//  Assignment.swift
//  iAssign
//
//  Created by Ian Thomas on 10/10/16.
//  Copyright © 2016 KKIT Creations. All rights reserved.
//

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
