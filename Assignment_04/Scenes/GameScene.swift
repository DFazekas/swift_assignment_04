//
//  GameScene.swift
//  Assignment_04
//
//  Created by Devon on 2018-12-03.
//  Copyright © 2018 PROG31975. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let FireBall : UInt32 = 0b1
    static let Hero : UInt32 = 0b10
    static let Melon : UInt32 = 0b11
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background = SKSpriteNode(imageNamed: "background.jpg")
    private var gameOverLabel : SKLabelNode?
    private var heroNode : SKSpriteNode?
    private var score : Int = 100
    let scoreDecrement = 10
    let scoreIncrement = 2
    private var lblScore : SKLabelNode?
    
    override func didMove(to view: SKView) {
        // Display background.
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        addChild(background)
        
        // Add Player sprite to scene.
        heroNode = SKSpriteNode(imageNamed: "avatar.png")
        heroNode?.position = CGPoint(x: 10, y: 10)
        heroNode?.xScale = (heroNode?.xScale)! * 0.5
        heroNode?.yScale = (heroNode?.yScale)! * 0.5
        addChild(heroNode!)
        
        // Apply gravity physics to the world.
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self;
        
        // Apply hit-detection physics to Hero sprite.
        heroNode?.physicsBody = SKPhysicsBody(circleOfRadius: (heroNode?.size.width)!/2)
        heroNode?.physicsBody?.isDynamic = true
        heroNode?.physicsBody?.categoryBitMask = PhysicsCategory.Hero
        heroNode?.physicsBody?.contactTestBitMask = PhysicsCategory.FireBall
        heroNode?.physicsBody?.collisionBitMask = PhysicsCategory.None
        heroNode?.physicsBody?.usesPreciseCollisionDetection = true
        
        // Repeatedly generate FireBalls on scene.
        run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(addFireBall),
                    SKAction.wait(forDuration: 2)]
                )
            ), withKey: "generateFireBalls")
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMelon),
                SKAction.wait(forDuration: 2)]
            )
        ), withKey: "generateMelons")
        
        
        // Display score.
        self.lblScore = self.childNode(withName: "//score") as? SKLabelNode
        self.lblScore?.text = "Score: \(score)"
        if let slabel = self.lblScore {
            slabel.alpha = 0.0
            slabel.run(SKAction.fadeIn(withDuration: 2.0))
        }
    }
    
    func addFireBall() {
        // Adds fire ball sprite.
        let fireBall = SKSpriteNode(imageNamed: "fireball.png")
        // Horizontally flip sprite.
        fireBall.xScale = fireBall.xScale * 0.2
        fireBall.yScale = fireBall.yScale * 0.2
        let actualY = random(min: fireBall.size.height/2, max: size.width/2)
        fireBall.position = CGPoint(
            x: size.width + fireBall.size.width/2,
            y: actualY)
        addChild(fireBall)
        
        // Add hit-detection physics to FireBall.
        fireBall.physicsBody = SKPhysicsBody(rectangleOf: fireBall.size)
        fireBall.physicsBody?.isDynamic = true
        fireBall.physicsBody?.categoryBitMask = PhysicsCategory.FireBall
        fireBall.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        fireBall.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Flucuate movements rates between 2-4 sections.
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(
            to: CGPoint(x: -fireBall.size.width/2, y: actualY),
            duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        // Execute movements.
        fireBall.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func addMelon() {
        // Adds melon sprite.
        let melon = SKSpriteNode(imageNamed: "watermelon.png")
        // Horizontally flip sprite.
        melon.xScale = melon.xScale * 0.01
        melon.yScale = melon.yScale * 0.01
        let actualY = random(min: melon.size.height/2, max: size.width/2)
        melon.position = CGPoint(
            x: size.width + melon.size.width/2,
            y: actualY)
        addChild(melon)
        
        // Add hit-detection physics to FireBall.
        melon.physicsBody = SKPhysicsBody(rectangleOf: melon.size)
        melon.physicsBody?.isDynamic = true
        melon.physicsBody?.categoryBitMask = PhysicsCategory.Melon
        melon.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        melon.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Flucuate movements rates between 2-4 sections.
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(
            to: CGPoint(x: -melon.size.width/2, y: actualY),
            duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        // Execute movements.
        melon.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    
    ////////// Animation methods.
    func moveHero(toPoint pos: CGPoint) {
        // Handles moving the hero sprite to the given position on the scene.
        let actionMove = SKAction.move(to: pos, duration: TimeInterval(0.5))
        heroNode?.run(SKAction.sequence([actionMove]))
    }
    
    
    ////////// Collison handling methods.
    func heroDidCollideWithFireBall(hero: SKSpriteNode, fireBall: SKSpriteNode) {
        // Handles collison.

        score = score - scoreDecrement
        
        if score <= 0 {
            print("Game Over!")
            // Stop FireBall generation.
            removeAction(forKey: "generateFireBalls")
            removeAction(forKey: "generateMelons")
            
            // Display gameover message.
            self.gameOverLabel = self.childNode(withName: "//gameover") as? SKLabelNode
            if let label = self.gameOverLabel {
                label.alpha = 1.0
                label.run(SKAction.fadeIn(withDuration: 1.0))
            }
        }
        
        self.lblScore?.text = "Score: \(score)"
        if let slabel = self.lblScore {
            slabel.run(SKAction.fadeIn(withDuration: 1.0))
        }
    }
    
    func heroDidCollideWithMelon(hero: SKSpriteNode, melon: SKSpriteNode) {
        // Handles collison.
        print("Melon")
        score = score + scoreIncrement
        
        self.lblScore?.text = "Score: \(score)"
        if let slabel = self.lblScore {
            slabel.run(SKAction.fadeIn(withDuration: 1.0))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Test collision.
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.FireBall != 0) && (secondBody.categoryBitMask & PhysicsCategory.Hero != 0)) {
            heroDidCollideWithFireBall(
                hero: firstBody.node as! SKSpriteNode,
                fireBall: secondBody.node as! SKSpriteNode)
        }
        else if ((firstBody.categoryBitMask & PhysicsCategory.Melon != 0) && (secondBody.categoryBitMask & PhysicsCategory.Hero != 0)) {
            heroDidCollideWithMelon(
                hero: firstBody.node as! SKSpriteNode,
                melon: secondBody.node as! SKSpriteNode)
        }
    }
    
    
    ////////// Misc. methods.
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xffffffff)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat {
        // Generates a random value between min and max.
        return random() * (max-min) + min
    }
    
    
    ////////// Gesture handling methods.
    func touchDown(atPoint pos : CGPoint) {
        // Move hero sprite.
        moveHero(toPoint: pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        // Move hero sprite.
        moveHero(toPoint: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
