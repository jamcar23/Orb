
//
//  BaseScene.swift
//  Orb
//
//  Created by James Carroll on 3/19/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

class BaseScene: SKScene {
  static let kBackground = "Background_cloud"
  
  override init(size: CGSize) {
    super.init(size: size)
    self.size = size
    
    fInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fInit()
  }
  
  func setUpBackground() {
    let bg = SKSpriteNode(imageNamed: BaseScene.kBackground)
    bg.center(self.size)
    bg.size.height = self.size.height
    bg.name = BaseScene.kBackground
    bg.zPosition = Spacing.kBackgroundZIndex
    
    self.addChild(bg)
  }
  
  func fInit() {
    return
  }
}
