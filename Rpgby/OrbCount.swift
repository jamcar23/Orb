//
//  OrbCount.swift
//  Orb
//
//  Created by James Carroll on 3/17/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

// Class to manage orb count HUD element

final class OrbCount: SKNode, HUD, Reset {
  static let kIndex = 4
  static let kInstance = OrbCount()
  static let kLabel = SKLabelNode()
  static let kDefaultNeed = 3
  
  var mCount = -1
  var mNeed = OrbCount.kDefaultNeed
  
  private override init() {
    super.init()
    handleNeedAmount()
  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  
  func setHudPosition(frame: CGRect) {
    let o = HudUi.kOffset
    self.position = CGPointMake(frame.size.width - o.sides, frame.size.height - o.top)
  }
  
  private func handleNeedAmount() {
    let m = DataManager.getMaxOrbsCollected()
    mNeed = m >= OrbCount.kDefaultNeed ? m : OrbCount.kDefaultNeed
  }
  
  func handleText() {
    mCount += 1
    OrbCount.kLabel.text = mCount.description + "/" + mNeed.description + " Orbs"
  }
  
  func fInit() {
    mCount = -1
    handleNeedAmount()
    handleText()
    self.removeFromParent()
  }
  
  override func createNode() {
    let l = OrbCount.kLabel
    
    handleText()
    l.horizontalAlignmentMode = .Right
    l.fontColor = UIColor.blackColor()
    
    self.addChild(l)
  }
}
