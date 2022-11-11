//
//  SKPlayerNode.swift
//  Game1
//
//  Created by Brusik on 09.11.2022.
//

import Foundation
import SpriteKit

class PlayerNode: SKSpriteNode {
    
    //private var health = 3
    var movementDirection: MovementDirection = .forward
    func jump() {
        self.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 1000))
    }
    
    private func runAnimation(direction: MovementDirection) {
        movementDirection = direction
        var runningTextures = [SKTexture]()
        for i in 1...9 {
            if direction == .forward {
                runningTextures.append(SKTexture(imageNamed: "foxRun\(i)"))
            } else {
                runningTextures.append(SKTexture(imageNamed: "foxRun\(i)reversed"))
            }
        }
        
        
        let runningAnimation = SKAction.animate(with: runningTextures, timePerFrame: 0.05)
        let loop = SKAction.repeatForever(runningAnimation)
        self.removeAction(forKey: "idle")
        self.run(loop, withKey: "runningAnimationLoop")
    }
    
    func run(direction: MovementDirection) {
        let xVector = direction == .forward ? CGFloat(50): CGFloat(-50)
        let moveAction = SKAction.move(by: CGVector(dx: xVector, dy: 0), duration: 0.2)
        let repeatMove = SKAction.repeatForever(moveAction)
        runAnimation(direction: direction)
        run(repeatMove, withKey: "run")
    }
    
    func stopRunning() {
        removeAction(forKey: "run")
        removeAction(forKey: "runningAnimationLoop")
        idleAnimation()
    }
    
    func idleAnimation() {
        var idleTextures = [SKTexture]()
        for i in 1...6 {
            if movementDirection == .forward {
                idleTextures.append(SKTexture(imageNamed: "foxIDLE\(i)"))
            } else {
                idleTextures.append(SKTexture(imageNamed: "foxIDLE\(i)reversed"))
            }
        }
        let idleAnimation = SKAction.animate(with: idleTextures, timePerFrame: 0.15)
        let repeatAction = SKAction.repeatForever(idleAnimation)
        self.run(repeatAction, withKey: "idle")
    }
    
    func throwShuriken() {
        let shuriken = createShurikenNode()
        
        let direction: CGPoint
        if self.movementDirection == .forward {
            direction = CGPoint(x: parent!.position.x + UIScreen.main.bounds.width * 2 , y: parent!.position.y)
            shuriken.position = CGPoint(x: parent!.position.x + shuriken.size.width * 3, y: parent!.position.y)
            
        } else {
            direction = CGPoint(x: parent!.position.x - UIScreen.main.bounds.width * 2, y: parent!.position.y)
            shuriken.position = CGPoint(x: parent!.position.x - shuriken.size.width * 3, y: parent!.position.y)
        }
        addChild(shuriken)
    
        let throwAction = SKAction.move(to: direction, duration: 0.5)
        let throwActionDone = SKAction.removeFromParent()
        let thorwSequence = SKAction.sequence([throwAction, throwActionDone])
        let soundAction = SKAction.playSoundFileNamed("shurikenSwing", waitForCompletion: false)
        let group = SKAction.group([thorwSequence, soundAction])
        shuriken.run(group)
    }
    
    private func createShurikenNode() -> SKSpriteNode {
        let shuriken = SKSpriteNode(imageNamed: "shuriken")
        shuriken.position = self.position
        shuriken.size.height = size.height/3.5
        shuriken.size.width = size.width/3.5
        shuriken.physicsBody = SKPhysicsBody(circleOfRadius: shuriken.size.width/2)
        shuriken.physicsBody?.isDynamic = true
        //shuriken.physicsBody?.categoryBitMask = PhysicsCategory.shuriken.rawValue
        //shuriken.physicsBody?.contactTestBitMask = PhysicsCategory.monster.rawValue
        //shuriken.physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
        shuriken.physicsBody?.usesPreciseCollisionDetection = true
        return shuriken
    }
}

enum MovementDirection {
    case forward
    case backward
}
