//
//  EndLabel.swift
//  Orb
//
//  Created by James Carroll on 3/10/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

// Label to be shown at the end of the game

class EndLabel: BaseLabel {
  static let kName = "StartLabel"
  static let kIndex = 1
  static let kInstance = EndLabel()
  
  override init() {
    super.init(text: "Game Over")
  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  override func createNode() {
    self.fontColor = UIColor.blackColor()
    self.fontSize = 74
  }
}