//
//  Bubble.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 02.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class Bubble: GKEntity {
    
    // MARK: - Properties
    
    let size: CGSize
    let color: SKColor
    
    // MARK: - Initializers
    
    init(size: CGSize, color: SKColor) {
        self.size = size
        self.color = color
        
        super.init()
        
        let node = NodeComponent()
        addComponent(node)
        
        let shape = ShapeComponent(rectOf: size, cornerRadius: size.height / 2, color: color)
        addComponent(shape)
        
        let physicsBody = PhysicsBodyComponent(physicsBody: SKPhysicsBody(circleOfRadius: size.height / 2))
        addComponent(physicsBody)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let bubble = Bubble(size: size, color: color)
        
        if let rootNode = component(ofType: NodeComponent.self)?.node {
            if let node = bubble.component(ofType: NodeComponent.self)?.node {
                node.position = rootNode.position
            }
        }
        
        return bubble
    }
    
}
