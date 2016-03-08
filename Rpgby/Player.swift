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
  static let kMovement: CGFloat = 10
  static let kInstance = Player()
  static let kRunTex = Player.setUpRunningTextures()
  static let kJumpSfx = SKAction.playSoundFileNamed("sfx-jump.mp3",
    waitForCompletion: false)
  static let kRunAni = SKAction.animateWithTextures(Player.kRunTex,
    timePerFrame: 0.03)
  static let kJumpUpAni = SKAction.animateWithTextures([SKTexture(imageNamed:
    "jump_up")], timePerFrame: 0, resize: false, restore: true)
  static let kJumpDownAni = SKAction.animateWithTextures([SKTexture(imageNamed:
    "jump_fall")], timePerFrame: 0, resize: false, restore: true)
  
  var mJumping = false
  private var mBaseY: CGFloat = 0
  private var mJumpY: CGFloat!
  
  private init() {
    super.init(imageName: "idle-1")
  }
  
  // Starts the running animation
  
  func beginRunning() {
    self.mSprite.runAction(SKAction.repeatActionForever(Player.kRunAni))
  }
  
  // Handles jumping animation and movement
  
  func beginJumping() {
    let phy = self.mSprite.physicsBody
    
    if !mJumping { // single jump only
      mJumping = true
      mBaseY = self.mSprite.position.y
      self.mSprite.removeAllActions()
      self.mSprite.runAction(Player.kJumpSfx)
      self.mSprite.runAction(Player.kJumpUpAni)
      phy?.applyImpulse(CGVectorMake(phy!.velocity.dx , mJumpY))
    }
  }
  
  // Handles falling animation
  
  func endJumping() {
    let y = self.mSprite.position.y
    
    if y >= mBaseY + mJumpY {
      self.mSprite.runAction(Player.kJumpDownAni)
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