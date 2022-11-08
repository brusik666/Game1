//
//  GameScene.swift
//  Game1
//
//  Created by Brusik on 04.11.2022.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    var groundNode: SKSpriteNode!
    var backgroundNode: SKSpriteNode!
    var cameraNode: SKCameraNode!
    let player = SKPlayerNode(imageNamed: "lisIDLE1")
    
    
    

    override func didMove(to view: SKView) {

        createBackgroundNode()
        setCamera()
        createControlButtons()
        self.view?.isMultipleTouchEnabled = true
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.mass = 1
        player.xScale = 0.5
        player.yScale = 0.5
        
        cameraNode?.addChild(player)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.player.physicsBody?.affectedByGravity = true
        }
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
        let touchedNode = atPoint(touchLocation)
        switch touchedNode.name {
        case "leftButton", "rightButton":
            stopCamera()
            player.removeAction(forKey: "runningLoop")
            player.idleAnimation()
        default: return
        }
        
        
    }
    
    private func createBackgroundNode() {
        
        backgroundNode = SKSpriteNode(imageNamed: "4145")
        backgroundNode.name = "background"
        backgroundNode.zPosition = -1
        backgroundNode.size.height = self.size.height
        
        addChild(backgroundNode )
        
        groundNode = SKSpriteNode(imageNamed: "ground")
        groundNode?.name = "ground"
        groundNode.anchorPoint = CGPoint(x: 0, y: 0)
        groundNode?.zPosition = 1
        groundNode?.position.y = -frame.height/2
        groundNode.position.x = -backgroundNode.size.width/2
        groundNode?.size.height = frame.height * 0.2
        groundNode?.physicsBody = SKPhysicsBody(rectangleOf: groundNode.size.applying(CGAffineTransform(scaleX: 1, y: 0.5)), center: CGPoint(x: groundNode.size.width/2, y: groundNode.size.height/2))
        groundNode.physicsBody?.isDynamic = false
        
        backgroundNode.addChild(groundNode!)
    }
    
    private func createControlButtons() {
        
        let buttonsYposition = -(frame.midY - 25)
        
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
        fireButtonLabel.name = "fireButton"
        fireButtonLabel.fillColor = SKColor.red
        fireButtonLabel.zPosition = 10
        cameraNode?.addChild(fireButtonLabel)
    }
    
    private func setCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        //cameraNode.constraints = [SKConstraint.positionX(SKRange(lowerLimit: -size.width))]
        let width = backgroundNode.frame.width
        cameraNode?.position = CGPoint(x: -width/2 + frame.width/2, y: 0)
        addChild(cameraNode!)
    }
    
    private func moveCameraForward() {

        let moveAction = SKAction.move(by: CGVector(dx: 50, dy: 0), duration: 0.2)
        let repeatMove = SKAction.repeatForever(moveAction)
        cameraNode?.run(repeatMove)
        player.runForwardAnimation()
    }
    
    private func moveCameraBackward() {
        let moveAction  = SKAction.move(by: CGVector(dx: -50, dy: 0), duration: 0.2)
        let repeatMove = SKAction.repeatForever(moveAction)
        cameraNode?.run(repeatMove)
        player.runForwardAnimation()
    }
    
    private func stopCamera() {
        cameraNode?.removeAllActions()
    }
    
    private func handleControlButtonsTaps(sender: String) {
        switch sender {
        case "leftButton": moveCameraBackward()
        case "rightButton": moveCameraForward()
        case "fireButton": break
        case "jumpButton":
            player.jump()
            //player.physicsBody?.affectedByGravity = true
        default: break
        }
    }
}
