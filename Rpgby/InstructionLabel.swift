//
//  InstructionLabel.swift
//  Orb
//
//  Created by James Carroll on 3/24/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class InstructionLabel {
  static let kInstance = InstructionLabel()
  
  var mLabels = [SKLabelNode]()
  
  private init() {
    
  }
  
  func createLabels(size: CGSize, texts: String...) {
    var el = HudUi.kHUDs[EndLabel.kIndex].copy() as! SKLabelNode
    let y = HudUi.kOffset.top
    
    el.fontSize = 42
    el.center(size)
    el.zPosition = Spacing.kHUDZIndex
    
    for t in texts {
      el.text = t
      el.position.y = (mLabels.last?.position.y ?? size.height - y) - y
      mLabels.append(el)
      el = el.copy() as! SKLabelNode
    }
  }
}