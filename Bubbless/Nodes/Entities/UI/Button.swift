//
//  Button.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 03.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class Button: GKEntity {
    
    init(size: CGSize, color: SKColor) {
        super.init()
        
        let node = NodeComponent()
        addComponent(node)
        
        let shape = ShapeComponent(rectOf: size, cornerRadius: size.height / 2, color: color)
        addComponent(shape)
        
        let label = LabelComponent(fontName: "SFProText-Regular", fontSize: 17, fontColor: SKColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00))
        addComponent(label)
        
        let physicsBody = PhysicsBodyComponent(physicsBody: SKPhysicsBody(circleOfRadius: size.height / 2))
        addComponent(physicsBody)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
