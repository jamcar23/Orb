//
//  Platform.swift
//  Orb
//
//  Created by James Carroll on 3/8/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import UIKit

// Protocol for getting max/min XY coords

protocol GetXY {
  func getMaxY() -> CGFloat
  func getMinY() -> CGFloat
  func getMaxX() -> CGFloat
  func getMinX() -> CGFloat
}

// Code all platforms share

class Platform: BaseSprite, GetXY {
  static let kAllPlatforms = Platform.createPlatforms()
  override var mName: String { return "Platform" }
  var mBottom = true
  
  // Handle setting up everything platforms share
  
  func setSharedProperties() {
    self.mSprite.physicsBody?.dynamic = false
    self.mSprite.physicsBody?.restitution = 0
    self.mSprite.physicsBody?.affectedByGravity = false
    self.mSprite.physicsBody?.friction = 0.75
    self.mSprite.physicsBody?.categoryBitMask = Collision.kPlatform
    self.mSprite.physicsBody?.collisionBitMask = Collision.kOrb | Collision.kPlatform
    self.mSprite.physicsBody?.contactTestBitMask = Collision.kPerson
    
    self.mSprite.zPosition = Spacing.kPlatformZIndex
    self.mSprite.anchorPoint.x = 0
  }
  
  // Set a random elevation between the screen height and the point where 
  // the sprite touches the bottom
  
  private func randomElevation() {
    let s = self.mSprite
    let y = CGFloat(arc4random_uniform(UInt32((s.scene?.frame.height) ??
      0))) + s.halfHeight()
    s.position.y = y
  }
  
  // Set a random distance to jump within a certain margin
  
  private func randomDistance(previous: CGFloat) {
    let b = Player.kMovement + self.mSprite.size.width 
    let m = b * 0.05
    let u = previous + b + m
    let l = previous + -m
    let x = CGFloat(arc4random_uniform(UInt32(u - l))) + l
    self.mSprite.position.x = x
  }
  
  func setPosition(previous: CGFloat) {
    if previous != -1 {
      randomDistance(previous)
    }
    
    mBottom ? self.mSprite.bottom() : randomElevation()
  }
  
  // MARK: - GetXY
  
  func getMaxX() -> CGFloat {
    return self.mSprite.getMaxX()
  }
  
  func getMaxY() -> CGFloat {
    return self.mSprite.getMaxY()
  }
  
  func getMinX() -> CGFloat {
    return self.mSprite.getMinX()
  }
  
  func getMinY() -> CGFloat {
    return self.mSprite.getMinY()
  }
  
  // MARK: - Static methods
  
  static func createPlatforms() -> [Platform] {
    var all = [Platform]()
    
    all.append(MainPlatform())
    all.append(LargePlatform())
    
    for a in all {
      a.createSprite()
    }
    
    return all
  }
  
  static func nextPlatform(pervious: Int) -> (Int, Platform) {
    var r = 0
    
    while r == pervious {
      r = Int(arc4random_uniform(UInt32(Platform.kAllPlatforms.count)))
    }
    
    return (r, Platform.kAllPlatforms[r])
  }
  
}
