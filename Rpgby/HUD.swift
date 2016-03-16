//
//  HUD.swift
//  Orb
//
//  Created by James Carroll on 3/10/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

class HudUi: BaseSprite {
  static let kName = "HUD"
  static let kInstance = HudUi()
  static let kHUDs = HudUi.createHUD()
  override var mName: String { return HudUi.kName }
  
  init() {
    super.init(color: UIColor.clearColor(), size: UIScreen.mainScreen().bounds.size)
    
    fInit()
  }
  
  private func fInit() {
    self.mSprite.anchorPointX(0)
    self.mSprite.zPosition = Spacing.kHUDZIndex
    
    (HudUi.kHUDs[MeterLabel.kIndex] as! MeterLabel).setLabelPosition(self
      .mSprite.frame)
  }
  
  static func createHUD() -> [SKNode] {
    let m = MeterLabel.kInstance
    var n = [SKNode]()
    
    n.insert(StartLabel.kInstance, atIndex: StartLabel.kIndex)
    n.insert(EndLabel.kInstance, atIndex: EndLabel.kIndex)
    n.insert(m, atIndex: MeterLabel.kIndex)
    
    for h in n {
      h.createNode()
    }
    
    return n
  }
}
