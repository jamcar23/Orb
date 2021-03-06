//
//  SKProtocol.swift
//  Rpgby
//
//  Created by James Carroll on 3/2/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

// Protocol for helper methods for SKNode
// See SKExtension.swift for implementation

protocol XY {
  func getMaxY() -> CGFloat
  func getMidY() -> CGFloat
  func getMinY() -> CGFloat
  func getMaxX() -> CGFloat
  func getMidX() -> CGFloat
  func getMinX() -> CGFloat
  func getCenterPoint() -> CGPoint
}

protocol Node: XY {
  var mName: String { get }
  func createNode()
}

protocol Reset {
  func fInit()
}