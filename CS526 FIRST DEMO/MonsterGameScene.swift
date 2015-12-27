//
//  MonsterGameScene.swift
//  CS526 FIRST DEMO
//
//  Created by User on 10/29/15.
//  Copyright © 2015 User. All rights reserved.
//

import Foundation
import SpriteKit

enum colour: Int {
    case Blue = 1, Yellow, Red, Violet, Green, Black;
}

class MonsterGameScene: SKScene {
    var blinkDone = false
    var monsterSwitch = NSTimeInterval(5)
    var score = Double(0);
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
    var scoreLabel = SKLabelNode(fontNamed: "Noteworthy-light")
    let UIbackgroundHeight: CGFloat = 90
    let collectionBackgroundHeight: CGFloat = 30
    var Lifebar = SKSpriteNode()
    var monsterlife = SKSpriteNode()
    var LifeLosing = SKAction()
    var gameState = GameState.GameRunning;
    let resultLable = SKLabelNode()
    let gameOverLabel = SKLabelNode()
    var maxAspectRatio = CGFloat()
    var playableMargin = CGFloat()
    var maxAspectRatioWidth = CGFloat()
    let charater = SKSpriteNode(imageNamed: "char-7.png")
    var swipe = CGVector()
    var collectLeft = SKSpriteNode()
    var collectRight = SKSpriteNode()
    var collectMid = SKSpriteNode()
    var collectSize = CGSize()
    var collectSet = [SKSpriteNode]()
    var prevHitGemColor = Int()
    var lifeLosingVelocity: CGFloat = 0
    var emptyCollect : Int = 0
    var collectionTop = Collection()
    var collectionMiddle = Collection()
    var collectionLow = Collection()
    var collectionSet = [Collection]()
    
    var monster1 = SKSpriteNode()
    var skill1 = SKSpriteNode(imageNamed: "skill-1")
    var skill2 = SKSpriteNode(imageNamed: "skill-2")
    var skill3 = SKSpriteNode(imageNamed: "skill-3")
    var skill1lock = SKSpriteNode(imageNamed: "skill-1-lock.png")
    var skill2lock = SKSpriteNode(imageNamed: "skill-2-lock.png")
    var skill3lock = SKSpriteNode(imageNamed: "skill-3-lock.png")
    var lowerbar = SKSpriteNode()
    var skillSet = [SKSpriteNode]()
    var level = Int(0);
//    let skilleffone = SKSpriteNode(imageNamed: "skill-1-eff.png")
    var speedup = false;
    let feverEffect = SKEmitterNode(fileNamed: "Fever.sks")
    var fevertime = NSTimeInterval(10)
    var skillthreetime = NSTimeInterval(5)
    var skillthreeOn = false
    var skillthreeEffect = SKEmitterNode(fileNamed: "MyParticle.sks")
    var skillthreeAncharPoint = SKSpriteNode()
    var viewcontroller = MonsterViewController()
    let backgroundImage = SKSpriteNode(imageNamed: "fightground_yingyachengbao.jpg")
    let backgroundImagedown = SKSpriteNode(imageNamed: "fightground_yingyachengbao_startPos.jpg")
    enum GameState {
        case GameRunning
        case GameOver
    }
    
    var animation = SKAction()
    
    let topbar = SKSpriteNode(imageNamed: "toplabel.png")
    var counter = 0;
    var totalGameTime = Float(0)
    var lastUpdateFallTime = Float(0)
    var gemFallInterval = NSTimeInterval(0.8)
    var gemFallSpeed : NSTimeInterval = 2
    var feverSecond = SKLabelNode(fontNamed: "Arial")
    var LifebarSize = CGFloat(0)
    var monsterbarSize = CGFloat(0)
    var collectSetPosition = [CGPoint]()
    let pauseButton = SKSpriteNode(imageNamed: "Return.png")
    
    
    var mapUIColor: [String] = ["collection-blue.png", "collection-yellow.png", "collection-red.png", "collection-violet.png", "collection-green.png", "collection-grey.png"]
    let gemCollsionSound: SKAction = SKAction.playSoundFileNamed("sound_ui001.mp3", waitForCompletion: false)
    let collectionSound: SKAction = SKAction.playSoundFileNamed("sound_fight_skill005.mp3", waitForCompletion: false)
    var tempGem = Gem()
    var tempGem1 = Gem();
    var number = Int(0)
    //set the swipe length
    var touchLocation = CGPointZero
    init(size: CGSize, num: Int) {
        number = num
        if(number==1){
            monster1 = SKSpriteNode(imageNamed: "monster-1.png")
        } else {
            monster1 = SKSpriteNode(imageNamed: "monster-2.png")
        }
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
        monsterMove()
        setupSceneLayer()
//        setupGemAction()
        playBackGroundMusic("bgm_002.mp3");
    }
    override func update(currentTime: NSTimeInterval) {
        if (gameState == .GameRunning) {
            if lastUpdateTime > 0 {
                dt = currentTime - lastUpdateTime
                score += Double(dt)
                if(monsterSwitch>0) {
                    monsterSwitch -= dt
                }
                scoreLabel.text = "Time: " + String(format: "%.2f", score)
            } else {
                dt = 0
            }
            if(skillthreeOn) {
                skillthreetime -= dt
                monsterlife.size.width -= 100*CGFloat(dt)
                if(skillthreetime<=0) {
                    skillthreeOn = false
                    skillthreetime = 5
                    skillthreeAncharPoint.removeFromParent()
                }
            }
//            if(monsterSwitch<=0) {
//                monsterBlink(monster1)
//            }
//            if(monsterSwitch<=0) {
//                if number == 1 {
////                    monster1.removeFromParent()
//                   let monsterTemp = SKSpriteNode(imageNamed: "monster-2.png")
//                    monsterTemp.position = monster1.position
//                    monsterTemp.zPosition = monster1.zPosition
//                    UIlayerNode.addChild(monsterTemp)
//                    monster1.removeFromParent()
//                    monster1 = monsterTemp
////                    UIlayerNode.addChild(monster1)
//                    number = 0
//                } else {
////                    monster1.removeFromParent()
//                    var monsterTemp = SKSpriteNode(imageNamed: "monster-1.png")
//                    monsterTemp.position = monster1.position
//                    monsterTemp.zPosition = monster1.zPosition
//                    UIlayerNode.addChild(monsterTemp)
//                    monster1.removeFromParent()
//                    monster1 = monsterTemp
////                    UIlayerNode.addChild(monster1)
//                    number = 1
//                }
//                blinkDone = false
//                monsterSwitch = 5
//            }
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
            //        Lifebar.size.width -= lifeLosingVelocity * CGFloat(dt)
            gemFallInterval -= dt
            if(speedup) {
                fevertime -= dt
                if(fevertime<=0) {
                    speedup = false
                    fevertime = 10
                    gemFallInterval = 0.8
                    gemFallSpeed = 2
                }
            }
            if(gemFallInterval<=0) {
                gemfall(gemFallSpeed)
                if(speedup) {
                    gemFallInterval = 0.2
                } else {
                    gemFallInterval = 0.8
                }
            }
            if(monsterlife.size.width <= 0 && gameState == .GameRunning){
                gameState = GameState.GameOver
                restartGame()
            }
            if(monsterlife.size.width <= size.width/2 && monsterlife.color == UIColor.greenColor()){
                Lifebar.color = UIColor.orangeColor()
            }
            if(monsterlife.size.width <= size.width/5 && monsterlife.color == UIColor.orangeColor()){
                Lifebar.color = UIColor.redColor()
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
        if (skill1.containsPoint(touchLocation)&&level>=1) {
            print("you used skill1")
            skillone()
            level--
            removeSkill(level, num: 1)
            
        } else if (skill2.containsPoint(touchLocation)&&level>=2) {
            print("you used skill2")
            if(!speedup) {
                skilltwo()
            }
            level = level - 2
            removeSkill(level, num: 2)
        } else if (skill3.containsPoint(touchLocation)&&level>=3) {
            print("you used skill3")
            level = level - 3;
            if(!skillthreeOn){
                skillthree()
            }
            removeSkill(level, num: 3)
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
        pauseButton.zPosition = 200
        pauseButton.position = CGPoint(x: playableMargin + pauseButton.size.width/2, y: 990)
        
        charater.position = CGPoint(x: size.width/2, y: 1/5*size.height)
        charater.zPosition = 20
        charater.name = "charater"
        
        UIlayerNode.addChild(topbar)
        topbar.anchorPoint = CGPointZero
        topbar.position = CGPoint(x: playableMargin, y: size.height - topbar.size.height)
        topbar.zPosition = 100
        
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
        monsterlife.zPosition = 320
        monsterbarSize = size.width - playableMargin*2;
        monsterlife.size = CGSizeMake(monsterbarSize, 10)
        monsterlife.anchorPoint = CGPointZero
        monsterlife.position = CGPoint(x: playableMargin, y: size.height - UIbackgroundHeight - 10)
        monsterlife.color = UIColor.purpleColor()
        UIlayerNode.addChild(monsterlife)
        skill1lock.position = CGPoint(x: size.width/3-50, y: 90)
        skill2lock.position = CGPoint(x: size.width/2, y: 90)
        skill3lock.position = CGPoint(x: size.width*2/3+50, y: 90)
        skill1lock.zPosition = 150
        skill2lock.zPosition = 150
        skill3lock.zPosition = 150
        skill1lock.setScale(0.8)
        skill2lock.setScale(0.8)
        skill3lock.setScale(0.8)
        UIlayerNode.addChild(skill1lock)
        UIlayerNode.addChild(skill2lock)
        UIlayerNode.addChild(skill3lock)
    }
    // set the gems' color and set up their moving action
    func gemfall(speed: NSTimeInterval) {
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
            tempGem.position = CGPoint(x: size.width/2, y: size.height + CGFloat(tempGem.size.height))
        } else if(lane == 2) {
            tempGem.position = CGPoint(x: size.width/3, y: size.height + CGFloat(tempGem.size.height))
        } else {
            tempGem.position = CGPoint(x: size.width/3, y: size.height + CGFloat(tempGem.size.height))
        }
        if (speedup) {
            let effect = SKEffectNode(fileNamed: "Fever.sks")
           tempGem.addChild(effect!)
        }
        gemLayerNode.addChild(tempGem)
        let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(tempGem.size.height)), duration: speed)
        let remove = SKAction.removeFromParent()
        tempGem.runAction(SKAction.sequence([testActinon, remove]))
    }
    // check all the gems and call the hit function for collisions
    func collisionCheck() {
        var hitGem: [Gem] = []
        var hitAttack: [SKSpriteNode] = []
        gemLayerNode.enumerateChildNodesWithName("Gem") { node, _ in
            let gem = node as! Gem
            if CGRectIntersectsRect(CGRectInset(node.frame,20, 20), self.charater.frame){
                hitGem.append(gem)
            }
        }
        UIlayerNode.enumerateChildNodesWithName("attack") { node, _ in
            let attack = node as! SKSpriteNode
            if CGRectIntersectsRect(CGRectInset(node.frame,20, 20), self.charater.frame){
                hitAttack.append(attack)
            }
        }
        for gem in hitGem {
            characterHitGem(gem)
        }
        for attack in hitAttack {
            characterHitAttack(attack)
        }
        
    }
    func characterHitGem(gem: Gem){
//        increaseScoreBy(250)
        updateCollection(gem.colour)
        gem.removeFromParent()
    }
    // Set up the moving action for all kinds of gems
   
    // display the score and game over scene, then restart the game
    func restartGame(){
        backgroundMusicPlayer.stop()
        self.viewcontroller.back(Double(String(format: "%.2f", score))!)
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
        setupSkill(level)
        addChild(monster1)
        monster1.position = CGPoint(x: size.width/2, y: size.height/2+350)
        monster1.zPosition = 200
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
        collectionSet.removeAll()
        for posit in collectSetPosition {
            collectionSet.append(chooseColor(posit))
        }
    }
    
    func fullCollectionDone() {
        emptyCollect = 0
//        increaseScoreBy(500)
        if(level<=2) {
            level++;
            setupSkill(level)
        }
        SetUpCollectionColor()
        Lifebar.size.width += size.width / 10
        if (Lifebar.size.width > LifebarSize) {
            Lifebar.size.width = LifebarSize
        }
    }
    
    // update the collection when gem hit charactor. When collecion is empty, add the score, add the life time and create a new collection
    func updateCollection(curColor: Int) {
        for (var i = 0; i<collectionSet.count;i++) {
            if (curColor == collectionSet[i].content) {
                collectionSet[i].removeFromParent()
                collectionSet[i] = cancelOneCollection(collectSetPosition[i])
                UIlayerNode.addChild(collectionSet[i])
                emptyCollect += 1
//                increaseScoreBy(300)
                break
            }
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
    
    func monsterMove() {
        let flipleft = SKAction.scaleXTo(-1.0, duration: 0.1)
        let flipright = SKAction.scaleXTo(1.0, duration: 0.1)
        let wait = SKAction.waitForDuration(1)
        let goLeft = SKAction.moveByX(-size.width/6, y: 0, duration: 1)
        let goright = SKAction.moveByX(size.width/6, y: 0, duration: 1)
        monster1.runAction(SKAction.repeatActionForever(SKAction.sequence([flipleft,wait,SKAction.runBlock(monsterAttack),flipright,wait,SKAction.runBlock(monsterAttack),goright,flipleft,wait,SKAction.runBlock(monsterAttack),flipright, wait, SKAction.runBlock(monsterAttack),flipleft, goLeft,flipright,wait,SKAction.runBlock(monsterAttack),flipleft,goLeft,flipright,wait,SKAction.runBlock(monsterAttack),flipleft,wait,SKAction.runBlock(monsterAttack),flipright,wait,SKAction.runBlock(monsterAttack),goright])))
    }
    
    func setupSkill(level: Int) {
        if(level==0) {
            skill1.setScale(0.8)
            skill2.setScale(0.8)
            skill3.setScale(0.8)
            skill1.position = CGPoint(x: size.width/3-50, y: 90)
            skill2.position = CGPoint(x: size.width/2, y: 90)
            skill3.position = CGPoint(x: size.width*2/3+50, y: 90)
            skill1.zPosition = 200;
            skill2.zPosition = 200;
            skill3.zPosition = 200;
            skillSet.append(skill1)
            skillSet.append(skill2)
            skillSet.append(skill3)
        } else if (level==1) {
            UIlayerNode.addChild(skill1)
        } else if (level==2) {
            UIlayerNode.addChild(skill2)
        } else if (level==3) {
            UIlayerNode.addChild(skill3)
        }
        
    }
    
    func removeSkill(level: Int, num: Int) {
        for(var i = level;i<skillSet.count;i++) {
            skillSet[i].removeFromParent()
        }
    }
    
    func skillone() {
        let skilleffone = SKSpriteNode(imageNamed: "skill-1-eff.png")
        skilleffone.name = "skill"
        skilleffone.zPosition = 250;
        skilleffone.position = CGPoint(x: charater.position.x, y: monster1.position.y)
        UIlayerNode.addChild(skilleffone)
        monsterHited(skilleffone)
        skilleffone.runAction(SKAction.sequence([SKAction.waitForDuration(0.1),SKAction.scaleBy(1.5, duration: 0.3),SKAction.scaleBy(0.6, duration: 0.2),SKAction.waitForDuration(0.1),SKAction.fadeOutWithDuration(0.5), SKAction.removeFromParent()]))
    }
    
    func skilltwo() {
        speedup = true
        gemFallSpeed = 0.8
    }
    
    func skillthree() {
        skillthreeAncharPoint.addChild(skillthreeEffect!)
        skillthreeOn = true
        skillthreeAncharPoint.position = CGPoint(x: size.width/2, y: monster1.position.y-50)
        skillthreeAncharPoint.zPosition = 300
        UIlayerNode.addChild(skillthreeAncharPoint)
    }
    
    func monsterHited(eff: SKSpriteNode) {
        UIlayerNode.enumerateChildNodesWithName("skill") { node, _ in
            if CGRectIntersectsRect(CGRectInset(node.frame,20, 20), self.monster1.frame){
                self.monsterBlink(self.monster1)
                self.monsterlife.size.width -= 150
            }
        }
    }
    func monsterBlink(monster: SKSpriteNode) {
        let duration = 3.0
        let blinkTimes = 10.0
        let blinkAction = SKAction.customActionWithDuration(duration) { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime) % slice
            node.hidden = remainder > slice / 2
        }
        monster.runAction(SKAction.sequence([blinkAction, SKAction.runBlock(blinkDown)]))
    }
    func blinkDown() {
         blinkDone = true
    }
    func monsterAttack() {
        let attackChance : Int = randomInRange(1...5)
        if(attackChance<=3) {
            let attack = SKSpriteNode(imageNamed: "shoot copy.png")
            attack.setScale(2.0)
            attack.name = "attack"
            attack.position = monster1.position
            attack.zPosition = 100
            UIlayerNode.addChild(attack)
            let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(attack.size.height)), duration: gemFallSpeed)
            let remove = SKAction.removeFromParent()
            attack.runAction(SKAction.sequence([testActinon, remove]))
        }
    }
    func characterHitAttack(attack: SKSpriteNode) {
        if(level>=1) {
            level--;
            skillSet[level].removeFromParent()
        }
        attack.removeFromParent()
    }
}