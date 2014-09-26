//
//  User+CarpeDM.swift
//  CarpeDM
//
//  Created by Niall Kelly on 26/09/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

import UIKit
import Accounts

extension User {
  
  func account() -> ACAccount? {
    return ACAccountStore().accountWithIdentifier(self.accountIdentifier)
  }
  
  class func userWithAccountIdentifier(identifier: String) -> User? {
    let user : User? = User.MR_findFirstByAttribute("accountIdentifier", withValue: identifier);
    return user
  }
  
  class func checkUserOrCreateWithAccountIdentifier(identifier: String) -> User {
    let user : User? = self.userWithAccountIdentifier(identifier)
    if user != nil {
      return user!
    }
    
    let newUser = User.MR_createEntity()
    newUser.accountIdentifier = identifier
    newUser.primaryUser = true as NSNumber
    
    let account : ACAccount = ACAccountStore().accountWithIdentifier(identifier)
    newUser.screenName = account.username
    newUser.name = account.userFullName
    
    MagicalRecord.saveWithBlockAndWait(nil)
    return newUser
  }
  
  class func primary() -> User? {
    let user : User? = User.MR_findFirstByAttribute("primaryUser", withValue: true as NSNumber);
    return user
  }
  
  class func clearPrimary() {
    if let user = self.primary() {
      user.primaryUser = false
      MagicalRecord.saveWithBlockAndWait(nil)
    }
  }
  
  func getName(classType:AnyClass) -> String {
    
    let classString = NSStringFromClass(classType.self)
    let range = classString.rangeOfString(".", options: NSStringCompareOptions.CaseInsensitiveSearch, range: Range<String.Index>(start:classString.startIndex, end: classString.endIndex), locale: nil)
    return classString.substringFromIndex(range!.endIndex)
  }
}