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
        scene = GameScene(size: UIScreen.main.bounds.size)
        scene.isSoundOn = sounds
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        configureGameScene()
        scene.gameOverDelegate = self
    }
    
    private func configureGameScene() {
        let skView = view as! SKView
        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        //skView.showsPhysics = true
        skView.presentScene(scene)
        
    }
}

extension GameViewController: GameOverDelegate {
    func gameOver(winCondition: Bool) {
        let title = winCondition ? "YOU WON!": "YOU LOST!"
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let tryAgainAction = UIAlertAction(title: "Try again", style: .default) { _ in
            let newScene = GameScene(size: UIScreen.main.bounds.size)
            newScene.isSoundOn = self.scene.isSoundOn
            newScene.scaleMode = .aspectFill
            newScene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            newScene.gameOverDelegate = self
            let animation = SKTransition.fade(withDuration: 1.0)
            let skView = self.view as! SKView
            skView.presentScene(newScene, transition: animation)
        }
        let goToMainMenuAction = UIAlertAction(title: "Go to menu", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(tryAgainAction)
        alertController.addAction(goToMainMenuAction)
        self.present(alertController, animated: true)
    }
    
    
}
