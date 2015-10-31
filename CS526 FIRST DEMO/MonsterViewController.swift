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
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MonsterGameScene(size: CGSize(width: 750, height: 1134))// Configure the view.
        let skView = self.view as! SKView
        //        skView.showsFPS = true
        //        skView.showsNodeCount = true
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
    
    func back() {
        performSegueWithIdentifier("return", sender: nil)
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
