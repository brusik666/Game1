//
//  SKPlayerNode.swift
//  Game1
//
//  Created by Brusik on 09.11.2022.
//

import Foundation
import SpriteKit

class SKPlayerNode: SKSpriteNode {
    
    enum FaceDirection {
        case forward
        case backward
    }
    
    private var health = 3
    var faceDirection: FaceDirection = .forward
    
    func jump() {
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
    }
    
    func runForwardAnimation(direction: String) {
        var runningTextures = [SKTexture]()
        for i in 1...9 {
            if direction == "forward" {
                faceDirection = .forward
                runningTextures.append(SKTexture(imageNamed: "foxRun\(i)"))
            } else {
                faceDirection = .backward
                runningTextures.append(SKTexture(imageNamed: "foxRun\(i)reversed"))
            }
        }
        let runningAnimation = SKAction.animate(with: runningTextures, timePerFrame: 0.05)
        let loop = SKAction.repeatForever(runningAnimation)
        self.removeAction(forKey: "idle")
        self.run(loop, withKey: "runningLoop")
    }
    
    func run() {
        
    }
    
    func idleAnimation() {
        var idleTextures = [SKTexture]()
        for i in 1...6 {
            if faceDirection == .forward {
                idleTextures.append(SKTexture(imageNamed: "foxIDLE\(i)"))
            } else {
                idleTextures.append(SKTexture(imageNamed: "foxIDLE\(i)reversed"))
            }
        }
        let idleAnimation = SKAction.animate(with: idleTextures, timePerFrame: 0.15)
        let repeatAction = SKAction.repeatForever(idleAnimation)
        self.run(repeatAction, withKey: "idle")
    }
    
    func throwShuriken(cameraNode: SKCameraNode) {
        let shuriken = createShurikenNode()
        cameraNode.addChild(shuriken)
        
        let direction = CGPoint(x: UIScreen.main.bounds.width/2 + shuriken.size.width, y: position.y)
        let throwAction = SKAction.move(to: direction, duration: 0.5)
        let throwActionDone = SKAction.removeFromParent()
        let thorwSequence = SKAction.sequence([throwAction, throwActionDone])
        let soundAction = SKAction.playSoundFileNamed("shurikenSwing", waitForCompletion: false)
        let group = SKAction.group([thorwSequence, soundAction])
        shuriken.run(group)
    }
    
    private func createShurikenNode() -> SKSpriteNode {
        let shuriken = SKSpriteNode(imageNamed: "shuriken")
        shuriken.position = CGPoint(x: position.x + size.width/4, y: position.y - 10)
        shuriken.size.height = size.height/3.5
        shuriken.size.width = size.width/3.5
        shuriken.physicsBody = SKPhysicsBody(circleOfRadius: shuriken.size.width/2)
        shuriken.physicsBody?.isDynamic = false
        shuriken.physicsBody?.categoryBitMask = PhysicsCategory.shuriken.rawValue
        shuriken.physicsBody?.contactTestBitMask = PhysicsCategory.monster.rawValue
        //shuriken.physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
        shuriken.physicsBody?.usesPreciseCollisionDetection = true
        return shuriken
    }
}
