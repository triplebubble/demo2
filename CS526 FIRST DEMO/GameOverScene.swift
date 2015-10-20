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
    let score : String
    let Mode: Int
    let backgroundbottom1 = SKSpriteNode(imageNamed: "fightground_heishita.jpg")
    let backgroundtop1 = SKSpriteNode(imageNamed: "fightground_heishita_EndPos.jpg")
    let endboard = SKSpriteNode(imageNamed: "uiground_1.jpg")
    var maxAspectRatio = CGFloat()
    var playableMargin = CGFloat()
    var maxAspectRatioWidth = CGFloat()
    var playableRect = CGRect()
    let resultLable = SKLabelNode()
    let gameOverLabel = SKLabelNode()
    init(size: CGSize, Score: String, Number: Int){
        self.score = Score
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
        gameOverLabel.name = "gameOverLabel"
        gameOverLabel.fontSize = 70
        gameOverLabel.fontColor = SKColor.blackColor()
        gameOverLabel.horizontalAlignmentMode = .Center
        gameOverLabel.verticalAlignmentMode = .Center
        gameOverLabel.position = CGPointMake(size.width / 2, size.height / 2 + 50)
        gameOverLabel.zPosition = 60
        gameOverLabel.text = "GAME OVER"
        resultLable.name = "resultLable"
        resultLable.text = "You score is "+score
        resultLable.fontSize = 70
        resultLable.zPosition = 60
        resultLable.fontColor = SKColor.blackColor()
        resultLable.horizontalAlignmentMode = .Center
        resultLable.verticalAlignmentMode = .Center
        resultLable.position = CGPointMake(size.width / 2, size.height / 2 - 50)
        self.addChild(gameOverLabel)
        self.addChild(resultLable)
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
