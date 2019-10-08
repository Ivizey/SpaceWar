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
        
        //size
        let width = UIScreen.main.bounds.width * 2
        let height = UIScreen.main.bounds.height * 2
        
        let spaceBackground = SKSpriteNode(imageNamed: "spaceBackground")
        spaceBackground.size = CGSize(width: width, height: height)
        addChild(spaceBackground)
        
        //2 init node
        spaceShip = SKSpriteNode(imageNamed: "Spaceship-PNG-File")
        addChild(spaceShip)
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
        let asteroid = SKSpriteNode(imageNamed: "meteor")
        asteroid.position.x = CGFloat(GKARC4RandomSource.sharedRandom().nextInt(upperBound: Int(frame.size.height)))
        asteroid.position.y = frame.size.height / 2
        
        return asteroid
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let asteroid = createAsteroid()
        addChild(asteroid)
    }
}