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

final class MainPlatform: BaseSprite {
  static let kName = "mainPlatform"
  
  init() {
    super.init(imageName: "mainTile")
  }
  
  override func createSprite() {
    self.mSprite.scale(0.7)
    self.mSprite.bottom()
    self.mSprite.anchorPointX(0)
    self.mSprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.mSprite.size.width * 1.8, self.mSprite.size.height - 160))
    self.mSprite.physicsBody?.dynamic = false
    self.mSprite.physicsBody?.restitution = 0
    self.mSprite.physicsBody?.affectedByGravity = false
    self.mSprite.physicsBody?.friction = 0.75
    self.mSprite.physicsBody?.categoryBitMask = Collision.kPlatform
    self.mSprite.physicsBody?.collisionBitMask = Collision.kOrb
    self.mSprite.physicsBody?.contactTestBitMask = Collision.kPerson
    self.mSprite.name = MainPlatform.kName
    self.mSprite.zPosition = Spacing.kPlatformZIndex
  }
}