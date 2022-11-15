//
//  HunterNode.swift
//  Game1
//
//  Created by Brusik on 11.11.2022.
//

import Foundation
import SpriteKit

class HunterNode: SKSpriteNode {
    
    func configure() {
        zPosition = 2
        name = "hunter"
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width/2, height: size.height))
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.hunter.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.shuriken.rawValue
        physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
        setScale(0.5)
    }
    
    private func runAnimation() {
        var runningTextures = [SKTexture]()
        for i in 1...6 {
            runningTextures.append(SKTexture(imageNamed: "hunter\(i)"))
        }
        let runningAnimation = SKAction.animate(with: runningTextures, timePerFrame: 0.25)
        let loop = SKAction.repeatForever(runningAnimation)
        self.run(loop)
    }
    
    func move() {
        guard let parentNode = parent else { return }
        let moveAction = SKAction.move(to: CGPoint(x: position.x - parentNode.frame.width, y: position.y), duration: 3)
        let moveBackAction = SKAction.move(to: CGPoint(x: position.x, y: position.y), duration: 3)
        let sequence = SKAction.sequence([moveAction, moveBackAction])
        let forever = SKAction.repeatForever(sequence)
        run(forever)
        runAnimation()
    }
    
    func shot() {
        
        let projectile = createProjectile()
        addChild(projectile)
        let direction: CGPoint
        direction = CGPoint(x: position.x - UIScreen.main.bounds.width, y: position.y)
        let shotASD = SKAction.move(to: direction, duration: 1)
        let shotAction = SKAction.applyForce(CGVector(dx: -500, dy: 0), at: projectile.position, duration: 2)
        let shotActionDone = SKAction.removeFromParent()
        let shotSequence = SKAction.sequence([shotASD, shotActionDone])
        projectile.run(shotSequence)
    }
    
    func shotLoop() {
        let oneShotAction = SKAction.run(shot)
        let waitAction = SKAction.wait(forDuration: 1.5)
        let shotSequence = SKAction.sequence([oneShotAction, waitAction])
        let shotLoop = SKAction.repeatForever(shotSequence)
        run(shotLoop)
    }
    
    private func createProjectile() -> SKShapeNode {
        let projectile = SKShapeNode(circleOfRadius: 30)
        projectile.position = position
        projectile.fillColor = SKColor.black
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile.rawValue
        
        return projectile
    }
}

