//
//  PauseViewController.swift
//  SpaceWar
//
//  Created by mac on 10.10.19.
//  Copyright © 2019 ivizey. All rights reserved.
//

import UIKit


protocol PauseVCDelegate {
    func pauseViewControllerPlayButton(_ viewController: PauseViewController)
}

class PauseViewController: UIViewController {
    
    var delegate: PauseVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func playButtonPress(_ sender: UIButton) {
        delegate.pauseViewControllerPlayButton(self)
    }
    @IBAction func storeButtonPress(_ sender: UIButton) {
        
    }
    @IBAction func menuButtonPress(_ sender: UIButton) {
        
    }
}
