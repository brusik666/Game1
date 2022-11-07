//
//  GameScene.swift
//  Game1
//
//  Created by Brusik on 04.11.2022.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    var cameraNode: SKCameraNode?

    
    override func didMove(to view: SKView) {
        
        createBackgroundNode()
        cameraNode = SKCameraNode()
        camera = cameraNode
        addChild(cameraNode!)
        createControlButtons()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touhedNode = atPoint(touchLocation)
        if let name = touhedNode.name {
            handleControlButtonsTaps(sender: name)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        stopCamera()
    }
    
    private func createBackgroundNode() {
        let backGroundNode = SKSpriteNode(imageNamed: "background")
        backGroundNode.zPosition = -1
        backGroundNode.size.height = self.size.height
        addChild(backGroundNode )
    }
    
    private func createControlButtons() {
        let leftButtonLabel = SKLabelNode(text: "<")
        leftButtonLabel.position = CGPoint(x: -(frame.midX - 50), y: -(frame.midY - 50))
        leftButtonLabel.fontColor = SKColor.black
        leftButtonLabel.fontSize = 50
        leftButtonLabel.zPosition = 10
        leftButtonLabel.name = "leftButton"
        cameraNode?.addChild(leftButtonLabel)
        
        let rightButtonLabel = SKLabelNode(text: ">")
        rightButtonLabel.position = CGPoint(x: leftButtonLabel.position.x + 100, y: -(frame.midY - 50))
        rightButtonLabel.fontSize = 50
        rightButtonLabel.zPosition = 10
        rightButtonLabel.name = "rightButton"
        rightButtonLabel.fontColor = SKColor.black
        cameraNode?.addChild(rightButtonLabel)
        let jumpButtonLabel = SKLabelNode()
        let fireButtonLabel = SKLabelNode()
    }
    
    private func moveCameraForward() {

        let moveAction = SKAction.move(by: CGVector(dx: 50, dy: 0), duration: 0.5)
        let repeatMove = SKAction.repeatForever(moveAction)
        cameraNode?.run(repeatMove)
    }
    
    private func moveCameraBackward() {
        let moveAction  = SKAction.move(by: CGVector(dx: -50, dy: 0), duration: 0.5)
        let repeatMove = SKAction.repeatForever(moveAction)
        cameraNode?.run(repeatMove)
    }
    
    private func stopCamera() {
        cameraNode?.removeAllActions()
    }
    
    private func handleControlButtonsTaps(sender: String) {
        switch sender {
        case "leftButton": moveCameraBackward()
        case "rightButton": moveCameraForward()
        case "fireButton": break
        case "jumpButton": break
        default: break
        }
    }
}
