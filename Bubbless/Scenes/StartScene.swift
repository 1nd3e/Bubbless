//
//  StartScene.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 03.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {
    
    private var entities = Set<GKEntity>()
    
}

// MARK: - Scene Events

extension StartScene {
    
    override func didMove(to view: SKView) {
        // Настраиваем параметры сцены игры
        addPhysicsEdges()
        
        // Размещаем кнопки
        configureRestoreButton(withDelay: 0)
        configureLeaderboardButton(withDelay: 2)
        configurePlayButton(withDelay: 4)
        configureAdsButton(withDelay: 6)
        configureInviteButton(withDelay: 8)
    }
    
}

// MARK: - Scene Configuration

extension StartScene {
    
    private func addPhysicsEdges() {
        let bodyLT = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.maxY), to: CGPoint(x: frame.minX, y: frame.minY))
        let bodyRT = SKPhysicsBody(edgeFrom: CGPoint(x: frame.maxX, y: frame.maxY), to: CGPoint(x: frame.maxX, y: frame.minY))
        let bodyBT = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x: frame.maxX, y: frame.minY))
        
        let physicsBody = SKPhysicsBody(bodies: [bodyLT, bodyRT, bodyBT])
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        
        self.physicsBody = physicsBody
    }
    
}

// MARK: - UI Entities

extension StartScene {
    
    private func configurePlayButton(withDelay sec: TimeInterval) {
        let size = CGSize(width: frame.width / 2, height: frame.width / 2)
        let color = SKColor(red: 0.83, green: 0.18, blue: 0.18, alpha: 1.00)
        
        let button = Button(size: size, color: color)
        
        if let node = button.component(ofType: NodeComponent.self)?.node {
            node.name = "Let’s Play"
            node.position = CGPoint(x: frame.midX, y: frame.maxY * 2)
            node.zPosition = 1
            
            if let labelNode = button.component(ofType: LabelComponent.self)?.node {
                labelNode.text = "Let’s Play"
                labelNode.preferredMaxLayoutWidth = size.width - 56
                labelNode.lineBreakMode = .byTruncatingTail
                labelNode.numberOfLines = 0
            }
        }
        
        self.run(.wait(forDuration: sec)) {
            self.addEntity(button)
        }
    }
    
    private func configureLeaderboardButton(withDelay sec: TimeInterval) {
        let size = CGSize(width: frame.width / 2, height: frame.width / 2)
        let color = SKColor(red: 0.32, green: 0.18, blue: 0.66, alpha: 1.00)
        
        let button = Button(size: size, color: color)
        
        if let node = button.component(ofType: NodeComponent.self)?.node {
            node.name = "Leaderboard"
            node.position = CGPoint(x: frame.midX - size.width / 2, y: frame.maxY * 2)
            node.zPosition = 1
            
            if let labelNode = button.component(ofType: LabelComponent.self)?.node {
                labelNode.text = "Leaderboard"
                labelNode.preferredMaxLayoutWidth = size.width - 56
                labelNode.lineBreakMode = .byTruncatingTail
                labelNode.numberOfLines = 0
            }
        }
        
        self.run(.wait(forDuration: sec)) {
            self.addEntity(button)
        }
    }
    
    private func configureInviteButton(withDelay sec: TimeInterval) {
        let size = CGSize(width: frame.width / 2, height: frame.width / 2)
        let color = SKColor(red: 0.10, green: 0.46, blue: 0.82, alpha: 1.00)
        
        let button = Button(size: size, color: color)
        
        if let node = button.component(ofType: NodeComponent.self)?.node {
            node.name = "Invite Friends"
            node.position = CGPoint(x: frame.midX + size.width / 2, y: frame.maxY * 2)
            node.zPosition = 1
            
            if let labelNode = button.component(ofType: LabelComponent.self)?.node {
                labelNode.text = "Invite Friends"
                labelNode.preferredMaxLayoutWidth = size.width - 56
                labelNode.lineBreakMode = .byTruncatingTail
                labelNode.numberOfLines = 0
            }
        }
        
        self.run(.wait(forDuration: sec)) {
            self.addEntity(button)
        }
    }
    
    private func configureAdsButton(withDelay sec: TimeInterval) {
        let size = CGSize(width: frame.width / 2, height: frame.width / 2)
        let color = SKColor(red: 0.96, green: 0.49, blue: 0.00, alpha: 1.00)
        
        let button = Button(size: size, color: color)
        
        if let node = button.component(ofType: NodeComponent.self)?.node {
            node.name = "Remove Ads"
            node.position = CGPoint(x: frame.midX - size.width / 2, y: frame.maxY * 2)
            node.zPosition = 1
            
            if let labelNode = button.component(ofType: LabelComponent.self)?.node {
                labelNode.text = "Remove Ads"
                labelNode.preferredMaxLayoutWidth = size.width - 56
                labelNode.lineBreakMode = .byTruncatingTail
                labelNode.numberOfLines = 0
            }
        }
        
        self.run(.wait(forDuration: sec)) {
            self.addEntity(button)
        }
    }
    
    private func configureRestoreButton(withDelay sec: TimeInterval) {
        let size = CGSize(width: frame.width / 2, height: frame.width / 2)
        let color = SKColor(red: 0.96, green: 0.49, blue: 0.00, alpha: 1.00)
        
        let button = Button(size: size, color: color)
        
        if let node = button.component(ofType: NodeComponent.self)?.node {
            node.name = "Restore Purchases"
            node.position = CGPoint(x: frame.midX, y: frame.maxY * 2)
            node.zPosition = 1
            
            if let labelNode = button.component(ofType: LabelComponent.self)?.node {
                labelNode.text = "Restore Purchases"
                labelNode.preferredMaxLayoutWidth = size.width - 56
                labelNode.lineBreakMode = .byTruncatingTail
                labelNode.numberOfLines = 0
            }
        }
        
        self.run(.wait(forDuration: sec)) {
            self.addEntity(button)
        }
    }
    
}

// MARK: - Entity Methods

extension StartScene {
    
    private func addEntity(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let node = entity.component(ofType: NodeComponent.self)?.node {
            addChild(node)
        }
    }
    
    private func removeEntity(_ entity: GKEntity) {
        if let node = entity.component(ofType: NodeComponent.self)?.node {
            node.removeFromParent()
        }
        
        entities.remove(entity)
    }
    
}
