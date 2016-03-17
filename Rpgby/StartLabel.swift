//
//  StartLabel.swift
//  Orb
//
//  Created by James Carroll on 3/10/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class StartLabel: BaseLabel, Manager, Reset {
  static let kName = "StartLabel"
  static let kIndex = 0
  static let kInstance = StartLabel()
  static let kCountAct = StartLabel.createCountAction()
  static let kCountSfxA = SKAction.playSoundFileNamed("sfx-countdown-a.mp3",
    waitForCompletion: false)
  static let kCountSfxB = SKAction.playSoundFileNamed("sfx-countdown-b.mp3",
    waitForCompletion: false)

  override var mName: String { return StartLabel.kName }
  var mCount = 3
  
  private override init() {
    super.init(text: mCount.description)
    self.createNode()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.createNode()
  }
  
  func begin() {
    self.runAction(StartLabel.kCountAct)
  }
  
  func end() {
    return
  }
  
  func fInit() {
    createNode()
    mCount = 3
  }
  
  override func createNode() {
    self.fontColor = UIColor.blackColor()
    self.fontSize = 128
  }
  
  static func createCountAction() -> SKAction {
    let sl = StartLabel.kInstance
    let w = SKAction.waitForDuration(1)
    let r = SKAction.runBlock({
      if sl.mCount >= 1 {
        sl.text = sl.mCount.description
        sl.runAction(StartLabel.kCountSfxA)
      } else if sl.mCount == 0 {
        sl.text = "Go!"
        sl.runAction(StartLabel.kCountSfxB)
      } else {
        sl.removeAllActions()
        sl.removeFromParent()
      }
      
      --sl.mCount
    })
    let seq = SKAction.sequence([r, w])
    var seqs = [SKAction]()
    
    for i in -1...sl.mCount {
      seqs.append(i < sl.mCount ? seq : r)
    }
    
    return SKAction.sequence(seqs)
  }
}
