//
//  Player.swift
//  Rpgby
//
//  Created by James Carroll on 3/2/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import Foundation
import SpriteKit

// Class to handle player sprite
// Singleton because there's only one player.

final class Player: BaseSprite {
  static let kName = "player"
  static let kInstance = Player()
  static let kJumpSfx = SKAction.playSoundFileNamed("sfx-jump.mp3",
    waitForCompletion: false)
  static let kRunTex = Player.setUpRunningTextures()
  
  var mJumping = false
  private var mBaseY: CGFloat = 0
  private var mJumpY: CGFloat!
  
  private init() {
    super.init(imageName: "idle-1")
  }
  
  func beginRunning() {
    self.mSprite.runAction(SKAction.repeatActionForever(SKAction.moveByX(10, y:
      0, duration: 0.05)))
    self.mSprite.runAction(SKAction.repeatActionForever(
        SKAction.animateWithTextures(Player.kRunTex, timePerFrame: 0.03)))
  }
  
  func beginJumping() {
    let x: CGFloat = 10
    
    if !mJumping { // single jump only
      mJumping = true
      mBaseY = self.mSprite.position.y
      self.mSprite.removeAllActions()
      self.mSprite.runAction(Player.kJumpSfx)
      self.mSprite.runAction(SKAction.animateWithTextures([SKTexture(imageNamed:
        "jump_up")], timePerFrame: 0, resize: false, restore: true))
      self.mSprite.physicsBody?.applyImpulse(CGVectorMake(x, mJumpY))
    }
  }
  
  func endJumping() {
    let y = self.mSprite.position.y
    
    if y >= mBaseY + mJumpY {
      self.mSprite.runAction(SKAction.animateWithTextures([SKTexture(imageNamed:
        "jump_fall")], timePerFrame: 0, resize: false, restore: true))
    }
  }
  
  override func createSprite() {
    self.mSprite.scale(0.075)
    self.mSprite.anchorPointX(0)
    self.mSprite.position = CGPointMake(30, 500)
    self.mSprite.physicsBody = SKPhysicsBody(rectangleOfSize: self.mSprite.size)
    self.mSprite.physicsBody?.categoryBitMask = Collision.kPerson
    self.mSprite.physicsBody?.collisionBitMask = Collision.kPlatform
    self.mSprite.physicsBody?.contactTestBitMask = Collision.kOrb
    self.mSprite.physicsBody?.allowsRotation = false
    self.mSprite.name = Player.kName
    self.mSprite.zPosition = Spacing.kPersonOrbZIndex
    
    self.mJumpY = 200 * self.mSprite.physicsBody!.mass
  }
  
  static private func setUpRunningTextures() -> [SKTexture] {
    var texs = [SKTexture]()
    
    for i in 1...6 {
      texs.append(SKTexture(imageNamed: "run-" + i.description))
    }
    
    return texs
  }
}