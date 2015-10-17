//
//  GameScene.swift
//  CS526 FIRST DEMO
//
//  Created by User on 9/15/15.
//  Copyright (c) 2015 User. All rights reserved.℃℃
//

import SpriteKit

// number value for gem color
enum colour: Int {
    case Blue = 1, Yellow, Red, Violet, Green, Black;
}

class GameScene: SKScene {
    enum GameState {
        case GameRunning
        case GameOver
    }
    
    var counter = 0;
    
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
    var feverSecond = SKLabelNode(fontNamed: "Arial")
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
    var prevHitGemColor = Int()
    var blackHit = Bool()
    var emptyCollect: Int = 0
    var lifeLosingVelocity: CGFloat = 0
    
    var mapUIColor: [UIColor] = [UIColor.blueColor(), UIColor.yellowColor(), UIColor.redColor(), UIColor.purpleColor(), UIColor.greenColor(), UIColor.blackColor()]
    
    //combo label
    let comboLabel = SKLabelNode(fontNamed: "Arial")
    var comboHitCount = 0

    //black label
    let blackLabel = SKLabelNode(fontNamed: "Arial")
    
    var tempGem = Gem()
    //set the swipe length
    var touchLocation = CGPointZero
    
    var feverCount = Float(5);
    var fever = false;
    var hitWithOutMistake = 0;
    
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
        Lifebar.size.width -= lifeLosingVelocity * CGFloat(dt)
        
        
        
        if(fever){
            var temp = Float(0);
            temp += Float(feverSecond.text!)!
            feverCount -= Float(dt);
            if(feverCount <= temp-1){
                feverSecond.text = String(Int(temp-1))
            }
            if(feverSecond.text=="0"){
                fever = false
                feverCount = 5
                counter = 0
                feverSecond.removeFromParent()
            }
        }
        
        
        
        if(Lifebar.size.width <= 0 && gameState == .GameRunning){
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
    
    // record the touch begin location
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        touchLocation = touch.locationInNode(chararterLayerNode)
    }
    
    // calculate the swipe distance and move the character
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
    
    // initialize UI
    func setupSceneLayer() {
        addChild(backgroundLayerNode)
        addChild(chararterLayerNode)
        addChild(UIlayerNode)
        addChild(gemLayerNode)
        addChild(CollectionLayerNode)
        addChild(informationLayerNode)

        setupUI()
        setUpCollection()
        SetUpCollectionColor()
        backgroundColor = SKColor.grayColor()
        
        
    }
    
    // set up the basic UI
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
        
        feverSecond.text = "15"
        feverSecond.name = "feverSecond"
        feverSecond.fontSize = 40
        feverSecond.fontColor = SKColor.blackColor();
        feverSecond.zPosition = 60
        feverSecond.position = CGPointMake(100, size.height / 2)
        
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
//        LifeLosing = SKAction.scaleXTo(0, duration: 30) // times
//        Lifebar.runAction(LifeLosing)
        lifeLosingVelocity = Lifebar.size.width / 30
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
        
        comboLabel.fontSize = 50
        comboLabel.zPosition = 60
        comboLabel.text = ""
        comboLabel.name = "comboLabel"
        comboLabel.verticalAlignmentMode = .Center
        comboLabel.position = CGPoint(
            x: size.width / 4,
            y: size.height / 8)
        informationLayerNode.addChild(comboLabel)
        
        blackLabel.fontSize = 50
        blackLabel.zPosition = 60
        blackLabel.text = ""
        blackLabel.name = "blackLabel"
        blackLabel.verticalAlignmentMode = .Center
        blackLabel.position = CGPoint(
            x: size.width / 4,
            y: size.height / 8)
        informationLayerNode.addChild(blackLabel)

    }
    
    // set up the colloction set, initailize the layer's nodes, and collectSet
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
    
    // Randomly set up three color for collection set
    func SetUpCollectionColor() {
        for var collect in collectSet {
            collect = generateColor(collect, num: randomInRange(1...5))
        }
    }
    
    // set up color for each collection set node
    func generateColor(collect: SKSpriteNode, num: Int) -> SKSpriteNode {
        collect.color = mapUIColor[num - 1];
        return collect
    }
    
    // set the gems' color and set up their moving action
    func gemfall() {
        let judgeSpecial:Int = randomInRange(1...5)
        if(judgeSpecial == 1 && !fever) {
            blackGemFall()
        }
        else {
            normalGemFall()
        }
    }
    
    func blackGemFall() {
        tempGem.name = "Gem"
        tempGem.zPosition = 10;
        tempGem = Gem(imageNamed: "DiamondBlack.png")
        tempGem.colour = colour.Black.rawValue
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
    
    func normalGemFall() {
        let gemColor : Int = randomInRange(1...5)
        tempGem.name = "Gem"
        tempGem.zPosition = 10;
        switch gemColor {
        case 1: tempGem = Gem(imageNamed: "DiamondBlue.png")
        tempGem.colour = colour.Blue.rawValue
            break
        case 2: tempGem = Gem(imageNamed: "DiamondYellow.png")
        tempGem.colour = colour.Yellow.rawValue
            break
        case 3: tempGem = Gem(imageNamed: "DiamondRed.png")
        tempGem.colour = colour.Red.rawValue
            break
        case 4: tempGem = Gem(imageNamed: "DiamondViolet.png")
        tempGem.colour = colour.Violet.rawValue
            break
        default:tempGem = Gem(imageNamed: "DiamondGreen.png")
        tempGem.colour = colour.Green.rawValue
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
    
    // check all the gems and call the hit function for collisions
    func collisionCheck() {
        var hitGem: [Gem] = []
        gemLayerNode.enumerateChildNodesWithName("Gem") { node, _ in
            let gem = node as! Gem
            if CGRectIntersectsRect(CGRectInset(node.frame,20, 20), self.charater.frame){
                hitGem.append(gem)
            }
        }
        for gem in hitGem {
            characterHitGem(gem)
        }
        
    }
    
    // remove the collision gem, and remove the corresponding collection node
    func characterHitGem(gem: Gem){
        let curColor = gem.colour
        gem.removeFromParent()
//        if(curColor == prevHitGemColor) {
//            increaseScoreBy(100)
//            comboHitCount += 1
//        }
        
        if(curColor == colour.Black.rawValue) {
            blackHit = true
            comboLabel.text = ""
            blackLabel.text = "Black got!"
            return
        }
        
        blackLabel.text = ""
        
        if(blackHit) {
            checkBlackEffects(curColor)
            blackHit = false
            return
        }
        
        blackHit = false
        
        if(curColor == prevHitGemColor) {
            comboHitCount += 1
            increaseScoreBy(100)
            if(comboHitCount > 0) {
                comboLabel.text = "Combo * " + String(comboHitCount)
            }
        } else {
            comboLabel.text = ""
            comboHitCount = 1
        }

        prevHitGemColor = curColor
        increaseScoreBy(250)
        if(fever){
            if(counter==3){
                counter = 0;
            }
            collectSet[counter].color = UIColor.blackColor()
            counter++
            emptyCollect++
            if (emptyCollect >= 3) {
                increaseScoreBy(500)
                SetUpCollectionColor()
                Lifebar.size.width += size.width / 10
                emptyCollect -= 3
                hitWithOutMistake = 0
            }
        } else {
            updateCollection(curColor);
        }
        
    }
    
    //check special effects triggered by black diamond
    func checkBlackEffects(curColor:Int) {
        switch(curColor) {
        case colour.Green.rawValue:
            Lifebar.size.width += size.width / 10
            break
        case colour.Blue.rawValue:
            increaseScoreBy(300)
            break
        case colour.Yellow.rawValue:
            SetUpCollectionColor()
            emptyCollect = 0
            break
        case colour.Red.rawValue:
            Lifebar.size.width -= size.width / 10
            break
        case colour.Violet.rawValue:
            helpCollection()
            break
        default: break
        }
    }
    
    //help finish 2 collection
    func helpCollection() {
        if(emptyCollect >= 1) {
            emptyCollect = 3
            hitWithOutMistake += 3 - emptyCollect
        }
        else {
            generateColor(collectSet[0], num: colour.Black.rawValue)
            generateColor(collectSet[1], num: colour.Black.rawValue)
            emptyCollect -= 2
            hitWithOutMistake += 2
        }
        if (emptyCollect >= 3) {
            increaseScoreBy(500)
            SetUpCollectionColor()
            Lifebar.size.width += size.width / 10
            emptyCollect -= 3
            if(hitWithOutMistake==3) {
                fever = true;
                feverCount = 15;
                feverSecond.text = "15"
                UIlayerNode.addChild(feverSecond)
            } else {
                hitWithOutMistake = 0
            }
        }
    }
    
    // update the collection when gem hit charactor. When collecion is empty, add the score, add the life time and create a new collection
    func updateCollection(curColor: Int) {
        var check = false
        for var collect in collectSet {
            if (mapUIColor[curColor - 1] == collect.color) {
                check = true;
                collect = generateColor(collect, num: 6);
                emptyCollect += 1
                hitWithOutMistake++
                break
            }
        }
        if(!check) {
            hitWithOutMistake = 0
        }
        if (emptyCollect >= 3) {
            increaseScoreBy(500)
            SetUpCollectionColor()
            Lifebar.size.width += size.width / 10
            emptyCollect -= 3
            if(hitWithOutMistake==3) {
                fever = true;
                feverCount = 15;
                feverSecond.text = "15"
                UIlayerNode.addChild(feverSecond)
            } else {
                hitWithOutMistake = 0
            }
        }
    }
    
    // calculate the target position after character moving
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
    
    // move the character when update the frame
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
    
    // calculate the character moving velocity
    func moveCharaterToward(location: CGPoint) {
        let offset = location - charater.position
        let direction = offset.normalize()
        velocity = direction * characterMovePointsPerSec
    }
    
    // increase the score by a given value
    func increaseScoreBy(plus: Int){
        score += plus
        scoreLabel.text = "Score: \(score)"
    }
    
    // Set up the moving action for all kinds of gems
    func setupGemAction(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(gemfall),SKAction.waitForDuration(1)])))
    }
    
    // display the score and game over scene, then restart the game
    func restartGame(size: CGSize, gameover: SKLabelNode, result: SKLabelNode){
        result.text = "Your Score is \(score)"
        let gameoverscene = GameOverScene(size: size, gameover: gameOverLabel, result: resultLable)
        gameoverscene.scaleMode = scaleMode
        let reveal = SKTransition.fadeWithDuration(0.5)
        view?.presentScene(gameoverscene, transition: reveal)
    }
    
}
