//
//  ScoreLabel.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 03.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class ScoreLabel: GKEntity {
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        
        let node = NodeComponent()
        addComponent(node)
        
        let label = LabelComponent(fontName: "SFProDisplay-Ultralight", fontSize: 80, fontColor: SKColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.00))
        addComponent(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func set(_ score: Int) {
        if let labelNode = component(ofType: LabelComponent.self)?.node {
            labelNode.text = String(score)
        }
    }
    
}
