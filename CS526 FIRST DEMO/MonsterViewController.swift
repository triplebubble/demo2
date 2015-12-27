//
//  MonsterViewController.swift
//  CS526 FIRST DEMO
//
//  Created by User on 10/29/15.
//  Copyright © 2015 User. All rights reserved.
//

import UIKit
import SpriteKit
class MonsterViewController: UIViewController {
    var monsterIndex = Int(2)
    var totalScore = Double(0)
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MonsterGameScene(size: CGSize(width: 750, height: 1134), num: monsterIndex)// Configure the view.
        scene.viewcontroller = self
        let skView = self.view as! SKView
        //        skView.showsFPS = true
        //        skView.showsNodeCount  = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        // Do any additional setup after loading the view.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(score: Double) {
        totalScore = score
        self.performSegueWithIdentifier("monster", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "monster") {
            let svc : GameOverViewController = segue.destinationViewController as! GameOverViewController
            svc.toPass = "\(totalScore)"
            svc.modeIndex = 3
        }
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
