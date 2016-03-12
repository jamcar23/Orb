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
  static let kTextures = SKTextureAtlas(named: "orb")
  static let kRed = "red"
  static let kBlue = "blue"
  static let kCollectSfx = SKAction.playSoundFileNamed("Coin.mp3",
    waitForCompletion: false)
  
  override func createNode() {
    let s = self.mSprite
    
    s.anchorPointX(0)
    s.scale(0.035)
    s.physicsBody = SKPhysicsBody(circleOfRadius: s.size.width / 2)
    s.physicsBody?.categoryBitMask = Collision.kOrb
    s.physicsBody?.collisionBitMask = Collision.kPlatform
    s.physicsBody?.contactTestBitMask = Collision.kPerson
    s.physicsBody?.restitution = 0.2
    s.name = Orb.kName
    s.zPosition = Spacing.kPersonOrbZIndex
  }
  
  func setPosition(maxX: CGFloat) {
    self.mSprite.position = CGPointMake(maxX - 100, 142)
  }
}