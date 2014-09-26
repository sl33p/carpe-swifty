//
//  AddAccountButton.swift
//  TwitterDM
//
//  Created by Niall Kelly on 18/09/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

import UIKit

class AddAccountButton: UIButton {

  private func _initSetup() {
    self.layer.cornerRadius = 5
    self.layer.borderColor = self.titleColorForState(UIControlState.Normal)?.CGColor
    self.layer.borderWidth = 1
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self._initSetup()
  }
}
