//
//  GameScene.swift
//  Rpgby
//
//  Created by James Carroll on 3/1/16.
//  Copyright (c) 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class GameScene: BaseScene, SKPhysicsContactDelegate, Manager, Reset,
PauseDelegate {
  var mCountDown = false
  var mBegin = false
  var mGameOver = false
  var mBackgrounds = [SKSpriteNode]()
  var mPlatforms = [Platform]()
  var mBottomGrass = [SKSpriteNode]()
  var mPreviousPlatform = 0
  var mPreviousBottomGrassPos: CGFloat = 0
  var mPreviousSprite: SKSpriteNode!
  var mPreviousTime: CFTimeInterval?
  let mCamera = SKCameraNode()
  let mScreen = (width: UIScreen.scaleWidth(0.5), height: UIScreen.scaleHeight(0.5))
  
  // Handle jumping
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
    let pl = Player.kInstance
    let hud = HudUi.kInstance.mSprite
    let khud = HudUi.kHUDs
    
    if !mCountDown {
      let il = InstructionLabel.kInstance.mLabels
      mCountDown = true
      
      for i in il {
        i.removeFromParent()
      }
      
      hud.addChild(khud[Pause.kIndex])
      
      if let sl = khud[StartLabel.kIndex] as? StartLabel {
        hud.addChild(sl)
        sl.position = self.getCenterPoint()
        hud.runAction(StartLabel.kCountAct, completion: begin)
      }
    } else if mBegin {
      pl.startJumpTimer()
    } else if mGameOver {
      self.removeAllChildren()
      self.removeAllActions()
      HudUi.kInstance.mSprite.removeAllChildren()
      Physics.kInstance.fInit()
      self.mPlatforms.removeAll()
      self.mBackgrounds.removeAll()
      self.mBegin = false
      self.mCountDown = false
      self.mGameOver = false
      self.mPreviousTime = nil
      self.resume()
      self.fInit()
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let p = Player.kInstance
    
    if mBegin && p.mJumping {
      p.endJumpTimer()
    }
  }
  
  // Handle platform generation
  
  override func didSimulatePhysics() {
    if mPlatforms.count > 0 {
      let pz = mPlatforms[0]
      
      
      if mPreviousSprite.isPast(self.mCamera.frame) && mPlatforms.count < 10 {
        self.createPlatform()
      }
      
//      if mBottomGrass[mBottomGrass.count - 1].isPast(self.mCamera.frame) &&
//        mPlatforms.count < 25 {
//        self.createGrass(true)
//      }
      
      if pz.mSprite.isPast(self.mCamera.frame) {
        pz.mSprite.removeFromParent()
        self.mPlatforms.removeFirst()
      }
      
//      if gz.isPast(self.mCamera.frame) {
////        gz.removeFromParent()
//        self.mBottomGrass.removeFirst()
//      }
    }
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    let p = Player.kInstance
    let hud = HudUi.kInstance.mSprite
    let ml = HudUi.kHUDs[MeterLabel.kIndex] as! MeterLabel
    let phy = Physics.kInstance
    
    if p.mJumping {
      p.endJumping()
    }
    
    if mBegin {
      if !self.paused {
        let x =  phy.mRunSpeed * CGFloat(currentTime - (mPreviousTime ?? currentTime))
        let ix = Int(x)
        p.mSprite.position.x += x
        hud.position.x += x
        mCamera.position.x += x
        ml.mDistance += ix < 10 ? ix : ix / 10
        ml.handleText()
        phy.mVelocityX = x
        
        mCamera.position.y = p.mSprite.position.y > mScreen.height ? p.mSprite.position.y : mScreen.height
        hud.position.y = mCamera.position.y - mScreen.height
      }
      
      mPreviousTime = currentTime
      
      if p.isDead(mCamera.frame, width: mScreen.width) {
        end()
        return
      }
      
      let adv: CGFloat = 400
      let cx = mCamera.position.x
      
      if mBackgrounds.count > 0 {
        let bg = mBackgrounds[0]
        let bg2 = mBackgrounds[1]        
        
        if bg.getMaxX() + adv <=  cx {
          bg.position = setBackgroundPosition(bg2, bg2: bg, adv: adv)
        }
        
        if bg2.getMaxX() + adv <= cx {
          bg2.position = setBackgroundPosition(bg, bg2: bg2, adv: adv)
        }
        
        bg.position.y = mCamera.position.y
        bg2.position.y = mCamera.position.y
      }
    }
  }
  
  func didBeginContact(contact: SKPhysicsContact) {
    var a = contact.bodyA.categoryBitMask
    var b = contact.bodyB.categoryBitMask
    (a, b) = a < b ? (a, b) : (b, a)
    
    switch (a, b) {
    case (Collision.kPlatform, Collision.kPerson): // handle landing
      let p = Player.kInstance
      p.mJumping = false
      
      if mBegin {
        p.beginRunning()
      }
    case (Collision.kPerson, Collision.kOrb): // handle running into orb
      self.runAction(Orb.kCollectSfx)
      OrbCount.kInstance.handleText()
      contact.bodyB.node?.removeFromParent()
    default:
      break
    }
  }
  
  private func setXPosForItemFollowingPlayer(node: SKNode, x: CGFloat) {
    let s = Player.kInstance.mSprite
    
    node.position = CGPointMake(node.position.x + x, s.position.y)
  }
  
  // Things that happen in the beginning
  
  func begin() {
    let pl = Player.kInstance
    let phy = Physics.kInstance
    let w = SKAction.waitForDuration(1)
    let rb = SKAction.runBlock({
      
      if phy.mRunSpeed < Physics.kMaxRunSpeed {
        phy.mRunSpeed *= 1.2
      } else {
        self.removeActionForKey(Player.kTimer)
      }
    })
    
    self.mBegin = true
    pl.beginRunning()
    self.runAction(SKAction.repeatActionForever(SKAction.sequence([w,
      rb])), withKey: Player.kTimer)
  }
  
  // Things that happen in the end
  
  func end() {
    let el = HudUi.kHUDs[EndLabel.kIndex] as! SKLabelNode
    let oc = OrbCount.kInstance
    
    self.runAction(Player.kFallSfx)
    
    el.position = CGPointMake(self.getMidX(), mCamera.getMidY())
    
    if oc.mCount > oc.mNeed {
      el.text = "New High Score!"
      DataManager.setMaxOrbsCollected(oc.mCount)
    } else if oc.mCount == oc.mNeed {
      el.text = "Winner Winner!"
    } else {
      el.text = "Try Again."
    }
    
    HudUi.kInstance.mSprite.addChild(el)
    Player.kInstance.mSprite.removeFromParent()
    Pause.kInstance.removeFromParent()
    self.mBegin = false
    self.mGameOver = true
  }
  
  // Set up background
  
  override func setUpBackground() {
    super.setUpBackground()
    let bg = self.childNodeWithName(BaseScene.kBackground) as! SKSpriteNode
    bg.position = mCamera.position
    
    let bg2 = bg.copy() as! SKSpriteNode
    bg2.name = BaseScene.kBackground + "2"
    bg2.position = setBackgroundPosition(bg, bg2: bg2, adv: 100)
    
    mBackgrounds.append(bg)
    mBackgrounds.append(bg2)
    
    bg.removeFromParent()
    bg2.removeFromParent()
    
    self.addChild(bg)
    self.addChild(bg2)
  }
  
  // Set up main platform and player
  
  private func setUpPlayer() {
    let g = Platform.kAllPlatforms[0]
    let p = Player.kInstance
    
    g.setPosition(nil, size: self.size)
    p.createNode()
    
    mPlatforms.append(g)
    
    p.mSprite.removeFromParent()
    
    self.addChild(p.mSprite)
    self.addChild(mPlatforms.lastSprite())
    self.camera?.position.x = p.mSprite.position.x
  }
  
  // Sets up the orb
  
  private func setUpOre() {
    let o = Orb.kInstance
    
    o.createNode()
    o.setPosition(mPlatforms[0].mSprite)
    
    self.addChild(o.mSprite.copy() as! SKSpriteNode)
  }
  
  // Handles infinite background position
  
  private func setBackgroundPosition(bg: SKSpriteNode, bg2: SKSpriteNode, adv:
    CGFloat) -> CGPoint {
      return CGPointMake(bg.getMaxX() + adv, bg2.position.y)
  }
  
  // Selects the next platform, randomly
  
  private func createPlatform() {
    let n = Platform.nextPlatform(mPreviousPlatform)
    let p: Platform = n.1
    let o = Orb.kInstance
    
    mPreviousPlatform = n.0
    mPreviousSprite = mPlatforms.lastSprite()
    p.setPosition(mPreviousSprite.frame, size: self.size)
    mPlatforms.append(p)
    self.addChild(mPlatforms.lastSprite())
    
    if drand48() <= Orb.kProbablity {
      o.setPosition(p.mSprite)
      self.addChild(o.mSprite.copy() as! SKSpriteNode)
    }
  }
  
  // Selects the next grass, randomly
  
  private func createGrass(setOnBottom: Bool) {
    let g = Grass.kInstance.nextGrass(true)
    
    if setOnBottom {
      g.position = CGPointMake(mPreviousBottomGrassPos, 50)
      mPreviousBottomGrassPos += g.getMaxX()
    }
    mBottomGrass.append(g)
    
    self.addChild(g)
  }
  
  // Sets up HUD elements
  
  private func setUpHUD() {
    let h = HudUi.kInstance
    let hud = h.mSprite
    let kHUDs = HudUi.kHUDs
    h.fInit()
    hud.addChild(kHUDs[MeterLabel.kIndex])
    hud.addChild(kHUDs[OrbCount.kIndex])
    
    self.addChild(hud)
  }
  
  // Handles setting up instructions
  
  private func setUpInstructions() {
    if !DataManager.hasSeenInstructions() {
      let il = InstructionLabel.kInstance
      
      il.createLabels(self.size, texts: "Tap to begin/jump/reset.", "Longer taps "
        + "= higher jumps.", "Collect as many orbs as you can.", "Don't fall off.")
      
      for i in il.mLabels {
        self.addChild(i)
      }
      
      DataManager.kDefaults.setBool(true, forKey: DataManager.kInstruct)
    }
  }
  
  // Single init func to be called from multiple init
  
  override func fInit() {
    self.view?.ignoresSiblingOrder = true
    self.physicsWorld.gravity = CGVectorMake(0, -Physics.kGravity)
    self.physicsWorld.contactDelegate = self
    self.userInteractionEnabled = true
    //    self.shouldEnableEffects = true
    self.camera = mCamera
    self.camera?.center(self.size)
    setUpBackground()
    setUpPlayer()
    setUpOre()
    setUpHUD()
    setUpInstructions()
    self.camera?.position = CGPointMake(mScreen.width, mScreen.height)
    
    for _ in 0...9 {
      createPlatform()
//      createGrass(true)
    }
    
    for _ in 0...14 {
//      createGrass(true)
    }
  }
  
  // MARK - PasswordDelegate
  
  func isScenePaused() -> Bool {
    return self.paused
  }
  
  func pause() {
    self.paused = true
  }
  
  func resume() {
    self.mPreviousTime = nil
    self.paused = false
  }
}
