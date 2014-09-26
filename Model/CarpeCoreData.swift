//
//  CarpeCoreData.swift
//  CarpeDM
//
//  Created by Niall Kelly on 26/09/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

import UIKit
import CoreData

class CarpeCoreData {
  
  class var sharedInstance : CarpeCoreData {
  struct Static {
    static let instance : CarpeCoreData = CarpeCoreData()
    }
    return Static.instance
  }
  
  func setup() {
    MagicalRecord.setShouldDeleteStoreOnModelMismatch(true)
    MagicalRecord.setupAutoMigratingCoreDataStack()
  }
  
  func saveAll() {
    
  }
  
  func cleanUp() {
    MagicalRecord.cleanUp()
  }
}
