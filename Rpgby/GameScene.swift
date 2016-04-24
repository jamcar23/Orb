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
      
      
      if mPreviousSprite.isPast(self.mCamera.frame) && mPlatforms.count < 20 {
        self.handlePlatforms()
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
        p.movePlayer(x)
        hud.position.x += x
        mCamera.position.x += x
        ml.handleDistance(ix)
        phy.mVelocityX = x
        
        mCamera.position.y = p.mSprite.position.y > mScreen.height ? p.mSprite.position.y : mScreen.height
        hud.position.y = mCamera.position.y - mScreen.height
        
        if p.mTeleportPos != 0 && p.mTeleportPos <= p.mSprite.position.x {
          p.reappear()
        }
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
    let p = Player.kInstance
    var a = contact.bodyA.categoryBitMask
    var b = contact.bodyB.categoryBitMask
    (a, b) = a < b ? (a, b) : (b, a)
    
    switch (a, b) {
    case (Collision.kPlatform, Collision.kPerson): // handle landing
      p.mJumping = false
      
      if mBegin {
        p.beginRunning()
      }
    case (Collision.kPerson, Collision.kOrb): // handle running into orb
      self.runAction(Orb.kCollectSfx)
      OrbCount.kInstance.handleText()
      contact.bodyB.node?.removeFromParent()
    case (Collision.kPerson, Collision.kTeleport): // handle running into teleport
      p.teleport()
    case (Collision.kPerson, Collision.kWing): // handle running into wing
      var w: SKSpriteNode?
      
      w = (contact.bodyA.node?.name == Wings.kName ? contact.bodyA.node :
        contact.bodyB.node) as? SKSpriteNode
      
      p.addWings(w)
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
    let dm = MeterLabel.kInstance.mDistance
    
    self.runAction(Player.kFallSfx)
    
    el.position = CGPointMake(self.getMidX(), mCamera.getMidY())
    
    if oc.mCount > oc.mNeed  {
      el.text = "New High Score!"
      DataManager.setMaxOrbsCollected(oc.mCount)
      GameCenter.kInstance.postScores()
    } else if oc.mCount == oc.mNeed {
      el.text = "Winner Winner!"
    } else {
      el.text = "Try Again."
    }
    
    
    if dm > DataManager.getMaxDistanceRan() {
      DataManager.setMaxDistanceRand(dm)
      GameCenter.kInstance.postScores()
      el.text = "New Distance!"
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
    let o = Item.kItems[Orb.kIndex]
    
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
    var i: Item?
    
    mPreviousPlatform = n.0
    mPreviousSprite = mPlatforms.lastSprite()
    p.setPosition(mPreviousSprite.frame, size: self.size)
    mPlatforms.append(p)
    self.addChild(mPlatforms.lastSprite())
    
    let r = drand48()
    
    switch r {
    case Orb.kProbRange.0..<Orb.kProbRange.1:
      i = Item.kItems[Orb.kIndex]
    case Wings.kProbRange.0..<Wings.kProbRange.1:
      i = Item.kItems[Wings.kIndex]
    case Teleport.kProbRange.0..<Teleport.kProbRange.1:
      i = Item.kItems[Teleport.kIndex]
    default:
      i = nil
    }
    
    if let i = i {
      i.setPosition(p.mSprite)
      self.addChild(i.mSprite.copy() as! SKSpriteNode)
    }
  }
  
  private func handlePlatforms() {
    while mPlatforms.count < 20 {
      createPlatform()
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
    
    handlePlatforms()
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
