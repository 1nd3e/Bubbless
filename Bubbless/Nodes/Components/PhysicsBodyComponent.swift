//
//  PhysicsBodyComponent.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 02.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class PhysicsBodyComponent: GKComponent {
    
    // MARK: - Properties
    
    let physicsBody: SKPhysicsBody
    
    private var isDynamic: Bool = true
    private var affectedByGravity: Bool = true
    private var allowsRotation: Bool = true
    
    // MARK: - Initializers
    
    init(physicsBody: SKPhysicsBody) {
        self.physicsBody = physicsBody
        
        super.init()
    }
    
    init(physicsBody: SKPhysicsBody, isDynamic: Bool, affectedByGravity: Bool, allowsRotation: Bool) {
        self.physicsBody = physicsBody
        self.isDynamic = isDynamic
        self.affectedByGravity = affectedByGravity
        self.allowsRotation = allowsRotation
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func didAddToEntity() {
        physicsBody.isDynamic = isDynamic
        physicsBody.affectedByGravity = affectedByGravity
        physicsBody.allowsRotation = allowsRotation
        physicsBody.friction = 1
        physicsBody.restitution = 0.5
        physicsBody.linearDamping = 0
        physicsBody.angularDamping = 0
        
        if let node = entity?.component(ofType: NodeComponent.self)?.node {
            node.physicsBody = physicsBody
        }
    }
    
}
