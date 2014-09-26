//
//  AuthenticationViewController.swift
//  TwitterDM
//
//  Created by Niall Kelly on 17/09/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

import UIKit
import SwifteriOS
import Accounts

typealias AuthenticationViewControllerResponseHandler = (User, NSError!) -> Void

class AuthenticationViewController: UIViewController {
  
  @IBOutlet private weak var button: UIButton!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  private var twitterAccountsDiscovered : Array<ACAccount>!
  
  var authenticationHandler: AuthenticationViewControllerResponseHandler?

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.toggleSpinnerOn(false)
    CarpeDM.clearAccessToken()
    User.clearPrimary()
  }
  
  @IBAction func authenticate() {
    
    self.toggleSpinnerOn(true)
    
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(accountType, options: nil, completion: { (success:Bool, error:NSError!) -> Void in
      
      dispatch_async(dispatch_get_main_queue(), {
        
        if success {
          var twitterAccounts = accountStore.accountsWithAccountType(accountType) as? Array<ACAccount>
          
          if (twitterAccounts != nil) {
            self.twitterAccountsDiscovered = twitterAccounts!
            self.showActionSheetWithAccounts()
          }
          else {
            self.showBasicAlert("Error", message: "Error fetching Twitter profile", spinnerToggleFlag: false)
          }
        }
      })
    })
  }
  
  func accountSelected(account: ACAccount) {
    
    let success = CarpeDM.authoriseWithResponseHandler { (error) -> Void in
      if (error == nil) {
        self.showBasicAlert("Success", message: "Authenticated Twitter profile!", spinnerToggleFlag: false)
        if (self.authenticationHandler != nil) {
          let user : User = User.checkUserOrCreateWithAccountIdentifier(account.identifier)
          self.authenticationHandler!(user, nil)
        }
      }
      else {
        self.showBasicAlert("Error", message: "Error authenticating Twitter profile. Please try again\n\n\(error.localizedDescription)", spinnerToggleFlag: false)
      }
    }
  }
  
  func showActionSheetWithAccounts() {
    
    if (self.twitterAccountsDiscovered.count == 0) {
      self.showBasicAlert("No Twitter Account", message: "No Twitter accounts are configured. Setup a Twitter account in Settings.", spinnerToggleFlag: false)
      return
    }
    
    var alertController : UIAlertController = UIAlertController(title: "Select an account", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    for (index, twitterAccount) in enumerate(self.twitterAccountsDiscovered) {
      alertController.addAction(UIAlertAction(title: twitterAccount.username, style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
        self.accountSelected(self.twitterAccountsDiscovered[index])
      }))
    }
    
    alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action:UIAlertAction!) -> Void in
      self.toggleSpinnerOn(false)
    }))
    self.presentViewController(alertController, animated: true, completion: nil)

  }
  
  func showBasicAlert(title: String, message: String, spinnerToggleFlag: Bool) {
    UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
    self.toggleSpinnerOn(spinnerToggleFlag)
  }
  
  func toggleSpinnerOn(on : Bool) {
    button.hidden = on
    if (on) {
      spinner.startAnimating()
      return
    }
    spinner.stopAnimating()
  }
  
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {

    let account : ACAccount = self.twitterAccountsDiscovered[buttonIndex];
    self.accountSelected(account)
  }
}