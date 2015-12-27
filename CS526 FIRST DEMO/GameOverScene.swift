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
    var viewcontroller = GameOverViewController()
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
    var HighestScore = SKLabelNode()
//    let replayButton = SKSpriteNode(imageNamed: "replay.png")
    let backButtom = SKSpriteNode(imageNamed: "BackToMain.png")
    let contentNode = SKNode()
    let scoreLabel = SKLabelNode()
    let highestLabel = SKLabelNode()
    init(size: CGSize, Score: String, Number: Int, HighScore: String){
        self.HighestScore.text = HighScore
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(contentNode)
        if(backButtom.containsPoint(touchLocation)){
            self.viewcontroller.navigationController?.popToRootViewControllerAnimated(true)
//        } else if (replayButton.containsPoint(touchLocation)) {
            
        }
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
        gameOverLabel.fontName = "Noteworthy-Bold"
        gameOverLabel.fontColor = SKColor.blackColor()
        gameOverLabel.horizontalAlignmentMode = .Center
        gameOverLabel.verticalAlignmentMode = .Center
        gameOverLabel.position = CGPointMake(size.width / 2, size.height / 2 + 300)
        gameOverLabel.zPosition = 60
        gameOverLabel.text = "GAME OVER"
        resultLable.name = "resultLable"
        resultLable.text = "You score is: "
        resultLable.fontSize = 70
        resultLable.fontName = "Noteworthy-Bold"
        resultLable.zPosition = 60
        resultLable.fontColor = SKColor.blackColor()
        resultLable.horizontalAlignmentMode = .Center
        resultLable.verticalAlignmentMode = .Center
        resultLable.position = CGPointMake(size.width / 2, size.height / 2 + 200)
        scoreLabel.name = "resultLable"
        scoreLabel.text = "" + score
        scoreLabel.fontSize = 70
        scoreLabel.fontName = "Noteworthy-Bold"
        scoreLabel.zPosition = 60
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.horizontalAlignmentMode = .Center
        scoreLabel.verticalAlignmentMode = .Center
        scoreLabel.position = CGPointMake(size.width / 2, size.height / 2 + 100)
        highestLabel.name = "resultLable"
        highestLabel.text = "Best score: "
        highestLabel.fontSize = 70
        highestLabel.fontName = "Noteworthy-Bold"
        highestLabel.zPosition = 60
        highestLabel.fontColor = SKColor.blackColor()
        highestLabel.horizontalAlignmentMode = .Center
        highestLabel.verticalAlignmentMode = .Center
        highestLabel.position = CGPointMake(size.width / 2, size.height / 2 )
        HighestScore.name = "resultLable"
//        HighestScore.text = "10000000"
        HighestScore.fontSize = 70
        HighestScore.fontName = "Noteworthy-Bold"
        HighestScore.zPosition = 60
        HighestScore.fontColor = SKColor.blackColor()
        HighestScore.horizontalAlignmentMode = .Center
        HighestScore.verticalAlignmentMode = .Center
        HighestScore.position = CGPointMake(size.width / 2, size.height / 2 - 100)
//        replayButton.zPosition = 60
//        replayButton.position = CGPointMake(size.width / 2 - 100 , size.height / 2 - 300)
//        contentNode.addChild(replayButton)
        backButtom.zPosition = 60
        backButtom.position = CGPointMake(size.width / 2, size.height / 2 - 300)
        contentNode.addChild(backButtom)
        self.addChild(contentNode)
        self.addChild(gameOverLabel)
        self.addChild(resultLable)
        self.addChild(scoreLabel)
        self.addChild(HighestScore)
        self.addChild(highestLabel)
    }
}
