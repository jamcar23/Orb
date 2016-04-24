//
//  MenuScene.swift
//  Orb
//
//  Created by James Carroll on 3/19/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class MenuScene: BaseScene {
  static let kTitle = MenuScene.setUpTitle()
  
  // Function init
  
  override func fInit() {
    let t = MenuScene.kTitle
    let p = Play.kInstace
    let c = Credits.kInstace
    let l = Leaderboards.kInstance
    
    self.setUpBackground()
    t.position = CGPointMake(self.getMidX(), self.frame.size.height -
      HudUi.kOffset.top * 2)
    p.setHudPosition(self.frame)
    c.setHudPosition(self.frame)
    l.setHudPosition(self.frame)
    p.userInteractionEnabled = true
    c.userInteractionEnabled = true
    l.userInteractionEnabled = true
    let ar = c.size.width / c.size.height
    c.size = CGSizeMake(p.size.height * ar, p.size.height)
    
    self.addChild(t)
    self.addChild(p)
    self.addChild(c)
    self.addChild(l)
    
    self.userInteractionEnabled = true
  }
  
  // Sets up main title
  
  private static func setUpTitle() -> SKLabelNode {
    let l = SKLabelNode(text: "Orb")
    
    l.fontColor = UIColor.blackColor()
    l.fontSize = 72
    
    return l
  }
}
