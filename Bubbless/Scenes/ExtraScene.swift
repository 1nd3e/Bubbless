//
//  ExtraScene.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 03.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class ExtraScene: SKScene {
    
    private var entities = Set<GKEntity>()
    
}

// MARK: - Scene Events

extension ExtraScene {
    
    override func didMove(to view: SKView) {
        // Настраиваем параметры сцены игры
        addPhysicsEdges()
    }
    
}

// MARK: - Scene Configuration

extension ExtraScene {
    
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

// MARK: - Entity Methods

extension ExtraScene {
    
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
