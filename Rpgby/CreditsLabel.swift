//
//  CreditsLabel.swift
//  Orb
//
//  Created by James Carroll on 3/21/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class CreditsLabel: BaseLabel {
  static let kName = "CreditsLabel"
  static let kCredits = [
    "Developed by James Carroll",
    "Visual Artist:\n\n",
    "Audio Artist:\n\n"
  ]
  static let kInstance = CreditsLabel()
  static let kBackground = CreditsLabel.setUpBackground()
  static let kTimer = CreditsLabel.createTimer()
  
  override var mName: String { return CreditsLabel.kName }
  var mCurrent = 0
  
  private override init() {
    super.init(text: "")
  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  override func createNode() {
    self.mCurrent = 0
    self.fontColor = UIColor.whiteColor()
    self.fontSize = 42
    self.zPosition = 10
    self.runAction(CreditsLabel.kTimer)
  }
  
  private static func createTimer() -> SKAction {
    let w = SKAction.waitForDuration(2)
    let r = SKAction.runBlock({
      let s = CreditsLabel.kInstance
      
      if s.mCurrent >= CreditsLabel.kCredits.count {
        s.removeAllActions()
        CreditsLabel.kBackground.removeFromParent()
        s.removeFromParent()
        return
      }
      
      s.text = CreditsLabel.kCredits[s.mCurrent]
      
      ++s.mCurrent
    })
    
    return SKAction.repeatActionForever(SKAction.sequence([r, w]))
  }
  
  private static func setUpBackground() -> SKSpriteNode {
    let bg = SKSpriteNode()
    bg.zPosition = 0
    bg.color = UIColor.blackColor()
    bg.size = UIScreen.mainScreen().bounds.size
    
    return bg
  }
}
