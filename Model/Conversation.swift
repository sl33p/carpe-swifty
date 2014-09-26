//
//  Conversation.swift
//  CarpeDM
//
//  Created by Niall Kelly on 26/09/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

import Foundation
import CoreData

class Conversation: NSManagedObject {

    @NSManaged var messages: NSSet
    @NSManaged var users: NSSet

}
