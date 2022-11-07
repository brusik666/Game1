//
//  GameViewController.swift
//  Game1
//
//  Created by Brusik on 04.11.2022.
//

import SpriteKit
import UIKit
import GameKit

class GameViewController: UIViewController {
    
    var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        configureGameScene()
        
    }
    
    private func configureGameScene() {
        let skView = view as! SKView
        let scene = GameScene()
        self.scene = scene
        scene.scaleMode = .resizeFill
        scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
}
