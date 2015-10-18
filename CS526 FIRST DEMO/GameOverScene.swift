//
//  GameOverScene.swift
//  CS526 FIRST DEMO
//
//  Created by User on 9/29/15.
//  Copyright © 2015 User. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let gameOverlabel: SKLabelNode
    let resultlabel: SKLabelNode
    let Mode: Int
    let backgroundbottom1 = SKSpriteNode(imageNamed: "fightground_heishita.jpg")
    let backgroundtop1 = SKSpriteNode(imageNamed: "fightground_heishita_EndPos.jpg")
    let endboard = SKSpriteNode(imageNamed: "uiground_1.jpg")
    var maxAspectRatio = CGFloat()
    var playableMargin = CGFloat()
    var maxAspectRatioWidth = CGFloat()
    var playableRect = CGRect()

    init(size: CGSize, gameover: SKLabelNode, result: SKLabelNode, Number: Int){
        self.gameOverlabel = gameover
        self.resultlabel = result
        self.Mode = Number
        maxAspectRatio = 16.0/9.0 // iPhone 5"
        maxAspectRatioWidth = size.height / maxAspectRatio
        playableMargin = (size.width - maxAspectRatioWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0,
            width: size.width - playableMargin/2,
            height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.grayColor()
        self.addChild(gameOverlabel)
        self.addChild(resultlabel)
        self.addChild(backgroundbottom1)
        self.addChild(backgroundtop1)
        self.addChild(endboard)
        backgroundtop1.anchorPoint = CGPointZero
        backgroundbottom1.anchorPoint = CGPointZero
        backgroundbottom1.zPosition = 0
        backgroundbottom1.position = CGPoint(x: playableMargin, y: 0)
        backgroundtop1.zPosition = 0
        backgroundtop1.position = CGPoint(x: playableMargin, y: backgroundbottom1.size.height)
        endboard.position = CGPoint(x: size.width/2, y: size.height/2)
        endboard.zPosition = 10
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let myScene: SKScene
        if (self.Mode == 1){
            myScene = GameScene(size: self.size)
        } else {
            myScene = GameSceneSpecial(size: self.size)
        }
        let block = SKAction.runBlock {
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.fadeWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.runAction(block)
    }
    
}
