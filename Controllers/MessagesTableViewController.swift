//
//  MessagesTableViewController.swift
//  TwitterDM
//
//  Created by Niall Kelly on 17/09/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

import UIKit
import Accounts
import SwifteriOS

class MessagesTableViewController: UITableViewController {
  
  var messages : [JSONValue] = []

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated);
    
    self.setupView()
    
    let isAuthenticated = User.primary() != nil
    if (isAuthenticated == false) {
      self.showAuthenication();
    }
  }
  
  // MARK: - Presentation
  
  func showAuthenication() {
    let sb : UIStoryboard  = UIStoryboard(name: "Main", bundle: nil)
    var authController : AuthenticationViewController = sb.instantiateViewControllerWithIdentifier("AuthenticationViewController") as AuthenticationViewController
    authController.authenticationHandler = { (user: User, error: NSError!) -> Void in
      self.setupView()
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    self.presentViewController(authController, animated: true) {}
  }
  
  // MARK: - Setup
  
  func setupView() {
    let primaryUser : User? = User.primary()
    self.navigationItem.leftBarButtonItem?.enabled = primaryUser != nil
    self.title = primaryUser != nil ? primaryUser?.screenName : "DM"
  }
  
  func fetchMessages() {
    CarpeDM.getDirectMessagesWithResponseHandler { (messages, error) -> Void in
      
      if (error != nil) {
        self.setupView()
        self.showAuthenication();
      }
      else {
        self.messages = messages
        self.tableView.reloadData()
      }
      
      let errorString = error != nil ? error.localizedDescription : "none"
      println("Got \(messages.count) DMs [Error: \(errorString)]")
      println("Messages: \(messages)")
      
      
    }
  }
  
  // MARK: - Actions
  
  @IBAction func logoutAction() {
    self.setupView()
    CarpeDM.clearStoredAccount()
    self.showAuthenication()
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      // #warning Potentially incomplete method implementation.
      // Return the number of sections.
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete method implementation.
      // Return the number of rows in the section.
      return messages.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: nil)
    
    cell.textLabel!.text = messages[indexPath.row]["text"].string
    
    return cell
  }

}
