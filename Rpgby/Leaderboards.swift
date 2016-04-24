//
//  Leaderboards.swift
//  Orb
//
//  Created by James Carroll on 4/21/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class Leaderboards: SKSpriteNode, HUD {
  static let kInstance = Leaderboards()
  
  private init() {
    let t = SKTexture(imageNamed: "Leaderboard")
    super.init(texture: t, color: UIColor.clearColor(), size: t.size())
    fInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fInit()
  }
  
  func setHudPosition(frame: CGRect) {
    self.position = CGPointMake(frame.width / 2 + UIScreen.scaleWidth(0.3), frame.origin.y +
      HudUi.kOffset.top * 2)
  }
  
  func fInit() {
    
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if self.scene != nil {
      let gc = GameCenter.kInstance
      
      if gc.isAuthenticated() {
        gc.showGameCenter()
      } else {
        gc.authenticate()
      }
    }
  }
}
