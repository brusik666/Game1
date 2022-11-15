//
//  GameOverDelegate.swift
//  Game1
//
//  Created by Brusik on 15.11.2022.
//

import Foundation

protocol GameOverDelegate: AnyObject {
    func gameOver(winCondition: Bool)
}
