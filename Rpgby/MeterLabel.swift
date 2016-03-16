//
//  MeterLabel.swift
//  Orb
//
//  Created by James Carroll on 3/16/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class MeterLabel: BaseLabel {
  static let kName = "MeterLabel"
  static let kIndex = 2
  static let kInstance = MeterLabel()
  
  var mDistance = 0
  
  private init() {
    super.init(text: "0 M")
    self.createNode()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.createNode()
  }
  
  func setLabelPosition(frame: CGRect) {
    self.position = CGPointMake(frame.origin.x + 15, frame.size.height - 40)
  }
  
  func handleText() {
    self.text = mDistance.description + " M"
  }
  
  override func createNode() {
    self.fontColor = UIColor.blackColor()
    self.horizontalAlignmentMode = .Left
  }
}
