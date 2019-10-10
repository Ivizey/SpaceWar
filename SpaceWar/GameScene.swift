//
//  GameScene.swift
//  SpaceWar
//
//  Created by mac on 08.10.19.
//  Copyright © 2019 ivizey. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let spaceShipCategory: UInt32 = 0x1 << 0 //00000.01
    let asteroidCategory: UInt32 = 0x1 << 1 //000..10
    
    //1 Create node
    var spaceShip: SKSpriteNode!
    var score = 0
    var scoreLabel: SKLabelNode!
    var spaceBackground: SKSpriteNode!
    var asteroidLayer: SKNode!
    var starsLayer: SKNode!
    var gameIsPaused: Bool = false
    var spaceShipLayer: SKNode!
    
    func pauseTheGame() {
        gameIsPaused = true
        self.asteroidLayer.isPaused = true
        physicsWorld.speed = 0
        starsLayer.isPaused = true
    }
    
    func pauseButton(sender: AnyObject) {
        if !gameIsPaused {
            pauseTheGame()
        } else {
            unPauseTheGame()
        }
    }
    
    func unPauseTheGame() {
        gameIsPaused = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
        starsLayer.isPaused = false
    }
    
    func resetTheGame() {
        score = 0
        scoreLabel.text = "Score: \(score)"
        
        gameIsPaused = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.8)
        scene?.size = UIScreen.main.bounds.size
        
        //size
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        spaceBackground = SKSpriteNode(imageNamed: "spaceBackground")
        spaceBackground.size = CGSize(width: width + 50, height: height + 50)
        
        addChild(spaceBackground)
        
        //stars
        let starPath = Bundle.main.path(forResource: "Stars", ofType: "sks")
        let starsEmiter = NSKeyedUnarchiver.unarchiveObject(withFile: starPath!) as? SKEmitterNode
        
        starsEmiter?.zPosition = 1
        starsEmiter?.position = CGPoint(x: frame.midX, y: frame.height / 2)
        starsEmiter?.particlePositionRange.dx = frame.width
        starsEmiter?.advanceSimulationTime(10)
        
        starsLayer = SKNode()
        starsEmiter?.zPosition = 1
        addChild(starsLayer)
        
        starsLayer.addChild(starsEmiter!)
        
        //2 init node
        spaceShip = SKSpriteNode(imageNamed: "spaceship-1")
        spaceShip.xScale = 0.5
        spaceShip.yScale = 0.5
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = false
        
        spaceShip.physicsBody?.categoryBitMask = spaceShipCategory
        spaceShip.physicsBody?.collisionBitMask = asteroidCategory | asteroidCategory
        spaceShip.physicsBody?.contactTestBitMask = asteroidCategory
        
        let colorAction1 = SKAction.colorize(with: .cyan, colorBlendFactor: 1, duration: 1)
        let colorAction2 = SKAction.colorize(with: .white, colorBlendFactor: 0, duration: 1)
        
        let colorSequenceAnimation = SKAction.sequence([colorAction1, colorAction2])
        let colorActionRepeat = SKAction.repeatForever(colorSequenceAnimation)
        
        spaceShip.run(colorActionRepeat)
        
        //addChild(spaceShip)
        
        //create layer for starShip & fire
        spaceShipLayer = SKNode()
        spaceShipLayer.addChild(spaceShip)
        spaceShipLayer.zPosition = 3
        spaceShip.zPosition = 1
        spaceShipLayer.position = CGPoint(x: frame.midX, y: frame.height / 4)
        addChild(spaceShipLayer)
        
        //create fire
        let firePath = Bundle.main.path(forResource: "Fire", ofType: "sks")
        let fireEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: firePath!) as? SKEmitterNode
        fireEmitter?.zPosition = 0
        fireEmitter?.position.y = -30
        fireEmitter?.targetNode = self
        spaceShipLayer.addChild(fireEmitter!)
        
        //generation asteroid
        asteroidLayer = SKNode()
        asteroidLayer.zPosition = 2
        addChild(asteroidLayer)
        
        let asteroidCreate = SKAction.run { 
            let asteroid = self.createAsteroid()
            self.asteroidLayer.addChild(asteroid)
            asteroid.zPosition = 2
        }
        let asteroidPerSecond: Double = 2
        let asteroidCreationDelay = SKAction.wait(forDuration: 1.0 / asteroidPerSecond, withRange: 0.5)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreate, asteroidCreationDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction)
        
        self.asteroidLayer.run(asteroidRunAction)
        
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.position = CGPoint(x: frame.size.width / scoreLabel.frame.size.width, y: 300)
        addChild(scoreLabel)
        
        spaceBackground.zPosition = 0
        //spaceShip.zPosition = 1
        scoreLabel.zPosition = 3
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameIsPaused {
        if let touch = touches.first {
            //3 find touch
            let touchLocation = touch.location(in: self)
            
            let distance = distanceCalc(a: spaceShip.position, b: touchLocation)
            let speed: CGFloat = 500
            let time = timeToIntervalDistance(distance: distance, speed: speed)
            let moveAction = SKAction.move(to: touchLocation, duration: time)
            moveAction.timingMode = SKActionTimingMode.easeInEaseOut
            
            spaceShipLayer.run(moveAction)
            
            let bgMoveAction = SKAction.move(to: CGPoint(x: -touchLocation.x / 100,
                                                         y: -touchLocation.y / 100),
                                             duration: time)
            spaceBackground.run(bgMoveAction)
            }
        }
    }
    
    func distanceCalc(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y))
    }
    
    func timeToIntervalDistance(distance: CGFloat, speed: CGFloat) -> TimeInterval {
        let time = distance / speed
        return TimeInterval(time)
    }
    
    func createAsteroid() -> SKSpriteNode {
        let asteroid = SKSpriteNode(imageNamed: "asteroid")
        
        let ramdomScale = CGFloat(GKARC4RandomSource.sharedRandom().nextInt(upperBound: 6)) / 10
        
        asteroid.xScale = ramdomScale
        asteroid.yScale = ramdomScale
        
        asteroid.position.x = CGFloat(GKARC4RandomSource.sharedRandom().nextInt(upperBound: 16))
        asteroid.position.y = frame.size.height + asteroid.size.height
        
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.size)
        asteroid.name = "asteroid"
        
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.collisionBitMask = spaceShipCategory
        asteroid.physicsBody?.contactTestBitMask = spaceShipCategory
        
        let asteroidSpeedX: CGFloat = 100.0
        asteroid.physicsBody?.angularVelocity = CGFloat(drand48() * 2 - 1) * 3
        asteroid.physicsBody?.velocity.dx = CGFloat(drand48() * 2 - 1) * asteroidSpeedX
        
        return asteroid
    }
    
    override func update(_ currentTime: TimeInterval) {
        
//        let asteroid = createAsteroid()
//        addChild(asteroid)
    }
    
    override func didSimulatePhysics() {
        asteroidLayer.enumerateChildNodes(withName: "asteroid") { (asteroid, stop) in
            let heightScreen =  UIScreen.main.bounds.height
            if asteroid.position.y < -heightScreen {
                asteroid.removeFromParent()
                
                self.score = self.score + 1
                self.scoreLabel.text = "Score: \(self.score)"
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == spaceShipCategory && contact.bodyB.categoryBitMask == asteroidCategory ||
            contact.bodyB.categoryBitMask == spaceShipCategory && contact.bodyA.categoryBitMask == asteroidCategory {
            self.score = 0
            self.scoreLabel.text = "Score: \(self.score)"
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}








