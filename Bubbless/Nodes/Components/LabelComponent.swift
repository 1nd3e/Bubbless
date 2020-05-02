//
//  LabelComponent.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 03.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class LabelComponent: GKComponent {
    
    // MARK: - Properties
    
    let node: SKLabelNode
    
    // MARK: - Initializers
    
    init(fontName: String, fontSize: CGFloat, fontColor: SKColor) {
        node = SKLabelNode()
        node.fontName = fontName
        node.fontSize = fontSize
        node.fontColor = fontColor
        node.horizontalAlignmentMode = .center
        node.verticalAlignmentMode = .center
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func didAddToEntity() {
        if let node = entity?.component(ofType: NodeComponent.self)?.node {
            node.addChild(self.node)
        }
    }
    
}
