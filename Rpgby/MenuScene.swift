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
  
  override func fInit() {
    let t = MenuScene.kTitle
    let p = Play.kInstace
    let c = Credits.kInstace
    
    self.setUpBackground()
    t.position = CGPointMake(self.getMidX(), self.frame.size.height -
      HudUi.kOffset.top * 2)
    p.setHudPosition(self.frame)
    c.setHudPosition(self.frame)
    p.userInteractionEnabled = true
    c.userInteractionEnabled = true
    
    c.size = p.size
    
    self.addChild(t)
    self.addChild(p)
    self.addChild(c)
    
    self.userInteractionEnabled = true
  }
  
  private static func setUpTitle() -> SKLabelNode {
    let l = SKLabelNode(text: "Orb")
    
    l.fontColor = UIColor.blackColor()
    l.fontSize = 72
    
    return l
  }
}
