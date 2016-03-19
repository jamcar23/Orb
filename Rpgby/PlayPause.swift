//
//  PlayPause.swift
//  Orb
//
//  Created by James Carroll on 3/19/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

class PlayPause: SKSpriteNode {
  static let kTextures = SKTextureAtlas(named: "playPause")
  static let kPauseName = "ic_pause_48pt"
  static let kPlayName = "ic_play_48pt"
  
  init(name: String) {
    let t = PlayPause.kTextures.textureNamed(name)
    super.init(texture: t, color: UIColor.clearColor(), size: t.size())
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
