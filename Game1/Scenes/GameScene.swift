//
//  GameScene.swift
//  Game1
//
//  Created by Brusik on 04.11.2022.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    weak var gameOverDelegate: GameOverDelegate?
    var backgroundNode: BackgroundNode!
    var cameraNode: SKCameraNode!
    var eggsRemainLabel: SKLabelNode!
    let player = PlayerNode(imageNamed: "foxIDLE1")
    var isSoundOn: Bool = false
    var rightButtonLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    private var hearts = [SKSpriteNode]() {
        didSet {
            if hearts.isEmpty { gameOver(win: false) }
        }
    }
    
    let formatter = DateComponentsFormatter()
    var timerSeconds: Int = 0 {
        didSet {
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional

            let formattedString = formatter.string(from: TimeInterval(timerSeconds))!
            timerLabel.text = "Time - \(formattedString)"
            print(formattedString)
        }
    }
    private var soundFXPlayer: AVAudioPlayer? = nil
    
    private var eggsCollected = 0 {
        didSet {
            if eggsCollected == allEggsCount {
                gameOver(win: true)
            }
        }
    }
    private var allEggsCount = 0
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.view?.isMultipleTouchEnabled = true
        
        createTerrain()
        setupPlayerNode()
        setCamera()
        createControlButtons()
        createHearts()
        createEggsRemainLabel()
        setupTimerLabel()
        setupTimerActions()
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
    
    private func setupTimerActions() {
        let addOneSecToTimerAction = SKAction.run { [unowned self] in
            self.timerSeconds += 1
        }
        let waitForOneSecAction = SKAction.wait(forDuration: 1)
        let sequecne = SKAction.sequence([waitForOneSecAction, addOneSecToTimerAction])
        let foreverSequence = SKAction.repeatForever(sequecne)
        run(foreverSequence)
    }
    
    
    private func setupPlayerNode() {
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width/2, height: player.size.height))
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
        player.physicsBody?.contactTestBitMask = PhysicsCategory.egg.rawValue
        //player.physicsBody?.collisionBitMask = PhysicsCategory.egg.rawValue
        player.physicsBody?.usesPreciseCollisionDetection = true
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
            let heartNode = SKSpriteNode(imageNamed: "heart")
            heartNode.name = "heart"
            heartNode.xScale = 0.5
            heartNode.yScale = 0.5
            heartNode.position = CGPoint(x: -size.width/2 + heartNode.size.width + distance, y: size.height/2 - heartNode.size.height/2)
            heartNode.zPosition = 3
            hearts.append(heartNode)
            cameraNode.addChild(heartNode)
            
            let scaleAnimation = SKAction.scale(to: 0.55, duration: 0.2)
            let reverseScale = SKAction.scale(to: 0.5, duration: 0.2)
            let sequence = SKAction.sequence([scaleAnimation, reverseScale])
            let loop = SKAction.repeatForever(sequence)
            heartNode.run(loop)
            distance += heartNode.size.width
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
        let width = frame.width
        guard let levelLenght = childNode(withName: "background")?.frame.size.width else { return }
        let groundNodesCount = Int(levelLenght / width)
        var lastNodePosition = CGFloat(0)
        var xPosition: CGFloat { lastNodePosition + width/2 }
        for i in 1...groundNodesCount {
            
            if i % 2 != 0 {
                let groundNode = createGroundNode(xPosition: xPosition, width: width)
                addChild(groundNode)
                
                if i != 1 {
                    let upperHighGroundNode = createHighGroundNode(xPosition: xPosition, yPosition: frame.height, width: width / 3 * 2)
                    upperHighGroundNode.name = "upperHighGround"
                    addChild(upperHighGroundNode)
                    createEggsNodes(parentNode: upperHighGroundNode)
                }
                
            } else {
                let highGroundNode = createHighGroundNode(xPosition: xPosition, yPosition: frame.height/2, width: width/2)
                highGroundNode.name = "highGround"
                addChild(highGroundNode)
                let hunter = createHunterNode(xPosition: xPosition - highGroundNode.size.width/2, yPosition: highGroundNode.position.y + player.size.height/4)
                //hunters.append(hunter)
                highGroundNode.addChild(hunter)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    hunter.move()
                    //hunter.shotLoop()
                }
                
            }
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
        groundNode.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
        groundNode.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
        groundNode.physicsBody?.collisionBitMask = 0
        groundNode.position.x = xPosition
        return groundNode
    }
    
    private func createHighGroundNode(xPosition: CGFloat, yPosition: CGFloat, width: CGFloat) -> SKSpriteNode {
        let highGroundNode = SKSpriteNode(imageNamed: "highGround")
        highGroundNode.zPosition = 1
        highGroundNode.size.width = width
        highGroundNode.size.height = frame.height/10
        highGroundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: highGroundNode.size.height))
        highGroundNode.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
        highGroundNode.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
        highGroundNode.physicsBody?.collisionBitMask = 0
        highGroundNode.physicsBody?.isDynamic = false
        highGroundNode.position.x = xPosition
        highGroundNode.position.y = yPosition
        return highGroundNode
    }
    
    private func createHunterNode(xPosition: CGFloat, yPosition: CGFloat) -> HunterNode {
        let hunter = HunterNode(imageNamed: "hunter1")
        hunter.size = player.size
        hunter.configure()
        hunter.position = CGPoint(x: xPosition, y: yPosition)
        
        return hunter
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
    
    private func createEggsRemainLabel() {
        
        eggsRemainLabel = SKLabelNode(text: "0/\(allEggsCount)")
        eggsRemainLabel.position = CGPoint(x: -size.width/2 + 75, y: size.height/2 - 80)
        eggsRemainLabel.fontColor = SKColor.black
        eggsRemainLabel.fontSize = 25
        eggsRemainLabel.zPosition = 3
        eggsRemainLabel.name = "eggsRemainLabel"
        
        cameraNode?.addChild(eggsRemainLabel)
    }
    
    private func setupTimerLabel() {
        timerLabel = SKLabelNode(text: "Time")
        timerLabel.position = CGPoint(x: -size.width/2 + 75, y: size.height/2 - 120)
        timerLabel.fontColor = SKColor.black
        timerLabel.fontSize = 25
        timerLabel.zPosition = 3
        
        cameraNode.addChild(timerLabel)
    }
    
    private func createEggsNodes(parentNode: SKSpriteNode) {
        let eggsCountOnBlock = parentNode.frame.width / player.size.width * 4
        for i in 0...Int(eggsCountOnBlock) {
            let eggNode = SKSpriteNode(imageNamed: "egg")
            eggNode.name = "egg"
            eggNode.size = CGSize(width: player.size.width/4, height: player.size.height/4)
            eggNode.physicsBody = SKPhysicsBody(circleOfRadius: eggNode.size.width/4)
            eggNode.physicsBody?.affectedByGravity = false
            eggNode.physicsBody?.isDynamic = true
            eggNode.physicsBody?.usesPreciseCollisionDetection = true
            eggNode.physicsBody?.mass = 1
            eggNode.physicsBody?.categoryBitMask = PhysicsCategory.egg.rawValue
            eggNode.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
            eggNode.position.y = parentNode.position.y + player.size.height
            eggNode.position.x = parentNode.frame.minX + CGFloat(i) * eggNode.size.width
            allEggsCount += 1
            addChild(eggNode)
        }
    }
    
    private func setCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        let yConstraint = SKConstraint.positionY(SKRange(lowerLimit: 0 + frame.size.height, upperLimit: backgroundNode.size.height - frame.height))
        let xConstraint = SKConstraint.positionX(SKRange(lowerLimit: 0 + frame.size.width, upperLimit: backgroundNode.frame.maxX * 2 - frame.size.width))
        cameraNode.setScale(2)
        cameraNode.constraints = [xConstraint, yConstraint]
        addChild(cameraNode)
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
    
    private func playSoundFile(name: String) {
        guard isSoundOn,
        let soundUrl = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        
        do {
            soundFXPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            soundFXPlayer?.volume = 0.5
            if player.isOnGround {
                soundFXPlayer!.play()
            }
        } catch {
            print(error)
        }
    }
    
    private func gameOver(win: Bool) {
        self.isPaused = true
        gameOverDelegate?.gameOver(winCondition: win)
    }
    
    private func handleControlButtonsTaps(sender: String) {
        switch sender {
        case "leftButton":
            player.run(direction: .backward)
        case "rightButton":
            player.run(direction: .forward)
        case "fireButton":
            player.throwShuriken()
            playSoundFile(name: "shurikenSwing")
        case "jumpButton":
            
            player.jump()
            playSoundFile(name: "jump")
            
        default: break
        }
    }
    
    override func update(_ currentTime: TimeInterval) {

        updateCamera()
        if player.position.y < position.y {
            hearts.forEach({$0.removeFromParent()})
            gameOver(win: false)
        }
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
        
        if ((firstBody.categoryBitMask & PhysicsCategory.player.rawValue != 0) && (secondBody.categoryBitMask & PhysicsCategory.egg.rawValue != 0)) {
            if let _ = firstBody.node as? PlayerNode,
             let node = secondBody.node as? SKSpriteNode, node.name == "egg" {
              node.removeFromParent()
              let eggLabel = cameraNode.childNode(withName: "eggsRemainLabel") as? SKLabelNode
              eggsCollected += 1
              eggLabel?.text = "\(eggsCollected)/\(allEggsCount)"
          }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.shuriken.rawValue != 0) && (secondBody.categoryBitMask & PhysicsCategory.hunter.rawValue != 0)) {
            if let shuriken = firstBody.node as? SKSpriteNode,
               let hunter = secondBody.node as? HunterNode {
                hunter.removeFromParent()
                shuriken.removeFromParent()
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.player.rawValue != 0) && (secondBody.categoryBitMask & PhysicsCategory.ground.rawValue != 0)) {
            
            player.isOnGround = true
            player.speed = 1
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.player.rawValue != 0) && (secondBody.categoryBitMask & PhysicsCategory.hunter.rawValue != 0)) {
            if let _ = firstBody.node as? PlayerNode,
               let _ = secondBody.node as? HunterNode {
                let heartNode = hearts.removeLast()
                heartNode.removeFromParent()
            }
            
        }
    }
}
