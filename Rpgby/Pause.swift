//
//  Pause.swift
//  Orb
//
//  Created by James Carroll on 3/17/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

protocol PauseDelegate {
  func isScenePaused() -> Bool
  func pause()
  func resume()
}

final class Pause: SKSpriteNode, HUD {
  static let kName = "Pause"
  static let kIndex = 3
  static let kTextures = SKTextureAtlas(named: "playPause")
  static let kPauseName = "ic_pause_48pt"
  static let kPlayName = "ic_play_48pt"
  static let kInstance = Pause()
  static let kPauseLabel = EndLabel()
  
  override var mName: String { return Pause.kName }
  
  private init() {
    let t = Pause.kTextures.textureNamed(Pause.kPauseName)
    super.init(texture: t, color: UIColor.clearColor(), size: t.size())
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
  
  override func createNode() {
    let pl = Pause.kPauseLabel
    self.scale(0.8)
    self.userInteractionEnabled = true
    pl.text = "Paused"
    pl.createNode()
  }
}
