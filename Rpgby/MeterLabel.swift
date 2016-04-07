//
//  MeterLabel.swift
//  Orb
//
//  Created by James Carroll on 3/16/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

// Class that manage distance ran HUD element

final class MeterLabel: BaseLabel, Reset, HUD {
  static let kName = "MeterLabel"
  static let kIndex = 2
  static let kInstance = MeterLabel()
  
  var mDistance = 0
  
  private override init() {
    super.init(text: "0 M")
    self.createNode()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.createNode()
  }
  
  func setHudPosition(frame: CGRect) {
    let o = HudUi.kOffset
    self.position = CGPointMake(frame.origin.x + o.sides, frame.size.height - o.top)
  }
  
  func handleText() {
    self.text = mDistance.description + " M"
  }
  
  func fInit() {
    super.createNode()
    mDistance = 0
    handleText()
    self.removeFromParent()
  }
  
  override func createNode() {
    self.fontColor = UIColor.blackColor()
    self.horizontalAlignmentMode = .Left
  }
}
