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
        
        physicsWorld.contactDelegate = self
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
        let xConstraint = SKConstraint.positionX(SKRange(lowerLimit: 0 + player.size.width, upperLimit: backgroundNode.frame.maxX * 2 - player.size.width))
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
        //createEggsNodes()
    }
    
    private func addGroundNodes() {
        let width = frame.width
        guard let levelLenght = childNode(withName: "background")?.frame.size.width else { return }
        let groundNodesCount = Int(levelLenght / width)
        var lastNodePosition = CGFloat(0)
        var xPosition: CGFloat { lastNodePosition + width/2 }
        for i in 1...groundNodesCount {
            
            if i % 2 != 0 {
                let groundNode = createGroundNode(xPosition: xPosition, width: width)
                addChild(groundNode)
                let upperHightGroundNode = createHighGroundNode(xPosition: xPosition, yPosition: frame.height, width: width)
                addChild(upperHightGroundNode)
            } else {
                let highGroundNode = createHighGroundNode(xPosition: xPosition, yPosition: frame.height/2, width: width/2)
                highGroundNode.name = "highGround"
                addChild(highGroundNode)
            }
            //let hasd = HunterFabric().createHunterNode(parentNode: groundNode)
            //addChild(groundNode)
            lastNodePosition += width
        }
    }
    
    private func createGroundNode(xPosition: CGFloat, width: CGFloat) -> SKSpriteNode {
        let groundNode = SKSpriteNode(imageNamed: "ground")
        groundNode.name = "ground"
        groundNode.zPosition = 1
        groundNode.size.width = width
        groundNode.size.height = frame.height/5
        groundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: groundNode.size.height - 20))
        groundNode.physicsBody?.isDynamic = false
        groundNode.physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
        groundNode.position.x = xPosition
        return groundNode
    }
    
    private func createHighGroundNode(xPosition: CGFloat, yPosition: CGFloat, width: CGFloat) -> SKSpriteNode {
        let highGroundNode = SKSpriteNode(imageNamed: "highGround")
        highGroundNode.zPosition = 1
        highGroundNode.size.width = width
        highGroundNode.size.height = frame.height/10
        highGroundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width/2, height: highGroundNode.size.height - 20))
        highGroundNode.physicsBody?.isDynamic = false
        highGroundNode.position.x = xPosition
        highGroundNode.position.y = yPosition
        return highGroundNode
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
    
    private func createEggsNodes() {
        for ground in children.filter({$0.name == "highGround"}) {
            let eggNode = SKSpriteNode(imageNamed: "egg")
            eggNode.size = CGSize(width: player.size.width/4, height: player.size.height/4)
            eggNode.physicsBody = SKPhysicsBody(texture: eggNode.texture!, size: eggNode.size)
            eggNode.physicsBody?.affectedByGravity = false
            eggNode.physicsBody?.isDynamic = true
            eggNode.physicsBody?.categoryBitMask = PhysicsCategory.egg.rawValue
            eggNode.physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
            eggNode.physicsBody?.contactTestBitMask = PhysicsCategory.projectile.rawValue
            eggNode.position = ground.position
            ground.addChild(eggNode)
        }
    }
    
    private func setCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        let yConstraint = SKConstraint.positionY(SKRange(lowerLimit: 0, upperLimit: backgroundNode.size.height - frame.height/2 - frame.height/4))
        let xConstraint = SKConstraint.positionX(SKRange(lowerLimit: 0 + frame.size.width/2 + frame.size.width/4, upperLimit: backgroundNode.frame.maxX * 2 - frame.size.width/2 - frame.size.width/4))
        cameraNode.setScale(2)
        cameraNode.constraints = [xConstraint, yConstraint]
        addChild(cameraNode!)
    }
    
    private func stopCamera() {
        cameraNode?.removeAllActions()
    }
    
    private func updateCamera() {
        let position: CGPoint
        let cameraYposition = CGFloat(player.position.y + player.size.height/2)
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

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
          firstBody = contact.bodyA
          secondBody = contact.bodyB
        } else {
          firstBody = contact.bodyB
          secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.egg.rawValue != 0) && (secondBody.categoryBitMask & PhysicsCategory.projectile.rawValue != 0)) {
          if let egg = firstBody.node as? SKSpriteNode,
             let projectile = secondBody.node as? SKSpriteNode {
              egg.removeFromParent()
              projectile.removeFromParent()
          }
        }
    }
}
