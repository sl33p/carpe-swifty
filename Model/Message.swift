//
//  Message.swift
//  CarpeDM
//
//  Created by Niall Kelly on 26/09/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

import Foundation
import CoreData

class Message: NSManagedObject {

    @NSManaged var createdAt: NSDate
    @NSManaged var id: String
    @NSManaged var text: String
    @NSManaged var user: NSManagedObject
    @NSManaged var conversation: NSManagedObject

}
