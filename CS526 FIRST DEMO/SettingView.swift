//
//  SettingView.swift
//  CS526 FIRST DEMO
//
//  Created by Xiaoya Hang on 10/20/15.
//  Copyright © 2015 User. All rights reserved.
//

import UIKit
import AVFoundation
import Social

var count = 1
class SettingView:UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func newGame(sender: UIButton) {
        backgroundMusicPlayer.stop()
        let startGameV = self.storyboard?.instantiateViewControllerWithIdentifier("startGameView") as! StartGameViewController
        self.presentViewController(startGameV, animated: false, completion: nil)
    }
    
    @IBAction func endGame(sender: UIButton) {
           backgroundMusicPlayer.stop()
        let startGameV = self.storyboard?.instantiateViewControllerWithIdentifier("startGameView") as! StartGameViewController
        self.presentViewController(startGameV, animated: false, completion: nil)
    }

    @IBAction func muteMusic(sender: UISwitch) {
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
    
    @IBAction func connectFacebook( sender: UIButton ){
      let shareWithFacebook = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
       
        shareWithFacebook.setInitialText("Sharing an interesting iOS Game : Triple Bubble")
        shareWithFacebook.addURL(NSURL(string:"https://github.com/mingjiej/CS526-FIRST-DEMO1"))
         self.presentViewController(shareWithFacebook, animated: true, completion: nil)
    }
    
    @IBAction func connectTwitter( sender: UIButton ){
        let shareWithTwitter = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareWithTwitter.setInitialText("Sharing an interesting iOS Game : Triple Bubble")
        shareWithTwitter.addURL(NSURL(string:"https://github.com/mingjiej/CS526-FIRST-DEMO1"))

        self.presentViewController(shareWithTwitter, animated: true, completion: nil)
    }
}
