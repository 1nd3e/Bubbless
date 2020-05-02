//
//  GameScene.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 02.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var bubbles = [Bubble]()
    
    private var entities = Set<GKEntity>()
    
    override func didMove(to view: SKView) {
        // Настраиваем параметры сцены игры
        addPhysicsEdges()
        
        // Подготавливаем элементы игры к работе
        loadBubbles()
        
        // Запускаем игровую логику
        spawnBubbles()
    }
    
}

// MARK: - Scene

extension GameScene {
    
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

// MARK: - Bubble Entities

extension GameScene {
    
    private func loadBubble(with color: SKColor, size: CGSize, at position: CGPoint) -> Bubble {
        let bubble = Bubble(size: size, color: color)
        
        if let node = bubble.component(ofType: NodeComponent.self)?.node {
            node.position = position
        }
        
        return bubble
    }
    
    private func loadBubbles() {
        let size = CGSize(width: frame.width / 4, height: frame.width / 4)
        
        let colors = [
            SKColor(red: 0.83, green: 0.18, blue: 0.18, alpha: 1.00),
            SKColor(red: 0.32, green: 0.18, blue: 0.66, alpha: 1.00),
            SKColor(red: 0.10, green: 0.46, blue: 0.82, alpha: 1.00),
            SKColor(red: 0.00, green: 0.59, blue: 0.65, alpha: 1.00),
            SKColor(red: 0.22, green: 0.56, blue: 0.24, alpha: 1.00),
            SKColor(red: 0.69, green: 0.71, blue: 0.17, alpha: 1.00),
            SKColor(red: 0.96, green: 0.49, blue: 0.00, alpha: 1.00),
            SKColor(red: 0.27, green: 0.35, blue: 0.39, alpha: 1.00)
        ]
        let positions = [
            CGPoint(x: frame.midX - size.width / 2, y: frame.maxY * 2),
            CGPoint(x: frame.midX - size.width / 2 - size.width, y: frame.maxY * 2),
            CGPoint(x: frame.midX + size.width / 2, y: frame.maxY * 2),
            CGPoint(x: frame.midX + size.width / 2 + size.width, y: frame.maxY * 2),
            CGPoint(x: frame.midX - size.width / 2, y: frame.maxY * 2),
            CGPoint(x: frame.midX - size.width / 2 - size.width, y: frame.maxY * 2),
            CGPoint(x: frame.midX + size.width / 2, y: frame.maxY * 2),
            CGPoint(x: frame.midX + size.width / 2 + size.width, y: frame.maxY * 2)
        ]
        
        for i in 0..<8 {
            bubbles.append(loadBubble(with: colors[i], size: size, at: positions[i]))
        }
    }
    
    private func spawnBubble() {
        let bubbleNumber = randomizeBubble()
        let bubble = bubbles[bubbleNumber].copy() as! Bubble
        
        addEntity(bubble)
    }
    
    private func spawnBubbles() {
        let wait = SKAction.wait(forDuration: 1, withRange: 1)
        let spawn = SKAction.run { self.spawnBubble() }
        let sequence = SKAction.sequence([wait, spawn])
        
        self.run(.repeatForever(sequence))
    }
    
    private func randomizeBubble() -> Int {
        let randomSource = GKMersenneTwisterRandomSource()
        let bubbleNumber = randomSource.nextInt(upperBound: bubbles.count)
        
        return bubbleNumber
    }
    
}

// MARK: - Entity Methods

extension GameScene {
    
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
