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
  static let kTimer = "timer"
  static let kInstance = Player()
  static let kRunTex = SKTextureAtlas(named: "running")
  static let kJumpTex = SKTextureAtlas(named: "jump")
  static let kJumpSfx = SKAction.playSoundFileNamed("sfx-jump.mp3",
    waitForCompletion: false)
  static let kFallSfx = SKAction.playSoundFileNamed("sfx-fall.mp3",
    waitForCompletion: false)
  
  var mJumping = false
  var mMovement: CGFloat = 2
  var mVelocity: CGFloat = 1.2
  var mRunAni: SKAction!
  var mJumpUpAni: SKAction!
  var mJumpDownAni: SKAction!
  private var mBaseY: CGFloat = 0
  private var mJumpY: CGFloat!
  
  private init() {
    super.init(texture: SKTexture(imageNamed: "idle-1"))
    Player.kRunTex.preloadWithCompletionHandler({
      self.mRunAni = SKAction.animateWithTextures(Player.kRunTex.toTextures(),
        timePerFrame: 0.06)
    })
    
    Player.kJumpTex.preloadWithCompletionHandler({
      let texs = Player.kJumpTex.toTextures()
      
      self.mJumpUpAni = SKAction.animateWithTextures([texs[1]], timePerFrame: 0,
        resize: false, restore: true)
      self.mJumpDownAni = SKAction.animateWithTextures([texs[0]], timePerFrame:
        0, resize: false, restore: true)
    })
  }
  
  // Starts the running animation
  
  func beginRunning() {
    self.mSprite.runAction(SKAction.repeatActionForever(mRunAni))
  }
  
  // Handles jumping animation and movement
  
  func beginJumping() {
    let s = self.mSprite
    let phy = s.physicsBody
    
    if !mJumping { // single jump only
      mJumping = true
      mBaseY = s.position.y
      s.removeAllActions()
      s.runAction(Player.kJumpSfx)
      s.runAction(mJumpUpAni)
      phy?.applyImpulse(CGVectorMake(phy!.velocity.dx, mJumpY))
    }
  }
  
  // Handles falling animation
  
  func endJumping() {
    let s = self.mSprite
    let y = s.position.y
    
    if y >= mBaseY + mJumpY {
      s.runAction(mJumpDownAni)
    }
  }
  
  // Checks if the player is off the screen
  
  func isDead(frame: CGRect) -> Bool {
    let s = self.mSprite
    let x = s.getMaxX()
    let y = s.getMidY()
    
    return x <= frame.origin.x || y <= 0
  }
  
  override func createNode() {
    let s = self.mSprite
    
    s.scale(0.075)
    s.anchorPointX(0)
    s.position = CGPointMake(30, 142)
    s.physicsBody = SKPhysicsBody(rectangleOfSize: s.size)
    s.physicsBody?.categoryBitMask = Collision.kPerson
    s.physicsBody?.collisionBitMask = Collision.kPlatform
    s.physicsBody?.contactTestBitMask = Collision.kOrb
    s.physicsBody?.allowsRotation = false
    s.physicsBody?.velocity.dx = 1.2
    s.name = Player.kName
    s.zPosition = Spacing.kPersonOrbZIndex
    
    self.mJumpY = 400 * s.physicsBody!.mass
  }
}