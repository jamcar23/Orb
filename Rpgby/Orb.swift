//
//  Orb.swift
//  Rpgby
//
//  Created by James Carroll on 3/2/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import UIKit
import SpriteKit

// Class to handle orb sprites

final class Orb: BaseSprite {
  static let kName = "orb"
  static let kRed = "orb-red"
  static let kBlue = "orb-blue"
  static let kCollectSfx = SKAction.playSoundFileNamed("Coin.mp3",
    waitForCompletion: false)
  
  override func createSprite() {
    self.mSprite.anchorPointX(0)
    self.mSprite.scale(0.035)
    self.mSprite.physicsBody = SKPhysicsBody(circleOfRadius: self.mSprite.size.width / 2)
    self.mSprite.physicsBody?.categoryBitMask = Collision.kOrb
    self.mSprite.physicsBody?.collisionBitMask = Collision.kPlatform
    self.mSprite.physicsBody?.contactTestBitMask = Collision.kPerson
    self.mSprite.physicsBody?.restitution = 0.7
    self.mSprite.name = Orb.kName
    self.mSprite.zPosition = Spacing.kPersonOrbZIndex
  }
  
  func setPosition(maxX: CGFloat) {
    self.mSprite.position = CGPointMake(maxX - 100, 500)
  }
}