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
    
    //1 Создаем экземпляр node
    var spaceShip: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.8)
        scene?.size = UIScreen.main.bounds.size
        
        //size
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let spaceBackground = SKSpriteNode(imageNamed: "spaceBackground")
        spaceBackground.size = CGSize(width: width, height: height)
        addChild(spaceBackground)
        
        //2 init node
        spaceShip = SKSpriteNode(imageNamed: "spaceship-1")
        spaceShip.xScale = 0.5
        spaceShip.yScale = 0.5
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = false
        
        spaceShip.physicsBody?.categoryBitMask = spaceShipCategory
        spaceShip.physicsBody?.collisionBitMask = asteroidCategory
        spaceShip.physicsBody?.contactTestBitMask = asteroidCategory
        
        addChild(spaceShip)
        
        //generation asteroid
        let asteroidCreate = SKAction.run { 
            let asteroid = self.createAsteroid()
            self.addChild(asteroid)
        }
        let asteroidPerSecond: Double = 1
        let asteroidCreationDelay = SKAction.wait(forDuration: 1.0 / asteroidPerSecond, withRange: 0.5)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreate, asteroidCreationDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction)
        
        run(asteroidRunAction)
    }
    
    // C = sqrt((x2 - x1)^2 + (y2 - y1)^2)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            //3 определяем точку прикосновения
            let touchLocation = touch.location(in: self)
            
            let distance = distanceCalc(a: spaceShip.position, b: touchLocation)
            let speed: CGFloat = 500
            let time = timeToIntervalDistance(distance: distance, speed: speed)
            let moveAction = SKAction.move(to: touchLocation, duration: time)
            print("time: \(time)")
            print("distance: \(distance)")
            
            spaceShip.run(moveAction)
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
        
        return asteroid
    }
    
    override func update(_ currentTime: TimeInterval) {
        
//        let asteroid = createAsteroid()
//        addChild(asteroid)
    }
    
    override func didSimulatePhysics() {
        enumerateChildNodes(withName: "asteroid") { (asteroid, stop) in
            let heightScreen =  UIScreen.main.bounds.height
            if asteroid.position.y < -heightScreen {
                asteroid.removeFromParent()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact!")
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}








