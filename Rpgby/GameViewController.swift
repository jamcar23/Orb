//
//  GameViewController.swift
//  Rpgby
//
//  Created by James Carroll on 3/1/16.
//  Copyright (c) 2016 James Carroll. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

final class GameViewController: UIViewController, UINavigationControllerDelegate {
  weak var mGameCenterController: GKGameCenterViewController!
  var mScene: MenuScene!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let gc = GameCenter.kInstance
    
    mGameCenterController = GKGameCenterViewController()
    mGameCenterController.delegate = self
    mGameCenterController.gameCenterDelegate = gc
    
    // Configure the view.
    let skView = self.view as! SKView
//    skView.showsFPS = true
//    skView.showsNodeCount = true
//    skView.showsPhysics = true // creates memory leak
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
    
    /* Set the scale mode to scale to fit the window */
    mScene = MenuScene(size: skView.bounds.size)
    mScene.scaleMode = .ResizeFill
    
    skView.presentScene(mScene)
    
    gc.mDelegate = self
    gc.authenticate()
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
  
  func showGameCenter() {
    showViewController(mGameCenterController)
  }
}
