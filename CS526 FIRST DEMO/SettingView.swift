//
//  SettingView.swift
//  CS526 FIRST DEMO
//
//  Created by Xiaoya Hang on 10/20/15.
//  Copyright © 2015 User. All rights reserved.
//

import UIKit
import AVFoundation
var count = 1
class SettingView:UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func toStartGame(sender: UIButton) {
        backgroundMusicPlayer.stop()
        let startGameV = self.storyboard?.instantiateViewControllerWithIdentifier("startGameView") as! StartGameViewController
        self.presentViewController(startGameV, animated: false, completion: nil)
    }
    
    @IBAction func closeGame(sender: UIButton) {
        backgroundMusicPlayer.stop()
        let startGameV = self.storyboard?.instantiateViewControllerWithIdentifier("startGameView") as! StartGameViewController
        self.presentViewController(startGameV, animated: false, completion: nil)
    }
    @IBAction func muteTheMusic(sender: UISwitch) {
        if(count == 1){
        //backgroundMusicPlayer.volume = 0
            backgroundMusicPlayer.stop()
            count = 0
        }else{
            //backgroundMusicPlayer.volume = 1.0
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
            count = 1
        }
        
    }
}
