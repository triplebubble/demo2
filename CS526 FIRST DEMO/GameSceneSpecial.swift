////
////  GameScene.swift
////  CS526 FIRST DEMO
////
////  Created by User on 9/15/1
////  Copyright (c) 2015 User. All rights reserved.
////
//
import SpriteKit

//number value for gem color
//enum colour: Int {
//    case Blue = 1, Yellow, Red, Violet, Green;
//}

class GameSceneSpecial: SKScene {

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
    var prevHitGemColor = Int()
    var lifeLosingVelocity: CGFloat = 0
    
    var collectionTop = Collection()
    var collectionMiddle = Collection()
    var collectionLow = Collection()
    var collectionSet = [Collection]()
    
    var viewcontroller = SpecialViewController()
    enum GameState {
        case GameRunning
        case GameOver
    }
    let topbar = SKSpriteNode(imageNamed: "toplabel.png")
    var counter = 0;
    var totalGameTime = Float(0)
    var lastUpdateFallTime = Float(0)
    var gemFallInterval = Float(0.8)
    var gemFallSpeed : NSTimeInterval = 1.8
    var feverSecond = SKLabelNode(fontNamed: "Arial")
    var LifebarSize = CGFloat(0)
    var collectSetPosition = [CGPoint]()
    let pauseButton = SKSpriteNode(imageNamed: "pause.png")

    
    var mapUIColor: [String] = ["collection-blue.png", "collection-yellow.png", "collection-red.png", "collection-violet.png", "collection-green.png", "collection-grey.png"]
    let gemCollsionSound: SKAction = SKAction.playSoundFileNamed("sound_ui001.mp3", waitForCompletion: false)
    let collectionSound: SKAction = SKAction.playSoundFileNamed("sound_fight_skill005.mp3", waitForCompletion: false)
    
    let backgroundImage = SKSpriteNode(imageNamed: "fightground_yingyachengbao.jpg")
    let backgroundImagedown = SKSpriteNode(imageNamed: "fightground_yingyachengbao_startPos.jpg")

    
    var tempGem = Gem()
    var tempGem1 = Gem();
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
        playBackGroundMusic("bgm_002.mp3");
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
        case (.GameOver): restartGame()
            default: break
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
        let touchDistanceThreshold: CGFloat = 3
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
        
        UIlayerNode.addChild(topbar)
        topbar.anchorPoint = CGPointZero
        topbar.position = CGPoint(x: playableMargin, y: size.height - topbar.size.height)
        topbar.zPosition = 300
        
        chararterLayerNode.addChild(charater)
        scoreLabel.fontColor = UIColor.blackColor();
        scoreLabel.text = "Score: 0 "
        scoreLabel.name = "scoreLabel"
        
        feverSecond.text = "5"
        scoreLabel.fontSize = 50
        scoreLabel.zPosition = 320
        scoreLabel.verticalAlignmentMode = .Center
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height - scoreLabel.frame.height-10)
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
    // set the gems' color and set up their moving action
    func gemfall() {
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
        let gemColor1 : Int = randomInRange(1...5)
        tempGem1.name = "Gem"
        tempGem1.zPosition = 10;
        switch gemColor1 {
        case 1: tempGem1 = Gem(imageNamed: "DiamondBlue.png")
        tempGem1.colour = colour.Blue.rawValue
            break
        case 2: tempGem1 = Gem(imageNamed: "DiamondYellow.png")
        tempGem1.colour = colour.Yellow.rawValue
            break
        case 3: tempGem1 = Gem(imageNamed: "DiamondRed.png")
        tempGem1.colour = colour.Red.rawValue
            break
        case 4: tempGem1 = Gem(imageNamed: "DiamondViolet.png")
        tempGem1.colour = colour.Violet.rawValue
            break
        default:tempGem1 = Gem(imageNamed: "DiamondGreen.png")
        tempGem1.colour = colour.Green.rawValue
        }
        
        let lane: Int = randomInRange(1...3)
        if(lane == 1) {
            tempGem.position = CGPoint(x: size.width/2, y: size.height + CGFloat(tempGem.size.height))
            tempGem1.position = CGPoint(x: size.width/3*2, y: size.height + CGFloat(tempGem1.size.height))
        } else if(lane == 2) {
            tempGem.position = CGPoint(x: size.width/3, y: size.height + CGFloat(tempGem.size.height))
            tempGem1.position = CGPoint(x: size.width/3*2, y: size.height + CGFloat(tempGem1.size.height))
        } else {
            tempGem.position = CGPoint(x: size.width/3, y: size.height + CGFloat(tempGem.size.height))
            tempGem1.position = CGPoint(x: size.width/2, y: size.height + CGFloat(tempGem1.size.height))
        }
        gemLayerNode.addChild(tempGem)
        gemLayerNode.addChild(tempGem1)
        let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(tempGem.size.height)), duration: 8)
        let remove = SKAction.removeFromParent()
        tempGem.runAction(SKAction.sequence([testActinon, remove]))
        tempGem1.runAction(SKAction.sequence([testActinon, remove]))

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
    func characterHitGem(gem: Gem){
        increaseScoreBy(250)
        updateCollection(gem.colour)
        gem.removeFromParent()
    }
    // Set up the moving action for all kinds of gems
    func setupGemAction(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(gemfall),SKAction.waitForDuration(1)])))
    }
    // display the score and game over scene, then restart the game
    func restartGame(){
        self.viewcontroller.test("\(score)",mode: 1)
    }
    // calculate the swipe distance and move the character
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
        for collect in collectionSet {
            collect.removeFromParent()
        }
        collectionSet.removeAll()
    }
    
    func fullCollectionDone() {
        increaseScoreBy(500)
        SetUpCollectionColor()
        Lifebar.size.width += size.width / 10
        if (Lifebar.size.width > LifebarSize) {
            Lifebar.size.width = LifebarSize
        }
    }
    
    // update the collection when gem hit charactor. When collecion is empty, add the score, add the life time and create a new collection
    func updateCollection(curColor: Int) {
        collectionSet.append(chooseColor(collectSetPosition[counter], colColor: curColor))
        counter++
        if (counter == 3) {
            counter = 0
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
        let scoreincrease = SKLabelNode()
        scoreincrease.text = String(plus)
        scoreincrease.fontSize = 70;
        scoreincrease.zPosition = 100;
        scoreincrease.position = charater.position
        UIlayerNode.addChild(scoreincrease)
        scoreincrease.runAction(SKAction.sequence([SKAction.moveBy(CGVector(dx: 0, dy: 150), duration: 1), SKAction.fadeOutWithDuration(0.2), SKAction.removeFromParent()]))
        score += plus
        scoreLabel.text = "Score: \(score)"
    }
    // display the score and game over scene, then restart the game
   
    func chooseColor(posit: CGPoint, colColor : Int) -> Collection {
        var tempCollection = Collection()
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
