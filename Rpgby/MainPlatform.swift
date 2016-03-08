//
//  MainPlatform.swift
//  Rpgby
//
//  Created by James Carroll on 3/2/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import Foundation
import SpriteKit

// Class for the main platform (the one you start on)

final class MainPlatform: Platform {
  static let kName = "mainPlatform"
  
  init() {
    super.init(imageName: "mainTile")
  }
  
  override func createSprite() {
    self.mSprite.scale(0.7)
    self.mSprite.anchorPointX(0)
    self.mSprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.mSprite.size.width * 1.8, self.mSprite.size.height - 160))
    self.mSprite.name = MainPlatform.kName
    self.setSharedProperties()
  }
}