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
    
    private var scoreLabel: UILabel!
    var scene: GameScene
    
    init?(coder: NSCoder, sounds: Bool) {
        self.scene = GameScene(size: UIScreen.main.bounds.size)
        self.scene.isSoundOn = sounds
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        configureGameScene()
    }
    
    private func configureGameScene() {
        let skView = view as! SKView
        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
    }
}
