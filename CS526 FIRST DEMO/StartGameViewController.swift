//
//  StartGame.swift
//  CS526 FIRST DEMO
//
//  Created by User on 10/11/15.
//  Copyright © 2015 User. All rights reserved.
//

import Foundation
import UIKit


class StartGameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroud_raffleanimation.jpg")!)
        //        SKTAudio.sharedInstance().playBackgroundMusic(filename: "")
        //        let scene = StartgameScene(size: CGSize(width: 750, height: 1134))// Configure the view.
        //        let skView = self.view as! SKView
        //        //        skView.showsFPS = true
        //        //        skView.showsNodeCount = true
        //        skView.ignoresSiblingOrder = true
        //        scene.scaleMode = .AspectFill
        //        skView.presentScene(scene)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    
}