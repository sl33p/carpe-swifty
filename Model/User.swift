//
//  User.swift
//  CarpeDM
//
//  Created by Niall Kelly on 26/09/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var screenName: String
    @NSManaged var id: String
    @NSManaged var location: String
    @NSManaged var about: String
    @NSManaged var profileImageUrl: String
    @NSManaged var name: String
    @NSManaged var url: String
    @NSManaged var timezone: String
    @NSManaged var createdAt: NSDate
    @NSManaged var verified: NSNumber
    @NSManaged var profileBackgroundImageUrl: String
    @NSManaged var profileUseBackgroundImage: NSNumber
    @NSManaged var profileBannerUrl: String
    @NSManaged var accountIdentifier: String
    @NSManaged var primaryUser: NSNumber
    @NSManaged var messages: NSSet
    @NSManaged var conversations: NSSet

}
