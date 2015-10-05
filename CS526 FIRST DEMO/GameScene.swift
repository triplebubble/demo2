//
//  GameScene.swift
//  CS526 FIRST DEMO
//
//  Created by User on 9/15/15.
//  Copyright (c) 2015 User. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    enum GameState {
        case GameRunning
        case GameOver
    }
    var score = 0;
    let playableRect : CGRect
    let backgroundLayerNode = SKNode()
    let informationLayerNode = SKNode()
    let chararterLayerNode = SKNode()
    let gemLayerNode = SKNode()
    var dt : NSTimeInterval = 0
    var lastUpdateTime : NSTimeInterval = 0
    var lastTouchPosition = CGPoint?()
    let characterMovePointsPerSec : CGFloat =  1200
    var velocity = CGPointZero
    let UIlayerNode = SKNode()
    let CollectionLayerNode = SKNode()
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    let UIbackgroundHeight: CGFloat = 90
    let collectionBackgroundHeight: CGFloat = 30
    var Lifebar = SKSpriteNode()
    var LifeLosing = SKAction()
    var gameState = GameState.GameRunning;
    let resultLable = SKLabelNode()
    let gameOverLabel = SKLabelNode()
    var maxAspectRatio = CGFloat()
    var playableMargin = CGFloat()
    var maxAspectRatioWidth = CGFloat()
    let charater = SKSpriteNode(imageNamed: "worker")
    var swipe = CGVector()
    var collectLeft = SKSpriteNode()
    var collectRight = SKSpriteNode()
    var collectMid = SKSpriteNode()
    var collectSize = CGSize()
    var collectSet = [SKSpriteNode]()
    
//    var BlueGem = SKSpriteNode()
//    var YellowGem = SKSpriteNode()
//    var RedGem = SKSpriteNode()
//    var GreenGem = SKSpriteNode()
//    var PurpleGem = SKSpriteNode()
    
    var tempGem = Gem()
    //set the swipe length
    var touchLocation = CGPointZero
    override init(size: CGSize) {
        gameState = .GameRunning
        maxAspectRatio = 16.0/9.0 // iPhone 5"
        maxAspectRatioWidth = size.height / maxAspectRatio
        playableMargin = (size.width - maxAspectRatioWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0,
            width: size.width - playableMargin/2,
            height: size.height - UIbackgroundHeight)
        super.init(size: size)
    }
    override func didEvaluateActions() {
        collisionCheck();
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMoveToView(view: SKView) {
        setupSceneLayer()
        setupGemAction()
    }
    override func update(currentTime: NSTimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        if let lastTouch = lastTouchPosition {
            let diff = lastTouch - charater.position
            if (diff.length() <= characterMovePointsPerSec * CGFloat(dt)) {
                charater.position = lastTouchPosition!
                velocity = CGPointZero
            } else {
                moveSprite(charater, velocity: velocity)
            }
        }
        if(Lifebar.size.width==0 && gameState == .GameRunning){
            gameState = GameState.GameOver
        }
        if(Lifebar.size.width <= size.width/2 && Lifebar.color == UIColor.greenColor()){
            Lifebar.color = UIColor.orangeColor()
        }
        if(Lifebar.size.width <= size.width/5 && Lifebar.color == UIColor.orangeColor()){
            Lifebar.color = UIColor.redColor()
        }
        switch(gameState){
        case (.GameOver): restartGame(size, gameover: gameOverLabel, result: resultLable)
            default: break
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        touchLocation = touch.locationInNode(chararterLayerNode)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //        let touchTimeThreshold: CFTimeInterval = 0.3
        let touchDistanceThreshold: CGFloat = 3
        //        if CACurrentMediaTime() - touchTime < TouchTimeThreshold
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(chararterLayerNode)
        swipe = CGVector(dx:location.x - touchLocation.x,dy:location.y - touchLocation.y)
        let swipeLength = sqrt(swipe.dx * swipe.dx + swipe.dy * swipe.dy)
        if(swipeLength > touchDistanceThreshold) {
            if((swipe.dx>0 && charater.position.x < size.width/3*2)||(swipe.dx<0 && charater.position.x > size.width/3)) {
                lastTouchPosition = moveCharacter()
                moveCharaterToward(lastTouchPosition!)
            }
        }
    }

    func setupSceneLayer() {
        addChild(backgroundLayerNode)
        addChild(chararterLayerNode)
        addChild(UIlayerNode)
        addChild(gemLayerNode)
        addChild(CollectionLayerNode)
        setupUI()
        setUpCollection()
        SetUpCollectionColor()
//        setGem()
        backgroundColor = SKColor.grayColor()
    }
    func setupUI() {
        charater.position = CGPoint(x: size.width/2, y: 1/5*size.height)
        charater.zPosition = 20
        charater.name = "charater"
        chararterLayerNode.addChild(charater)
        let backgroundSize = CGSize(width: size.width, height: UIbackgroundHeight)
        let UIbackground = SKSpriteNode(color: UIColor.blackColor(), size: backgroundSize)
        UIbackground.anchorPoint = CGPointZero
        UIbackground.position = CGPoint(x: 0, y: size.height - UIbackgroundHeight)
        UIbackground.zPosition = 20
        let collectionSize = CGSize(width: size.width, height: collectionBackgroundHeight)
        let collectionbackground = SKSpriteNode(color: UIColor.blackColor(), size: collectionSize)
        collectionbackground.anchorPoint = CGPointZero
        collectionbackground.position = CGPoint(x: 0, y: size.height - UIbackgroundHeight - collectionBackgroundHeight)
        collectionbackground.zPosition = 20
        UIlayerNode.addChild(UIbackground)
        CollectionLayerNode.addChild(collectionbackground)
        
        scoreLabel.fontColor = UIColor.grayColor();
        scoreLabel.text = "Score: 0 "
        scoreLabel.name = "scoreLabel"
        scoreLabel.fontSize = 50
        scoreLabel.zPosition = 60
        scoreLabel.verticalAlignmentMode = .Center
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height - scoreLabel.frame.height)
        UIlayerNode.addChild(scoreLabel)
        Lifebar.zPosition = 60
        Lifebar.size = CGSizeMake(size.width - playableMargin*2, 10)
        Lifebar.anchorPoint = CGPointZero
        Lifebar.position = CGPoint(x: playableMargin, y: size.height - UIbackgroundHeight)
        Lifebar.color = UIColor.greenColor()
        LifeLosing = SKAction.scaleXTo(0, duration: 30) // times
        Lifebar.runAction(LifeLosing)
        UIlayerNode.addChild(Lifebar)
        gameOverLabel.name = "gameOverLabel"
        gameOverLabel.fontSize = 70
        gameOverLabel.fontColor = SKColor.blackColor()
        gameOverLabel.horizontalAlignmentMode = .Center
        gameOverLabel.verticalAlignmentMode = .Center
        gameOverLabel.position = CGPointMake(size.width / 2, size.height / 2 + 50)
        gameOverLabel.zPosition = 60
        gameOverLabel.text = "GAME OVER"
        resultLable.name = "resultLable"
        resultLable.fontSize = 70
        resultLable.zPosition = 60
        resultLable.fontColor = SKColor.blackColor()
        resultLable.horizontalAlignmentMode = .Center
        resultLable.verticalAlignmentMode = .Center
        resultLable.position = CGPointMake(size.width / 2, size.height / 2 - 50)
    }
    func setUpCollection() {
        collectSize = CGSize(width: (size.width-2*playableMargin-20)/3, height: 20)
        collectLeft.size = collectSize
        collectLeft.anchorPoint = CGPointZero
        collectLeft.position = CGPoint(x: playableMargin + 5, y: size.height - UIbackgroundHeight - collectionBackgroundHeight + 5)
        collectLeft.zPosition = 60
        CollectionLayerNode.addChild(collectLeft)
        collectMid.size = collectSize
        collectMid.anchorPoint = CGPointZero
        collectMid.position = CGPoint(x: playableMargin + 10 + collectSize.width, y: size.height - UIbackgroundHeight - collectionBackgroundHeight + 5)
        collectMid.zPosition = 60
        CollectionLayerNode.addChild(collectMid)
        collectRight.size = collectSize
        collectRight.anchorPoint = CGPointZero
        collectRight.position = CGPoint(x: playableMargin + 15 + 2 * collectSize.width, y: size.height - UIbackgroundHeight - collectionBackgroundHeight + 5)
        collectRight.zPosition = 60
        CollectionLayerNode.addChild(collectRight)
        collectSet.append(collectLeft)
        collectSet.append(collectMid)
        collectSet.append(collectRight)
    }
    func SetUpCollectionColor() {
        for var collect in collectSet {
            collect = generateColor(collect, num: randomInRange(1...5))
        }
    }
    func gemfall() {
        let gemColor : Int = randomInRange(1...5)
        tempGem.name = "yellowGem"
        tempGem.zPosition = 10;
        switch gemColor {
            case 1: tempGem = Gem(imageNamed: "DiamondBlue.png")
            case 2 : tempGem = Gem(imageNamed: "DiamondYellow.png")
            case 3: tempGem = Gem(imageNamed: "DiamondRed.png")
            case 4: tempGem = Gem(imageNamed: "DiamondViolet.png")
            default : tempGem = Gem(imageNamed: "DiamondGreen.png")
        }
        let lane: Int = randomInRange(1...3)
        if(lane == 1) {
            tempGem.position = CGPoint(x: size.width/3, y: size.height + CGFloat(tempGem.size.height))
        } else if(lane == 2) {
            tempGem.position = CGPoint(x: size.width/2, y: size.height + CGFloat(tempGem.size.height))
        } else {
            tempGem.position = CGPoint(x: size.width/3*2, y: size.height + CGFloat(tempGem.size.height))
        }
        gemLayerNode.addChild(tempGem)
        let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(tempGem.size.height)), duration: 1.5)
        let remove = SKAction.removeFromParent()
        tempGem.runAction(SKAction.sequence([testActinon, remove]))
    }

    func collisionCheck() {
        var hitGem: [SKSpriteNode] = []
        gemLayerNode.enumerateChildNodesWithName("yellowGem") { node, _ in
            let yellowGem = node as! SKSpriteNode
            if CGRectIntersectsRect(CGRectInset(node.frame,20, 20), self.charater.frame){
                hitGem.append(yellowGem)
            }
        }
        for yellowGem in hitGem {
            characterHitGem(yellowGem)
        }
        
    }
    func characterHitGem(gem: SKSpriteNode){
        gem.removeFromParent()
        increaseScoreBy(250)
    }
    
    func moveCharacter() ->CGPoint{
        if(velocity == CGPointZero) {
            if(swipe.dx>0 && charater.position.x < size.width/3*2){
                return CGPoint(x: charater.position.x + size.width/6, y: size.height/5)
            }
            if(swipe.dx<0 && charater.position.x > size.width/3) {
                return CGPoint(x: charater.position.x-size.width/6, y: size.height/5)
            }
        }
        return position
    }
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
    func moveCharaterToward(location: CGPoint) {
        let offset = location - charater.position
        let direction = offset.normalize()
        velocity = direction * characterMovePointsPerSec
    }
    func increaseScoreBy(plus: Int){
        score += plus
        scoreLabel.text = "Score: \(score)"
    }
    func setupGemAction(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(gemfall),SKAction.waitForDuration(0.3)])))
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(gemfall),SKAction.waitForDuration(1)])))
    }
    func restartGame(size: CGSize, gameover: SKLabelNode, result: SKLabelNode){
        result.text = "Your Score is \(score)"
        let gameoverscene = GameOverScene(size: size, gameover: gameOverLabel, result: resultLable)
        gameoverscene.scaleMode = scaleMode
        let reveal = SKTransition.fadeWithDuration(0.5)
        view?.presentScene(gameoverscene, transition: reveal)
    }
    func generateColor(collect: SKSpriteNode, num: Int) -> SKSpriteNode {
        switch num {
            case 1 : collect.color = UIColor.greenColor()
            case 2 : collect.color = UIColor.blueColor()
            case 3 : collect.color = UIColor.purpleColor()
            case 4 : collect.color = UIColor.yellowColor()
            default : collect.color = UIColor.redColor()
        }
        return collect
    }
    
//    func setGem() {
//        BlueGem = SKSpriteNode(imageNamed: "DiamondBlue.png")
//        BlueGem.name = "yellowGem"
//        BlueGem.zPosition = 10
//        YellowGem = SKSpriteNode(imageNamed: "DiamondYellow.png")
//        YellowGem.name = "yellowGem"
//        YellowGem.zPosition = 10
//        RedGem = SKSpriteNode(imageNamed: "DiamondRed.png")
//        RedGem.name = "yellowGem"
//        RedGem.zPosition = 10
//        PurpleGem = SKSpriteNode(imageNamed: "DiamondViolet.png")
//        PurpleGem.name = "yellowGem"
//        PurpleGem.zPosition = 10
//        GreenGem = SKSpriteNode(imageNamed: "DiamondGreen.png")
//        GreenGem.name = "yellowGem"
//        GreenGem.zPosition = 10
//        
//    }
}
