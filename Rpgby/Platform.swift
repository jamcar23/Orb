//
//  Platform.swift
//  Orb
//
//  Created by James Carroll on 3/8/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import UIKit

// Code all platforms share

class Platform: BaseSprite {
  var mBottom = true
  
  // Handle setting up everything platforms share
  
  func setSharedProperties() {
    self.mSprite.physicsBody?.dynamic = false
    self.mSprite.physicsBody?.restitution = 0
    self.mSprite.physicsBody?.affectedByGravity = false
    self.mSprite.physicsBody?.friction = 0.75
    self.mSprite.physicsBody?.categoryBitMask = Collision.kPlatform
    self.mSprite.physicsBody?.collisionBitMask = Collision.kOrb
    self.mSprite.physicsBody?.contactTestBitMask = Collision.kPerson
    
    self.mSprite.zPosition = Spacing.kPlatformZIndex
  }
  
  // Set a random elevation between the screen height and the point where 
  // the sprite touches the bottom
  
  private func randomElevation() {
    let s = self.mSprite
    s.position.y = CGFloat(arc4random_uniform(UInt32((s.scene?.frame.height)!))) + s.halfHeight()
  }
  
  // Set a random distance to jump within a certain margin
  
  private func randomDistance(previous: CGFloat) {
    let b = previous + Player.kMovement
    let m = b * 0.05
    self.mSprite.position.x = CGFloat(arc4random_uniform(UInt32(b + m))) + (b + -m)
  }
  
  func setPosition(previous: CGFloat) {
    if previous != -1 {
      randomDistance(previous)
    }
    
    mBottom ? self.mSprite.bottom() : randomElevation()
  }
  
}
