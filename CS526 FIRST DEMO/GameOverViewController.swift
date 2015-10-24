//
//  GameOverViewController.swift
//  CS526 FIRST DEMO
//
//  Created by User on 10/20/15.
//  Copyright © 2015 User. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverViewController: UIViewController {
    @IBOutlet weak var score: UILabel!
    var toPass: String = ""
    var modeIndex = Int(0)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let scene = GameOverScene(size: CGSize(width: 750, height: 1134), Score: toPass, Number: modeIndex)// Configure the view.
//        scene.viewcontroller = self
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
