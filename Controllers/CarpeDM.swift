//
//  CarpeDM.swift
//  TwitterDM
//
//  Created by Niall Kelly on 25/09/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

import UIKit
import SwifteriOS
import Accounts

typealias AuthenticationResponseHandler = (NSError!) -> Void
typealias DirectMessagesResponseHandler = ([JSONValue], NSError!) -> Void

class CarpeDM {
  
  // MARK: - Tokens
  
  class func storeAccessToken(accessToken: SwifterCredential.OAuthAccessToken) {
    NSUserDefaults.standardUserDefaults().setObject(accessToken.key, forKey: "OAuthAccessTokenKey")
    NSUserDefaults.standardUserDefaults().setObject(accessToken.secret, forKey: "OAuthAccessTokenSecret")
  }
  
  class func getAccessToken() -> (key: String, secret: String)? {
    let key : String? = NSUserDefaults.standardUserDefaults().objectForKey("OAuthAccessTokenKey") as String?
    let secret : String? = NSUserDefaults.standardUserDefaults().objectForKey("OAuthAccessTokenSecret") as String?
    if (key == nil || secret == nil) {
      return nil
    }
    return (key!, secret!)
  }
  
  class func hasAccessToken() -> Bool {
    return self.getAccessToken() != nil
  }
  
  class func clearAccessToken() -> Bool {
    if (self.hasAccessToken() == false) {
      return false
    }
    NSUserDefaults.standardUserDefaults().removeObjectForKey("OAuthAccessTokenKey")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("OAuthAccessTokenSecret")
    return true
  }
  
  // MARK: - Swifter 
  
  private class func swifterInstance() -> Swifter {
    let consumerKey = "zUFQlABS8vQfDPnUsg6t4mHiu"
    let consumerSecret = "ZlyAI8G3eoR24PDwk6mX4TnNgSkl2cVTphYaZPkbSd7XdAs22r"
    if let token = self.getAccessToken() {
      return Swifter(consumerKey: consumerKey, consumerSecret: consumerSecret, oauthToken: token.key, oauthTokenSecret: token.secret)
    }
    else {
      return Swifter(consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
  }
  
  // MARK: - Authorisation
  
  class func authoriseWithResponseHandler(handler: AuthenticationResponseHandler) -> Bool {
    if (self.hasAccessToken()) {
      return true
    }
    let swifter = self.swifterInstance()
    swifter.authorizeWithCallbackURL(
      NSURL(string: "carpedm://success"),
      success:
      { (accessToken, response) -> Void in
        self.storeAccessToken(accessToken!)
        handler(nil)
      },
      failure:
      { (error) -> Void in
        handler(error)
      }
    )
    return false
  }
  
  // MARK: - Fetching
  
  class func getDirectMessagesWithResponseHandler(handler: DirectMessagesResponseHandler) -> Bool {
    if (self.hasAccessToken() == false) {
      return false
    }
    let swifter = self.swifterInstance()
    swifter.getDirectMessagesSinceID(
      nil,
      maxID: nil,
      count: nil,
      includeEntities: false,
      skipStatus: false,
      success:
      { (messages) -> Void in
        if messages != nil {
          handler(messages!, nil)
        }
      },
      failure:
      { (error) -> Void in
        handler([], error)
      }
    )
    return true;
  }
  
  
  // MARK: - Stored Account
  
  private class func archivePath() -> String {
    return String.documentsDirectory().stringByAppendingPathComponent("User-storedAccountIdentifer.dat")
  }
  
  class func storeAccountIdentifier(identifier : String?)  {
    if (identifier == nil) {
      println("Cannot store nil identifier")
      return
    }
    let data : NSData = NSKeyedArchiver.archivedDataWithRootObject(identifier!)
    data.writeToFile(self.archivePath(), atomically: true)
  }
  
  class func getStoredAccountIdentifier() -> String? {
    return NSKeyedUnarchiver.unarchiveObjectWithFile(self.archivePath()) as String?
  }
  
  class func hasStoredAccount() -> Bool {
    let identifier : String? = self.getStoredAccountIdentifier()
    return identifier != nil
  }
  
  class func clearStoredAccount() -> Bool {
    if (self.getStoredAccountIdentifier() == nil) {
      return false
    }
    var error : NSError?
    NSFileManager.defaultManager().removeItemAtPath(self.archivePath(), error: &error)
    return error == nil
  }
  
  class func getStoredAccount() -> ACAccount? {
    let identifier : String? = self.getStoredAccountIdentifier()
    if (identifier == nil) {
      println("Cannot store nil identifier")
      return nil
    }
    return ACAccountStore().accountWithIdentifier(identifier!)
  }
}


extension String {
  
  static func documentsDirectory() -> String {
    let docs : Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as Array
    return docs.last! as String
  }
}
