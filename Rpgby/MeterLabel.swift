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
  var mMultipler = 1.0
  
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
  
  func handleDistance(distance: Int) {
    let d: Int = Int(Double(distance) * mMultipler)
    mDistance += d < 10 ? d : d / 10
    
    let m = mDistance.description + " M"
    self.text = mMultipler == 1 ? m : m + " - " + mMultipler.description + "x"
  }
  
  func increaseMultiper() {
    mMultipler += 0.5
  }
  
  func fInit() {
    super.createNode()
    mDistance = 0
    mMultipler = 1
    handleDistance(0)
    self.removeFromParent()
  }
  
  override func createNode() {
    self.fontColor = UIColor.blackColor()
    self.horizontalAlignmentMode = .Left
  }
}
