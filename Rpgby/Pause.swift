//
//  Pause.swift
//  Orb
//
//  Created by James Carroll on 3/17/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

// Protocol for scene to implement for proper pausing

protocol PauseDelegate {
  func isScenePaused() -> Bool
  func pause()
  func resume()
}

// Class for managing Pause icon/sprite

final class Pause: PlayPause, HUD, Reset {
  static let kName = "Pause"
  static let kIndex = 3
  static let kInstance = Pause()
  static let kPauseLabel = EndLabel()
  
  override var mName: String { return Pause.kName }
  
  private init() {
    super.init(name: PlayPause.kPauseName)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setHudPosition(frame: CGRect) {
    self.position = CGPointMake(frame.width / 2, frame.size.height - HudUi.kOffset.top * 0.7 )
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let gs = self.scene as? PauseDelegate{
      let t = Pause.kTextures
      let pl = Pause.kPauseLabel
      
      if gs.isScenePaused() {
        gs.resume()
        self.texture = t.textureNamed(Pause.kPauseName)
        pl.removeFromParent()
      } else {
        gs.pause()
        self.texture = t.textureNamed(Pause.kPlayName)
        let plm = Player.kInstance.mSprite
        pl.position = CGPointMake(self.scene!.getMidX() + (plm.position.x - 30),
          self.scene!.getMidY())
        self.scene!.addChild(pl)
      }
    }
  }
  
  func fInit() {
    self.removeFromParent()
  }
  
  override func createNode() {
    let pl = Pause.kPauseLabel
    self.scale(0.8)
    self.userInteractionEnabled = true
    pl.text = "Paused"
    pl.createNode()
  }
}
