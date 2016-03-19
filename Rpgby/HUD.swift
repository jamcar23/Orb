//
//  HUD.swift
//  Orb
//
//  Created by James Carroll on 3/10/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

// Protocol for HUD elements that need to have things set dynamically

protocol HUD {
  func setHudPosition(frame: CGRect)
}

// Class to manage the HUD node

final class HudUi: BaseSprite, Reset {
  static let kName = "HUD"
  static let kInstance = HudUi()
  static let kHUDs = HudUi.createHUD()
  static let kOffset: (sides: CGFloat, top: CGFloat) = (sides: 15, top: 40)
  static let kBlurFilter = CIFilter(name: "CIGaussianBlur")
  override var mName: String { return HudUi.kName }
  
  init() {
    super.init(color: UIColor.clearColor(), size: UIScreen.mainScreen().bounds.size)
    
    fInit()
  }
  
  // func init
  
  func fInit() {
    self.mSprite.removeFromParent()
    self.mSprite.anchorPointX(0)
    self.mSprite.zPosition = Spacing.kHUDZIndex
    self.mSprite.position = self.mSprite.anchorPoint
    
    for hud in HudUi.kHUDs {
      if let h = hud as? Reset {
        h.fInit()
      }
      
      if let h = hud as? HUD {
        h.setHudPosition(self.mSprite.frame)
      }
    }
  }
  
  // Creates each HUD element
  
  static func createHUD() -> [SKNode] {
    var n = [SKNode]()
    
    n.insert(StartLabel.kInstance, atIndex: StartLabel.kIndex)
    n.insert(EndLabel.kInstance, atIndex: EndLabel.kIndex)
    n.insert(MeterLabel.kInstance, atIndex: MeterLabel.kIndex)
    n.insert(Pause.kInstance, atIndex: Pause.kIndex)
    n.insert(OrbCount.kInstance, atIndex: OrbCount.kIndex)
    
    for h in n {
      h.createNode()
    }
    
    return n
  }
}
