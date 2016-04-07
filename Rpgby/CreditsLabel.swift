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
  static let kCreditTypes = ["Developed by ", "Visual Artist: ", "Audio Artist: ",
    "Thanks For Playing!"]
  static let kCredits = [["James Carroll"], ["Luis Zuno", "Bevouliin", "Bluce"],
    ["Trevor Lentz", "chasersgaming", "Section 31 -Tech"], [""]]
  static let kInstance = CreditsLabel()
  static let kBackground = CreditsLabel.setUpBackground()
  static let kTimer = CreditsLabel.createTimer()
  
  override var mName: String { return CreditsLabel.kName }
  var mCurrent = (0, 0)
  
  private override init() {
    super.init(text: "")
  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  override func createNode() {
    super.createNode()
    self.mCurrent = (0, 0)
    self.fontColor = UIColor.whiteColor()
    self.fontSize = 42
    self.runAction(CreditsLabel.kTimer)
  }
  
  private static func createTimer() -> SKAction {
    let w = SKAction.waitForDuration(2)
    let r = SKAction.runBlock({
      let s = CreditsLabel.kInstance
      var cur = s.mCurrent
      
      if  cur.0 >= CreditsLabel.kCreditTypes.count {
        s.removeAllActions()
        CreditsLabel.kBackground.removeFromParent()
        s.removeFromParent()
        return
      }
      
      let t = kCreditTypes[cur.0]
      let c = kCredits[cur.0]
      let n = c[cur.1]
      
      s.text = t + n
      
      cur.1 += 1
      
      if cur.1 >= c.count {
        cur.0 += 1
        cur.1 = 0
      }
      
      s.mCurrent = cur
      
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
