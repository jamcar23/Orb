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
  static let kJumpTimer = "jumpTimer"
  static let kInstance = Player()
  static let kRunTex = SKTextureAtlas(named: "running")
  static let kJumpTex = SKTextureAtlas(named: "jump")
  static let kJumpSfx = SKAction.playSoundFileNamed("sfx-jump.mp3",
    waitForCompletion: false)
  static let kFallSfx = SKAction.playSoundFileNamed("sfx-fall.mp3",
    waitForCompletion: false)
  
  var mJumping = false
  var mCounting = false
  var mMovement: CGFloat = 2
  var mVelocity: CGFloat = 1.2
  var mRunAni: SKAction!
  var mJumpUpAni: SKAction!
  var mJumpDownAni: SKAction!
  var mJumpTimeAct: SKAction!
  private var mBaseY: CGFloat = 0
  var mJumpY: CGFloat = 0
  var mTime: CGFloat = 0.001
  
  private init() {
    super.init(texture: SKTexture(imageNamed: "idle-1"))
    Player.kRunTex.preloadWithCompletionHandler({
      self.mRunAni = SKAction.animateWithTextures(Player.kRunTex.toTextures(),
        timePerFrame: 0.06)
    })
    
    Player.kJumpTex.preloadWithCompletionHandler({
      let texs = Player.kJumpTex.toTextures()
      
      self.mJumpUpAni = SKAction.animateWithTextures([texs[1]], timePerFrame: 0,
        resize: false, restore: false)
      self.mJumpDownAni = SKAction.animateWithTextures([texs[0]], timePerFrame:
        0, resize: false, restore: false)
    })
    
    self.mJumpTimeAct = createJumpTimerAction()
  }
  
  // Starts the running animation
  
  func beginRunning() {
    self.mSprite.runAction(SKAction.repeatActionForever(mRunAni))
  }
  
  func startJumpTimer() {
    let s = self.mSprite
    
    if !mJumping { // single jump only
      mJumping = true
      mBaseY = s.position.y
      self.mTime = 1
      s.runAction(mJumpTimeAct, withKey: Player.kJumpTimer)
      self.mCounting = true
    }
  }
  
  // Handles jumping animation and movement
  
  func beginJumping() {
    let s = self.mSprite
    let phy = Physics.kInstance
    let phyBody = s.physicsBody
    let t = phy.calcTime(self.mTime)
    
    if mJumping && mCounting {
      mCounting = false
      s.removeAllActions()
      s.runAction(Player.kJumpSfx)
      s.runAction(mJumpUpAni)
//      let x = phy.calcXDistance(45, time: t)
      mJumpY = phy.calcYDistance(45, time: t)
      phyBody?.applyImpulse(CGVectorMake(0, mJumpY + 5))
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
  
  func endJumpTimer() {
    self.mSprite.removeActionForKey(Player.kJumpTimer)
    beginJumping()
  }
  
  // Checks if the player is off the screen
  
  func isDead(frame: CGRect) -> Bool {
    let s = self.mSprite
    let x = s.getMaxX()
    let y = s.getMidY()
    
    return x <= frame.origin.x || y <= 0
  }
  
  private func createJumpTimerAction() -> SKAction {
    let wt: CGFloat = 0.15
    let w = SKAction.waitForDuration(0.01)
    let t = SKAction.runBlock({
      if self.mTime < Physics.kMaxJumpTime {
        self.mTime += wt
      } else {
        self.endJumpTimer()
      }
      
      print(self.mTime)
    })
    
    return SKAction.repeatActionForever(SKAction.sequence([t, w]))
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
    
    Physics.kInstance.mVelocityY = 200 * s.physicsBody!.mass
  }
}