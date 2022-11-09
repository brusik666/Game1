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
    let player = SKPlayerNode(imageNamed: "foxIDLE1")
    var isSoundOn: Bool = false
    var rightButtonLabel: SKLabelNode!
    var hearts = [SKLabelNode]()
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        self.view?.isMultipleTouchEnabled = true
        if isSoundOn {
            let backGroundMusic = SKAudioNode(fileNamed: "mainTheme")
            addChild(backGroundMusic)
        }
        createBackgroundNode()
        setCamera()
        createControlButtons()
        setupPlayerNode()
        createHearts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.player.physicsBody?.affectedByGravity = true
            self.player.idleAnimation()
        }
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
        let touchedNode = atPoint(touchLocation)
        switch touchedNode.name {
        case "leftButton", "rightButton":
            stopCamera()
            //rightButtonLabel.isUserInteractionEnabled = true
            player.removeAction(forKey: "runningLoop")
            player.idleAnimation()
        default: return
        }
    }
    
    private func setupPlayerNode() {
        
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.mass = 1
        player.physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
        player.xScale = 0.5
        player.yScale = 0.5
        player.position.x = -size.width/4
        cameraNode?.addChild(player)
        
    }
    
    private func createTerrain() {
        
    }
    
    private func createHearts() {
        var distance = CGFloat(0)
        for _ in 0...2 {
            let heartLabel = SKSpriteNode(imageNamed: "heart")
            heartLabel.name = "heart"
            heartLabel.xScale = 0.5
            heartLabel.yScale = 0.5
            heartLabel.position = CGPoint(x: -size.width/2 + heartLabel.size.width + distance, y: size.height/2 - heartLabel.size.height/2)
            heartLabel.zPosition = 3
            cameraNode.addChild(heartLabel)
            
            let scaleAnimation = SKAction.scale(to: 0.55, duration: 0.2)
            let reverseScale = SKAction.scale(to: 0.5, duration: 0.2)
            let sequence = SKAction.sequence([scaleAnimation, reverseScale])
            let loop = SKAction.repeatForever(sequence)
            heartLabel.run(loop)
            distance += heartLabel.size.width
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
        
        //newGround
        
        let groundNode2 = SKSpriteNode(imageNamed: "ground")
        groundNode2.name = "ground"
        groundNode2.anchorPoint = CGPoint(x: 0, y: 0)
        groundNode2.zPosition = 1
        groundNode2.position.y = -frame.height/2
        //groundNode2.position.x = -backgroundNode.size.width/2
        groundNode2.constraints = [SKConstraint.distance(SKRange(constantValue: groundNode2.size.width + 200), to: groundNode)]
        groundNode2.size.height = frame.height * 0.2
        groundNode2.physicsBody = SKPhysicsBody(rectangleOf: groundNode2.size.applying(CGAffineTransform(scaleX: 1, y: 0.5)), center: CGPoint(x: groundNode2.size.width/2, y: groundNode2.size.height/2))
        groundNode2.physicsBody?.isDynamic = false
        
        backgroundNode.addChild(groundNode2)
        
        //newGround
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
        
        rightButtonLabel = SKLabelNode(text: ">")
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
        cameraNode.constraints = [SKConstraint.positionX(SKRange(lowerLimit: -size.width))]
        let width = backgroundNode.frame.width
        cameraNode?.position = CGPoint(x: -width/2 + frame.width/2, y: 0)
        addChild(cameraNode!)
    }
    
    private func moveCameraForward() {
        let moveAction = SKAction.move(by: CGVector(dx: 50, dy: 0), duration: 0.2)
        let repeatMove = SKAction.repeatForever(moveAction)
        cameraNode?.run(repeatMove, withKey: "moveForward")
        player.runForwardAnimation(direction: "forward")
    }
    
    private func moveCameraBackward() {
        
        equalizePlayerPositionInCameraNode()
        let moveAction  = SKAction.move(by: CGVector(dx: -50, dy: 0), duration: 0.2)
        let repeatMove = SKAction.repeatForever(moveAction)
        cameraNode?.run(repeatMove)
        player.runForwardAnimation(direction: "backward")
    }
    
    private func equalizePlayerPositionInCameraNode() {
        //player.position.x = size.width/2-size.width/4
    }
    
    private func stopCamera() {
        cameraNode?.removeAllActions()
    }
    
    private func handleControlButtonsTaps(sender: String) {
        switch sender {
        case "leftButton":
            moveCameraBackward()
        case "rightButton":
            moveCameraForward()
        case "fireButton":
            player.throwShuriken(cameraNode: cameraNode)
        case "jumpButton":
            player.jump()
            //player.physicsBody?.affectedByGravity = true
        default: break
        }
    }
}
