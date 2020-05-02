//
//  ShapeComponent.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 02.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class ShapeComponent: GKComponent {
    
    // MARK: - Properties
    
    private let node: SKShapeNode
    
    // MARK: - Initializers
    
    init(rectOf size: CGSize, cornerRadius radius: CGFloat, color: SKColor) {
        node = SKShapeNode(rectOf: size, cornerRadius: radius)
        node.fillColor = color
        node.strokeColor = color
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func didAddToEntity() {
        if let nodeComponent = entity?.component(ofType: NodeComponent.self) {
            nodeComponent.node = node
        }
    }
    
}
