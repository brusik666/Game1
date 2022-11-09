//
//  SKPlayerNode.swift
//  Game1
//
//  Created by Brusik on 09.11.2022.
//

import Foundation
import SpriteKit

class SKPlayerNode: SKSpriteNode {
    func jump() {
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
    }
    
    func runForwardAnimation(direction: String) {
        var runningTextures = [SKTexture]()
        for i in 1...9 {
            if direction == "forward" {
                runningTextures.append(SKTexture(imageNamed: "foxRun\(i)"))
            } else {
                runningTextures.append(SKTexture(imageNamed: "foxRun\(i)reversed"))
            }
        }
        let runningAnimation = SKAction.animate(with: runningTextures, timePerFrame: 0.05)
        let loop = SKAction.repeatForever(runningAnimation)
        self.removeAction(forKey: "idle")
        self.run(loop, withKey: "runningLoop")
    }
    
    func idleAnimation() {
        var idleTextures = [SKTexture]()
        for i in 1...6 {
            idleTextures.append(SKTexture(imageNamed: "foxIDLE\(i)"))
        }
        let idleAnimation = SKAction.animate(with: idleTextures, timePerFrame: 0.15)
        let repeatAction = SKAction.repeatForever(idleAnimation)
        self.run(repeatAction, withKey: "idle")
    }
}
