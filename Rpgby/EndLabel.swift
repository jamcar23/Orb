//
//  EndLabel.swift
//  Orb
//
//  Created by James Carroll on 3/10/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

class EndLabel: BaseLabel {
  static let kName = "StartLabel"
  static let kIndex = 1
  static let kInstance = EndLabel()
  
  private init() {
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