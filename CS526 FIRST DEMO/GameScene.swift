//
//  GameScene.swift
//  CS526 FIRST DEMO
//
//  Created by User on 9/15/15.
//  Copyright (c) 2015 User. All rights reserved.℃℃
//

import SpriteKit

// number value for gem color

class GameScene: SKScene {
    
    var viewcontroller = GameViewController()
    
    var testCollection = SKSpriteNode(imageNamed: "collection-red.png")
    
    enum GameState {
        case GameRunning
        case GameOver
    }
    
    var animation = SKAction()
    
    let topbar = SKSpriteNode(imageNamed: "toplabel.png")
    var counter = 0;
    var score = 0;
    let playableRect : CGRect
    let backgroundLayerNode = SKNode()
    let informationLayerNode = SKNode()
    let chararterLayerNode = SKNode()
    let gemLayerNode = SKNode()
    var dt : NSTimeInterval = 0
    var lastUpdateTime : NSTimeInterval = 0
    var totalGameTime = Float(0)
    var lastUpdateFallTime = Float(0)
    var gemFallInterval = Float(0.8)
    var gemFallSpeed : NSTimeInterval = 1.8
    var lastTouchPosition = CGPoint?()
    let characterMovePointsPerSec : CGFloat =  1200
    var velocity = CGPointZero
    let UIlayerNode = SKNode()
    let CollectionLayerNode = SKNode()
    var scoreLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
    var feverSecond = SKLabelNode(fontNamed: "Arial")
    let UIbackgroundHeight: CGFloat = 90
    let collectionBackgroundHeight: CGFloat = 30
    var Lifebar = SKSpriteNode()
    var LifeLosing = SKAction()
    var LifebarSize = CGFloat(0)
    var gameState = GameState.GameRunning;
    
    var maxAspectRatio = CGFloat()
    var playableMargin = CGFloat()
    var maxAspectRatioWidth = CGFloat()
    let charater = SKSpriteNode(imageNamed: "char-7.png")
    var swipe = CGVector()
    var collectSetPosition = [CGPoint]()
    var prevHitGemColor = Int()
    var blackHit = Bool()
    var emptyCollect: Int = 0
    var lifeLosingVelocity: CGFloat = 0
    
    let black = SKEmitterNode(fileNamed: "Black.sks")
    let feverEffect = SKEmitterNode(fileNamed: "Fever.sks")
    
    let backgroundImage = SKSpriteNode(imageNamed: "fightground_heishita.jpg")
    let backgroundImagedown = SKSpriteNode(imageNamed: "fightground_heishita_startPos.jpg")
    
    var mapUIColor: [String] = ["collection-blue.png", "collection-yellow.png", "collection-red.png", "collection-violet.png", "collection-green.png", "collection-grey.png"]
    
    var collectionTop = Collection()
    var collectionMiddle = Collection()
    var collectionLow = Collection()
    var collectionSet = [Collection]()
    
    //combo label
    //let comboLabel = SKLabelNode(fontNamed: "Arial")
    var comboHitCount = 0
    let combePicture = SKSpriteNode()
    
    var tempGem = Gem()
    //set the swipe length
    var touchLocation = CGPointZero
    
    //fever model
    var feverCount = Float(5);
    var fever = false;
    var hitWithOutMistake = 0;
    
    //gem fall second
    var gemFallSecond = Float(0.8)
    var blackGemFallSecond = Float(8)
    
    let gemCollsionSound: SKAction = SKAction.playSoundFileNamed("sound_ui001.mp3", waitForCompletion: false)
    let collectionSound: SKAction = SKAction.playSoundFileNamed("sound_fight_skill005.mp3", waitForCompletion: false)
    
    let pauseButton = SKSpriteNode(imageNamed: "Return.png")
    
    override init(size: CGSize) {
        var texture : [SKTexture] = []
        texture.append(SKTexture(imageNamed: "char-7.png"))
        texture.append(SKTexture(imageNamed: "char-3.png"))
        texture.append(SKTexture(imageNamed: "char-2.png"))
        texture.append(SKTexture(imageNamed: "char-4.png"))
        texture.append(SKTexture(imageNamed: "char-6.png"))
        texture.append(SKTexture(imageNamed: "char-5.png"))
        texture.append(SKTexture(imageNamed: "char-1.png"))
        animation = SKAction.animateWithTextures(texture, timePerFrame: 0.05)
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
        charater.runAction(SKAction.repeatActionForever(animation))
        setupSceneLayer()
        playBackGroundMusic("bgm_003.mp3");
      
    }
    override func update(currentTime: NSTimeInterval) {
        if(gameState != .GameOver) {
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
            
            feverEffect!.hidden = !fever;
            black!.hidden = !blackHit;
            
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
            
            totalGameTime += Float(dt)
            if (totalGameTime - lastUpdateFallTime > 10 && totalGameTime < 41) {
                lastUpdateFallTime = totalGameTime
                gemFallInterval -= 0.1
                gemFallSpeed -= 0.1
            }
            
            gemFallSecond -= Float(dt)
            blackGemFallSecond -= Float(dt)
            
            if (gemFallSecond <= 0) {
                gemFallSecond = gemFallInterval
                runAction(SKAction.runBlock(gemfall))
            }
            if(Lifebar.size.width <= 0 && gameState == .GameRunning){
                gameState = GameState.GameOver
            }
            if(Lifebar.size.width <= size.width/2 && Lifebar.size.width > size.width/5 ){
                Lifebar.color = UIColor.orangeColor()
            }
            if(Lifebar.size.width <= size.width/5){
                Lifebar.color = UIColor.redColor()
            }
            if(Lifebar.size.width > size.width/2){
                Lifebar.color = UIColor.greenColor()
            }
            switch(gameState){
            case (.GameOver): restartGame()
            default: break
            }

        }
    }
    
    // record the touch begin location
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        touchLocation = touch.locationInNode(chararterLayerNode)
        if(pauseButton.containsPoint(touchLocation)){
            if(self.view?.paused == false){
                self.view?.paused = true
            } else {
                self.view?.paused = false
                lastUpdateTime = 0
            }
        }
    }
    
    // calculate the swipe distance and move the character
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //        let touchTimeThreshold: CFTimeInterval = 0.3
        let touchDistanceThreshold: CGFloat = 3
        //        if CACurrentMediaTime() - touchTime < TouchTimeThreshold
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(chararterLayerNode)
        if(!pauseButton.containsPoint(location)){
            swipe = CGVector(dx:location.x - touchLocation.x,dy:location.y - touchLocation.y)
            let swipeLength = sqrt(swipe.dx * swipe.dx + swipe.dy * swipe.dy)
            if(swipeLength > touchDistanceThreshold) {
                if((swipe.dx>0 && charater.position.x < size.width/3*2)||(swipe.dx<0 && charater.position.x > size.width/3)) {
                    lastTouchPosition = moveCharacter()
                    moveCharaterToward(lastTouchPosition!)
                }
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
    }
    
    // set up the basic UI
    func setupUI() {
        
        backgroundImage.anchorPoint = CGPointZero
        backgroundLayerNode.addChild(backgroundImage)
        backgroundImage.zPosition = -100;
        backgroundImage.position = CGPoint(x: playableMargin, y: 170)
        
        backgroundImagedown.anchorPoint = CGPointZero
        backgroundLayerNode.addChild(backgroundImagedown)
        backgroundImagedown.zPosition = -100;
        backgroundImagedown.position = CGPoint(x: playableMargin, y: 0)
        
        UIlayerNode.addChild(pauseButton)
        pauseButton.zPosition = 100
        pauseButton.position = CGPoint(x: size.width/2, y: 50)
        
        charater.position = CGPoint(x: size.width/2, y: 1/5*size.height)
        charater.zPosition = 20
        charater.name = "charater"
        charater.addChild(feverEffect!)
        charater.addChild(black!)
        
        feverEffect!.hidden = true;
        black!.hidden = true;
        
        UIlayerNode.addChild(topbar)
        topbar.anchorPoint = CGPointZero
        topbar.position = CGPoint(x: playableMargin, y: size.height - topbar.size.height)
        topbar.zPosition = 300
        
        chararterLayerNode.addChild(charater)
        scoreLabel.fontColor = UIColor.whiteColor();
        scoreLabel.text = "Score: 0 "
        scoreLabel.name = "scoreLabel"
        
        feverSecond.text = "5"
        scoreLabel.fontSize = 50
        scoreLabel.zPosition = 320
        scoreLabel.verticalAlignmentMode = .Center
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height - scoreLabel.frame.height)
        UIlayerNode.addChild(scoreLabel)
        Lifebar.zPosition = 320
        LifebarSize = size.width - playableMargin*2;
        Lifebar.size = CGSizeMake(LifebarSize, 10)
        Lifebar.anchorPoint = CGPointZero
        Lifebar.position = CGPoint(x: playableMargin, y: size.height - UIbackgroundHeight)
        Lifebar.color = UIColor.greenColor()
        lifeLosingVelocity = Lifebar.size.width / 30
        UIlayerNode.addChild(Lifebar)
    }
    
    // set up the colloction set, initailize the layer's nodes, and collectSet
    func setUpCollection() {
        let top = CGPoint(x: size.width/2+275, y: size.height/2+300)
        let middle = CGPoint(x: size.width/2+275, y: size.height/2+220)
        let low = CGPoint(x: size.width/2+275, y: size.height/2+140)
        collectSetPosition.append(top)
        collectSetPosition.append(middle)
        collectSetPosition.append(low)
    }
    
    // Randomly set up three color for collection set
    func SetUpCollectionColor() {
        if(emptyCollect > 0) {
            collectionSet.removeAll()
        }
        for posit in collectSetPosition {
            collectionSet.append(chooseColor(posit))
        }
    }
    
    func deleteRestCollections() {
        var i = 0
        while(i < 3) {
            collectionSet[i].removeFromParent()
            collectionSet[i] = cancelOneCollection(collectSetPosition[i])
            i++
        }
        emptyCollect = 3
    }
    
    // set the gems' color and set up their moving action
    func gemfall() {
        if (blackGemFallSecond <= 0) {
            blackGemFallSecond = 8
            blackGemFall(gemFallSpeed)
        } else {
            normalGemFall(gemFallSpeed)
        }
    }
    
    func blackGemFall(dur : NSTimeInterval) {
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
        let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(tempGem.size.height)), duration: dur)
        let remove = SKAction.removeFromParent()
        tempGem.runAction(SKAction.sequence([testActinon, remove]))
    }
    
    func normalGemFall(dur : NSTimeInterval) {
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
        let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(tempGem.size.height)), duration: dur)
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
        
        if(!fever && curColor == colour.Black.rawValue) {
            blackHit = true
            return
        }
        
        if(blackHit) {
            checkBlackEffects(curColor)
            blackHit = false
            return
        }
        
        blackHit = false
        if(fever){
            if(counter==3){
                counter = 0;
            }
            collectionSet[counter].removeFromParent()
            collectionSet[counter] = cancelOneCollection(collectSetPosition[counter])
//            UIlayerNode.addChild(collectionSet[counter])
            counter++
            emptyCollect++
            if (emptyCollect == 3) {
                fullCollectionDone()
            }
            prevHitGemColor = 0
        } else {
            comboCheck(curColor)
            updateCollection(curColor);
        }
        
    }
    
    func comboCheck(curColor:Int) {
        if(curColor == prevHitGemColor) {
            comboHitCount += 1
            if(comboHitCount > 1) {
                var combo = SKSpriteNode()
                combo = SKSpriteNode(imageNamed: "evolutionlv_\(comboHitCount).png")
                UIlayerNode.addChild(combo)
                combo.position = charater.position
                combo.zPosition = 100;
                let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: 150), duration: 1)
                let remove = SKAction.removeFromParent()
                increaseScoreBy(comboHitCount * 250)
                combo.runAction(SKAction.sequence([testActinon, remove]))
                if(comboHitCount == 5) {
                    enterFeverMode()
                }
            }
        } else {
            comboHitCount = 1
        }
        prevHitGemColor = curColor
    }
    
    //check special effects triggered by black diamond
    func checkBlackEffects(curColor:Int) {
        switch(curColor) {
        case colour.Green.rawValue:
            Lifebar.size.width += size.width / 10
            if (Lifebar.size.width > LifebarSize) {
                Lifebar.size.width = LifebarSize
            }
            break
        case colour.Blue.rawValue:
            increaseScoreBy(300)
            break
        case colour.Yellow.rawValue:
            deleteRestCollections()
            SetUpCollectionColor()
            hitWithOutMistake = 0
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
            let helpedHit = 3 - emptyCollect
            deleteRestCollections()
            hitWithOutMistake += helpedHit
        }
        else {
            collectionSet[0].removeFromParent()
            collectionSet[1].removeFromParent()
            collectionSet[0] = cancelOneCollection(collectSetPosition[0])
//            UIlayerNode.addChild(collectionSet[0])
            collectionSet[1] = cancelOneCollection(collectSetPosition[1])
//            UIlayerNode.addChild(collectionSet[1])
            emptyCollect += 2
            hitWithOutMistake += 2
        }
        if (emptyCollect == 3) {
            fullCollectionDone()
        }
    }
    
    func fullCollectionDone() {
        increaseScoreBy(500)
        SetUpCollectionColor()
        Lifebar.size.width += size.width / 10
        if (Lifebar.size.width > LifebarSize) {
            Lifebar.size.width = LifebarSize
        }
        emptyCollect -= 3
        if(hitWithOutMistake==3) {
            enterFeverMode()
        } else {
            hitWithOutMistake = 0
        }
    }
    
    func enterFeverMode() {
        if(fever) {
            return
        }
        fever = true;
        feverCount = 5;
        feverSecond.text = "5"
        UIlayerNode.addChild(feverSecond)
        hitWithOutMistake = 0
    }
    
    // update the collection when gem hit charactor. When collecion is empty, add the score, add the life time and create a new collection
    func updateCollection(curColor: Int) {
        var check = false
        for (var i = 0; i<collectionSet.count;i++) {
            if (curColor == collectionSet[i].content) {
                check = true;
                collectionSet[i].removeFromParent()
                collectionSet[i] = cancelOneCollection(collectSetPosition[i])
//                UIlayerNode.addChild(collectionSet[i])
                emptyCollect += 1
                hitWithOutMistake++
                increaseScoreBy(300)
                break
            }
        }
        if(!check) {
            hitWithOutMistake = 0
        }
        if (emptyCollect == 3) {
            fullCollectionDone()
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
        //fontNamed: "Helvetica-light"
        let scoreincrease = SKLabelNode()
        scoreincrease.text = String(plus)
        scoreincrease.fontSize = 50;
        scoreincrease.zPosition = 100;
        scoreincrease.position = charater.position
        UIlayerNode.addChild(scoreincrease)
        scoreincrease.runAction(SKAction.sequence([SKAction.moveBy(CGVector(dx: 0, dy: 150), duration: 1), SKAction.fadeOutWithDuration(0.2), SKAction.removeFromParent()]))
        score += plus
        scoreLabel.text = "Score: \(score)"
    }
     // display the score and game over scene, then restart the game
    func restartGame(){
        backgroundMusicPlayer.stop()
        self.viewcontroller.test("\(score)",mode: 1)
    }
    func chooseColor(posit: CGPoint) -> Collection {
        var tempCollection = Collection()
        let colColor : Int = randomInRange(1...5)
        tempCollection.name = "Collection"
        tempCollection.zPosition = 150;
        switch colColor {
        case 1: tempCollection = Collection(imageNamed: mapUIColor[0])
        tempCollection.content = colour.Blue.rawValue
            break
        case 2: tempCollection = Collection(imageNamed: mapUIColor[1])
        tempCollection.content = colour.Yellow.rawValue
            break
        case 3: tempCollection = Collection(imageNamed: mapUIColor[2])
        tempCollection.content = colour.Red.rawValue
            break
        case 4: tempCollection = Collection(imageNamed: mapUIColor[3])
        tempCollection.content = colour.Violet.rawValue
            break
        default:tempCollection = Collection(imageNamed: mapUIColor[4])
        tempCollection.content = colour.Green.rawValue
        }
        tempCollection.position = posit
        UIlayerNode.addChild(tempCollection)
        return tempCollection
    }
    
    func cancelOneCollection(posit: CGPoint) -> Collection {
        let tempCollection = Collection(imageNamed: mapUIColor[5])
        tempCollection.zPosition = 1000
        tempCollection.content = colour.Black.rawValue
        return tempCollection
        
    }
    
}
