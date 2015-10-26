//
//  SpecialViewController.swift
//  CS526 FIRST DEMO
//
//  Created by User on 10/13/15.
//  Copyright © 2015 User. All rights reserved.
//

import UIKit
import SpriteKit

class SpecialViewController: UIViewController {
    var totalscore = String()
    var index = Int(0)
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameSceneSpecial(size: CGSize(width: 750, height: 1134))// Configure the view.
        let skView = self.view as! SKView
        //        skView.showsFPS = true
        //        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }

    @IBAction func specialToMenu(sender: UIButton) {
        let menuV = self.storyboard?.instantiateViewControllerWithIdentifier("settingView") as! SettingView
        self.presentViewController(menuV, animated: false, completion: nil)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func test(score: String, mode: Int) {
        totalscore = score
        index = mode
        performSegueWithIdentifier("test", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "test") {
            let svc: GameOverViewController = segue.destinationViewController as! GameOverViewController
            svc.toPass = totalscore
            svc.modeIndex = index
        }
    }

}
