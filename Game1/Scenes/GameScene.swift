//
//  GameScene.swift
//  Game1
//
//  Created by Brusik on 04.11.2022.
//

import Foundation
import SpriteKit

class SKPlayerNode: SKShapeNode {
    func jump() {
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
    }
}

class GameScene: SKScene {
    
    var cameraNode: SKCameraNode?
    let player = SKPlayerNode(rectOf: CGSize(width: 32, height: 100))

    override func didMove(to view: SKView) {

        setCamera()
        createBackgroundNode()
        createControlButtons()
        
        player.fillColor = SKColor.cyan
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody()
        player.physicsBody?.affectedByGravity = false
        cameraNode?.addChild(player)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touhedNode = atPoint(touchLocation)
        //player.physicsBody?.affectedByGravity = true
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
        
        let buttonsYposition = -(frame.midY - 50)
        
        let leftButtonLabel = SKLabelNode(text: "<")
        leftButtonLabel.position = CGPoint(x: -(frame.midX - 50), y: buttonsYposition)
        leftButtonLabel.fontColor = SKColor.black
        leftButtonLabel.fontSize = 50
        leftButtonLabel.zPosition = 10
        leftButtonLabel.name = "leftButton"
        cameraNode?.addChild(leftButtonLabel)
        
        let rightButtonLabel = SKLabelNode(text: ">")
        rightButtonLabel.position = CGPoint(x: leftButtonLabel.position.x + 100, y: buttonsYposition)
        rightButtonLabel.fontSize = 50
        rightButtonLabel.zPosition = 10
        rightButtonLabel.name = "rightButton"
        rightButtonLabel.fontColor = SKColor.black
        cameraNode?.addChild(rightButtonLabel)
        
        let jumpButtonLabel = SKShapeNode(circleOfRadius: 25)
        jumpButtonLabel.position = CGPoint(x: frame.midX - 50, y: buttonsYposition)
        jumpButtonLabel.name = "jumpButton"
        jumpButtonLabel.fillColor = SKColor.green
        jumpButtonLabel.zPosition = 10
        cameraNode?.addChild(jumpButtonLabel)
        
        let fireButtonLabel = SKShapeNode(circleOfRadius: 25)
        fireButtonLabel.position = CGPoint(x: jumpButtonLabel.position.x - 75, y: buttonsYposition)
        fireButtonLabel.fillColor = SKColor.red
        fireButtonLabel.zPosition = 10
        cameraNode?.addChild(fireButtonLabel)
    }
    
    private func setCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        addChild(cameraNode!)
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
        case "jumpButton": player.jump()
        default: break
        }
    }
}
