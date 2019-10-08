//
//  GameScene.swift
//  SpaceWar
//
//  Created by mac on 08.10.19.
//  Copyright © 2019 ivizey. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //1 Создаем экземпляр node
    var spaceShip: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        scene?.size = UIScreen.main.bounds.size
        
        //size
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let spaceBackground = SKSpriteNode(imageNamed: "spaceBackground")
        spaceBackground.size = CGSize(width: width, height: height)
        addChild(spaceBackground)
        
        //2 init node
        spaceShip = SKSpriteNode(imageNamed: "spaceship-1")
        spaceShip.xScale = 1.0
        spaceShip.yScale = 1.0
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = false
        addChild(spaceShip)
        
        //generation asteroid
        let asteroidCreate = SKAction.run { 
            let asteroid = self.createAsteroid()
            self.addChild(asteroid)
        }
        let asteroidCreationDelay = SKAction.wait(forDuration: 1.0, withRange: 0.5)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreate, asteroidCreationDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction)
        
        run(asteroidRunAction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            //3 определяем точку прикосновения
            let touchLocation = touch.location(in: self)
            print(touchLocation)
            
            //4 создаем действие
            let moveAction = SKAction.move(to: touchLocation, duration: 1)
            spaceShip.run(moveAction)
        }
    }
    
    func createAsteroid() -> SKSpriteNode {
        let asteroid = SKSpriteNode(imageNamed: "asteroid")
        
        let ramdomScale = CGFloat(GKARC4RandomSource.sharedRandom().nextInt(upperBound: 6)) / 10
        
        asteroid.xScale = ramdomScale
        asteroid.yScale = ramdomScale
        
        asteroid.position.x = CGFloat(GKARC4RandomSource.sharedRandom().nextInt(upperBound: 16))
        asteroid.position.y = frame.size.height + asteroid.size.height
        
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.size)
        
        return asteroid
    }
    
    override func update(_ currentTime: TimeInterval) {
        
//        let asteroid = createAsteroid()
//        addChild(asteroid)
    }
}
