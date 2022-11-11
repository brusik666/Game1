//
//  BackgroundNode.swift
//  Game1
//
//  Created by Brusik on 11.11.2022.
//

import Foundation
import SpriteKit

class BackgroundNode: SKSpriteNode {
    
    func configure() {
        createBackgroundParts()
        
    }
    
    private func createBackgroundParts() {
        for i in 0...2 {
            let backgroundPartNode = SKSpriteNode(imageNamed: "4145")
            backgroundPartNode.anchorPoint = CGPoint(x: 0, y: 0)
            backgroundPartNode.name = "background"
            backgroundPartNode.zPosition = -1
            backgroundPartNode.position.x = CGFloat(0) + backgroundPartNode.size.width * CGFloat(i)
            
            
            addChild(backgroundPartNode)
        }
        self.size.height = (children.first?.frame.height)!
        self.size.width = CGFloat(children.count) * (children.first?.frame.width)!
    }
    
    
}

