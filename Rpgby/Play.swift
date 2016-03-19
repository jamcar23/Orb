//
//  Play.swift
//  Orb
//
//  Created by James Carroll on 3/19/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class Play: PlayPause, HUD {
  static let kInstace = Play()
  
  private init() {
    super.init(name: PlayPause.kPlayName)
  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  func setHudPosition(frame: CGRect) {
    self.position = CGPointMake(frame.width / 2, frame.origin.y +
      HudUi.kOffset.top * 2)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let s = self.scene {
      let gs = GameScene(size: s.view!.bounds.size)
      gs.scaleMode = .ResizeFill
      
      s.view?.presentScene(gs, transition: SKTransition.crossFadeWithDuration(2))
    }
  }
}
