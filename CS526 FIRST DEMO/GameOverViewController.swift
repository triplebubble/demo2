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
    var highScore : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        NSUserDefaults.standardUserDefaults().setObject("0", forKey: "Highest")
        var target = ""
//        NSUserDefaults.standardUserDefaults().setObject("100000000000", forKey: "ShortestTime")
        if(modeIndex == 3) {
            if (Double(toPass) <= Double(NSUserDefaults.standardUserDefaults().objectForKey("ShortestTime") as! String)) {
                NSUserDefaults.standardUserDefaults().setObject(toPass, forKey: "ShortestTime")
                target = toPass
            } else {
                target = NSUserDefaults.standardUserDefaults().objectForKey("ShortestTime") as! String
            }
        } else {
            if (Int(toPass) >= Int(NSUserDefaults.standardUserDefaults().objectForKey("Highest") as! String)) {
                NSUserDefaults.standardUserDefaults().setObject(toPass, forKey: "Highest")
                target = toPass
            } else {
                target = NSUserDefaults.standardUserDefaults().objectForKey("Highest") as! String
            }
        }
        let scene = GameOverScene(size: CGSize(width: 750, height: 1134), Score: toPass, Number: modeIndex, HighScore: target)// Configure the view.
        scene.viewcontroller = self
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
