//
//  GameViewController.swift
//  SpaceWar
//
//  Created by mac on 08.10.19.
//  Copyright © 2019 ivizey. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var gameScene: GameScene!
    var pauseViewController: PauseViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pauseViewController = (storyboard?.instantiateViewController(withIdentifier: "PauseViewController"))
            as! PauseViewController
        
        pauseViewController.delegate = self
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                gameScene = scene as! GameScene
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func hidePauseScreen(viewController: PauseViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.removeFromParentViewController()
        
        viewController.view.alpha = 1
        
        UIView.animate(withDuration: 0.5, animations: { 
            viewController.view.alpha = 0
        }) { (completed) in
            viewController.view.removeFromSuperview()
        }
    }
    
    func showPauseScreen(_ viewController: PauseViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        
        viewController.view.alpha = 0
        UIView.animate(withDuration: 0.5) { 
            viewController.view.alpha = 1
        }
    }
    
    @IBAction func pauseButton(_ sender: UIButton) {
        gameScene.pauseTheGame()
        showPauseScreen(pauseViewController)
        //present(pauseViewController, animated: true, completion: nil)
    }
    
}

extension GameViewController: PauseVCDelegate {
    func pauseViewControllerPlayButton(_ viewController: PauseViewController) {
        hidePauseScreen(viewController: pauseViewController)
        gameScene.unPauseTheGame()
    }
}




