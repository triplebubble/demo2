//
//  GameScene.swift
//  CS526 FIRST DEMO
//
//  Created by User on 9/15/15.
//  Copyright (c) 2015 User. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let playableRect : CGRect
    let backgroundLayerNode = SKNode()
    let informationLayerNode = SKNode()
    let chararterLayerNode = SKNode()
    var dt : NSTimeInterval = 0
    var lastUpdateTime : NSTimeInterval = 0
    var lastTouchPosition = CGPoint?()
    let characterMovePointsPerSec : CGFloat =  800
    var velocity = CGPointZero
//    let background = SKSpriteNode(imageNamed: "testbackground")
    let charater = SKSpriteNode(imageNamed: "worker")
    override init(size: CGSize) {
        playableRect = CGRect(x:0, y: 0, width: size.width, height: size.height)
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
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(gemfall1),SKAction.waitForDuration(2.0)])))
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(gemfall2),SKAction.waitForDuration(3.0)])))
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(gemfall3),SKAction.waitForDuration(3.0)])))
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
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(chararterLayerNode)
        lastTouchPosition = moveCharacter(charater.position, touchPosition: touchLocation)
        moveCharaterToward(lastTouchPosition!)
    }
    func setupSceneLayer() {
//        background.zPosition = -1
//        background.anchorPoint = CGPointZero
//        background.position = CGPointZero
//        backgroundLayerNode.addChild(background)
        charater.position = CGPoint(x: size.width/2, y: 1/5*size.height)
        charater.zPosition = 20
        charater.name = "charater"
        chararterLayerNode.addChild(charater)
        addChild(backgroundLayerNode)
        addChild(chararterLayerNode)
        backgroundColor = SKColor.grayColor()
    }
    func setupUI() {
        
    }
    func gemfall1(){
        let yellowGem = SKSpriteNode(imageNamed: "Diamond-100.png")
        yellowGem.name = "yellowGem"
        yellowGem.zPosition = 10
        yellowGem.position = CGPoint(x: size.width/2, y: size.height + CGFloat(yellowGem.size.height))
        chararterLayerNode.addChild(yellowGem)
        let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(yellowGem.size.height)), duration: 5)
        let remove = SKAction.removeFromParent()
        yellowGem.runAction(SKAction.sequence([testActinon, remove]))
        
    }
    func gemfall2(){
        let yellowGem = SKSpriteNode(imageNamed: "Diamond-100.png")
        yellowGem.name = "yellowGem"
        yellowGem.zPosition = 10
        yellowGem.position = CGPoint(x: size.width/3, y: size.height + CGFloat(yellowGem.size.height))
        chararterLayerNode.addChild(yellowGem)
        let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(yellowGem.size.height)), duration: 1)
        let remove = SKAction.removeFromParent()
        yellowGem.runAction(SKAction.sequence([testActinon, remove]))
    }
    func gemfall3(){
        let yellowGem = SKSpriteNode(imageNamed: "Diamond-100.png")
        yellowGem.name = "yellowGem"
        yellowGem.zPosition = 10
        yellowGem.position = CGPoint(x: size.width/3*2, y: size.height + CGFloat(yellowGem.size.height))
        chararterLayerNode.addChild(yellowGem)
        let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(yellowGem.size.height)), duration: 1)
        let remove = SKAction.removeFromParent()
        yellowGem.runAction(SKAction.sequence([testActinon, remove]))
    }
    func collisionCheck() {
        var hitGem: [SKSpriteNode] = []
        chararterLayerNode.enumerateChildNodesWithName("yellowGem") { node, _ in
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
    }
    
    func moveCharacter(position: CGPoint, touchPosition: CGPoint) ->CGPoint{
        if(velocity == CGPointZero) {
            if((touchPosition.x > position.x)&&(position.x < size.width/3*2)){
                return CGPoint(x: charater.position.x + size.width/6, y: position.y)
            }
            if((touchPosition.x < position.x)&&(position.x > size.width/3)){
                return CGPoint(x: charater.position.x-size.width/6, y: position.y)
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
}
