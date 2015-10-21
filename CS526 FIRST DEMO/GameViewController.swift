//
//  GameViewController.swift
//  CS526 FIRST DEMO
//
//  Created by User on 9/15/15.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: CGSize(width: 750, height: 1134))// Configure the view.
        let skView = self.view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    // move to setting view
    @IBAction func toMenu(sender: UIButton) {
        let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("settingView") as! SettingView
        self.presentViewController(menuView, animated: false, completion: nil)
    }
//    @IBAction func pause(sender: UIButton) {
//        self.view.paused = !self.view.paused;
//    }
}
