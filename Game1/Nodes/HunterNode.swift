//
//  HunterNode.swift
//  Game1
//
//  Created by Brusik on 11.11.2022.
//

import Foundation
import SpriteKit

class HunterNode: SKSpriteNode {
    
    
    fileprivate func configure() {
        zPosition = 2
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width/2, height: size.height))
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = true
        physicsBody?.mass = 1
        physicsBody?.categoryBitMask = PhysicsCategory.hunter.rawValue
        setScale(0.5)
        //hunter.xScale = 0.5
        //hunter.yScale = 0.5
    }
    
    private func runAnimation() {
        var runningTextures = [SKTexture]()
        for i in 1...6 {
            runningTextures.append(SKTexture(imageNamed: "hunter\(i)"))
        }
        let runningAnimation = SKAction.animate(with: runningTextures, timePerFrame: 0.05)
        let loop = SKAction.repeatForever(runningAnimation)
        self.run(loop)
    }
    
    func move() {
        let xVector = CGFloat(-50)
        let moveAction = SKAction.move(by: CGVector(dx: xVector, dy: 0), duration: 0.2)
        let repeatMove = SKAction.repeatForever(moveAction)
        runAnimation()
        run(repeatMove)
    }
    
    func shot() {
        let projectile = createProjectile()
        addChild(projectile)
        let direction: CGPoint
        direction = CGPoint(x: position.x - UIScreen.main.bounds.width * 2, y: position.y)
    
        let throwAction = SKAction.move(to: direction, duration: 0.5)
        let throwActionDone = SKAction.removeFromParent()
        let thorwSequence = SKAction.sequence([throwAction, throwActionDone])
        let soundAction = SKAction.playSoundFileNamed("shurikenSwing", waitForCompletion: false)
        let waitAction = SKAction.wait(forDuration: 0.25)
        let group = SKAction.group([waitAction ,thorwSequence, soundAction])
        projectile.run(group)

    }
    
    
    private func createProjectile() -> SKShapeNode {
        let projectile = SKShapeNode(circleOfRadius: 30)
        projectile.fillColor = SKColor.black
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile.rawValue
        projectile.position = CGPoint(x: position.x, y: position.y)
        
        return projectile
    }
}

struct HunterFabric {
    
    func createHunterNode(parentNode: SKCameraNode) -> HunterNode {
        let hunter = HunterNode(imageNamed: "hunter1")
        hunter.configure()
        hunter.position = CGPoint(x: parentNode.frame.width/2 + hunter.size.width, y: CGFloat(300))
        parentNode.addChild(hunter)
        
        return hunter
    }
    
    
}
