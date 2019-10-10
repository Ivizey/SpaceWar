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
    func pauseViewControllerSoundButton(_ viewController: PauseViewController)
    func pauseViewControllerMusicButton(_ viewController: PauseViewController)
}

class PauseViewController: UIViewController {
    
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    
    var delegate: PauseVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func soundButtonPress(_ sender: Any) {
        delegate.pauseViewControllerSoundButton(self)
    }
    @IBAction func musicButtonPress(_ sender: Any) {
        delegate.pauseViewControllerMusicButton(self)
    }
    
    
    @IBAction func playButtonPress(_ sender: UIButton) {
        delegate.pauseViewControllerPlayButton(self)
    }
    @IBAction func storeButtonPress(_ sender: UIButton) {
        
    }
    @IBAction func menuButtonPress(_ sender: UIButton) {
        
    }
}
