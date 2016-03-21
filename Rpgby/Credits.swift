//
//  Credits.swift
//  Orb
//
//  Created by James Carroll on 3/21/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class Credits: SKSpriteNode, HUD {
  static let kInstace = Credits()
  static let kBackground = SKSpriteNode()
  
  private init() {
    let t = SKTexture(imageNamed: "ic_info_outline")
    super.init(texture: t, color: UIColor.clearColor(), size: t.size())
    fInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fInit()
  }
  
  func setHudPosition(frame: CGRect) {
    self.position = CGPointMake(frame.width / 2 + 21, frame.origin.y +
      HudUi.kOffset.top * 2)
  }
  
  func fInit() {
    let bg = Credits.kBackground
    
    bg.color = UIColor.blackColor()
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let s = self.scene {
      let c = CreditsLabel.kInstance
      let bg = CreditsLabel.kBackground
      
      c.createNode()
      bg.center(s.size)
      c.center(bg.size)
      s.addChild(bg)
      s.addChild(c)
    }
  }
}

