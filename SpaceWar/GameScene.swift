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
    override func didMove(to view: SKView) {
        
        let spaceShip = SKSpriteNode(imageNamed: "Spaceship-PNG-File")
        
        addChild(spaceShip)
    }
}
