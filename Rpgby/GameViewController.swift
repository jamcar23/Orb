//
//  GameViewController.swift
//  Rpgby
//
//  Created by James Carroll on 3/1/16.
//  Copyright (c) 2016 James Carroll. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
  var mScene: GameScene!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Configure the view.
    let skView = self.view as! SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.showsPhysics = true
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
    
    /* Set the scale mode to scale to fit the window */
    mScene = GameScene(size: skView.bounds.size)
    mScene.scaleMode = .ResizeFill
    
    skView.presentScene(mScene)
  }
  
  override func shouldAutorotate() -> Bool {
    return true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
