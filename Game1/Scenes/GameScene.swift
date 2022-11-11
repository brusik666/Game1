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
    var backgroundNode: BackgroundNode!
    var cameraNode: SKCameraNode!
    let player = PlayerNode(imageNamed: "foxIDLE1")
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
            //let backGroundMusic = SKAudioNode(fileNamed: "mainTheme")
            //addChild(backGroundMusic)
        }
        createTerrain()
        setupPlayerNode()
        setCamera()
        createControlButtons()
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
            player.stopRunning()
        default: return
        }
    }
    
    private func setupPlayerNode() {
        player.zPosition = 2
        //player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width/2, height: player.size.height))
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.mass = 2
        player.physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
        player.xScale = 0.5
        player.yScale = 0.5
        player.position.x = frame.width/4
        player.position.y = CGFloat(300)
        let yConstraint = SKConstraint.positionY(SKRange(lowerLimit: -player.size.height, upperLimit: backgroundNode.size.height - player.size.height))
        let xConstraint = SKConstraint.positionX(SKRange(lowerLimit: 0 + player.size.width, upperLimit: backgroundNode.frame.maxX - player.size.width))
        player.constraints = [xConstraint, yConstraint]
        addChild(player)
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
        backgroundNode = BackgroundNode()
        backgroundNode.configure()
        
        addChild(backgroundNode)
    }
    
    private func createTerrain() {
        createBackgroundNode()
        addGroundNodes()
    }
    
    private func addGroundNodes() {
        for i in 1...50 {
            
            let groundNode = SKSpriteNode(imageNamed: "ground")
            groundNode.name = "ground"
            groundNode.zPosition = 1
            groundNode.size.width = frame.width/3
            groundNode.size.height = frame.height/5
            groundNode.position.x = CGFloat(groundNode.size.width/2) * CGFloat(i)
            groundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: groundNode.size.width, height: groundNode.size.height - 20))
            groundNode.physicsBody?.isDynamic = false
            
            addChild(groundNode)
        }
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
        let yConstraint = SKConstraint.positionY(SKRange(lowerLimit: 0, upperLimit: backgroundNode.size.height - frame.height/2 - frame.height/4))
        let xConstraint = SKConstraint.positionX(SKRange(lowerLimit: 0 + frame.size.width/2 + frame.size.width/4, upperLimit: backgroundNode.frame.maxX - frame.size.width/2 - frame.size.width/4))
        cameraNode.setScale(1.25)
        cameraNode.constraints = [xConstraint, yConstraint]
        addChild(cameraNode!)
    }
    
    private func stopCamera() {
        cameraNode?.removeAllActions()
    }
    
    private func updateCamera() {
        let position: CGPoint
        let cameraYposition = CGFloat(player.position.y + player.size.height)
        if player.movementDirection == .backward {
            position = CGPoint(x: player.position.x - frame.width/4, y: cameraYposition)
        } else {
            position = CGPoint(x: player.position.x + frame.width/4, y: cameraYposition)
        }
        let cameraMove = SKAction.move(to: position, duration: 0.2)
        cameraNode.run(cameraMove)
    }
    
    private func handleControlButtonsTaps(sender: String) {
        switch sender {
        case "leftButton":
            player.run(direction: .backward)
        case "rightButton":
            player.run(direction: .forward)
        case "fireButton":
            player.throwShuriken()
        case "jumpButton":
            player.jump()
        default: break
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateCamera()
    }
}
