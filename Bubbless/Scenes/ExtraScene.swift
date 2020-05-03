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
    
    var score = 0
    var lives = 0
    
    private var entities = Set<GKEntity>()
    
}

// MARK: - Scene Events

extension ExtraScene {
    
    override func didMove(to view: SKView) {
        // Настраиваем параметры сцены игры
        addPhysicsEdges()
        
        // Размещаем элементы окружения
        configureScoreLabel()
        
        // Размещаем кнопки
        configureMessageButton(withDelay: 0)
        configureDeclineButton(withDelay: 2)
        configurePlayButton(withDelay: 4)
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

// MARK: - UI Entities

extension ExtraScene {
    
    private func configureScoreLabel() {
        let scoreLabel = ScoreLabel()
        
        if let node = scoreLabel.component(ofType: NodeComponent.self)?.node {
            node.zPosition = 0
            
            if let labelNode = scoreLabel.component(ofType: LabelComponent.self)?.node {
                labelNode.text = String(score)
            }
        }
        
        addEntity(scoreLabel)
    }
    
    private func configurePlayButton(withDelay sec: TimeInterval) {
        let size = CGSize(width: frame.width / 2, height: frame.width / 2)
        let color = SKColor(red: 0.83, green: 0.18, blue: 0.18, alpha: 1.00)
        
        let button = Button(size: size, color: color)
        button.name = "Watch Ads"
        
        if let node = button.component(ofType: NodeComponent.self)?.node {
            node.position = CGPoint(x: frame.midX - size.width / 2, y: frame.maxY * 2)
            node.zPosition = 1
            
            if let labelNode = button.component(ofType: LabelComponent.self)?.node {
                labelNode.text = "Watch Ads"
                labelNode.preferredMaxLayoutWidth = size.width - 56
                labelNode.lineBreakMode = .byTruncatingTail
                labelNode.numberOfLines = 0
            }
        }
        
        self.run(.wait(forDuration: sec)) {
            self.addEntity(button)
        }
    }
    
    private func configureDeclineButton(withDelay sec: TimeInterval) {
        let size = CGSize(width: frame.width / 2, height: frame.width / 2)
        let color = SKColor(red: 0.96, green: 0.49, blue: 0.00, alpha: 1.00)
        
        let button = Button(size: size, color: color)
        button.name = "Decline"
        
        if let node = button.component(ofType: NodeComponent.self)?.node {
            node.position = CGPoint(x: frame.midX + size.width / 2, y: frame.maxY * 2)
            node.zPosition = 1
            
            if let labelNode = button.component(ofType: LabelComponent.self)?.node {
                labelNode.text = "Decline"
                labelNode.preferredMaxLayoutWidth = size.width - 56
                labelNode.lineBreakMode = .byTruncatingTail
                labelNode.numberOfLines = 0
            }
        }
        
        self.run(.wait(forDuration: sec)) {
            self.addEntity(button)
        }
    }
    
    private func declineButtonPressed() {
        if let scene = GKScene(fileNamed: "StartScene") {
            if let sceneNode = scene.rootNode as? StartScene {
                sceneNode.size = self.size
                
                let task = DispatchGroup()
                let buttons = entities.filter { $0 is Button }
                
                for button in buttons as! Set<Button> {
                    task.enter()
                    
                    button.select {
                        button.hide {
                            self.removeEntity(button)
                            
                            task.leave()
                        }
                    }
                }
                
                task.notify(queue: .main) {
                    let sceneTransition = SKTransition.fade(with: SKColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00), duration: 0.5)
                    sceneTransition.pausesOutgoingScene = false
                    
                    self.view?.presentScene(sceneNode, transition: sceneTransition)
                }
            }
        }
    }
    
    private func configureMessageButton(withDelay sec: TimeInterval) {
        let size = CGSize(width: frame.width / 2, height: frame.width / 2)
        let color = SKColor(red: 0.27, green: 0.35, blue: 0.39, alpha: 1.00)
        
        let button = Button(size: size, color: color)
        button.name = "How about an extra life?"
        
        if let node = button.component(ofType: NodeComponent.self)?.node {
            node.position = CGPoint(x: frame.midX, y: frame.maxY * 2)
            node.zPosition = 1
            
            if let labelNode = button.component(ofType: LabelComponent.self)?.node {
                labelNode.text = "How about an extra life?"
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

// MARK: - Touch Events

extension ExtraScene {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if let button = node.entity as? Button {
                if button.name == "Decline" {
                    declineButtonPressed()
                }
            }
        }
    }
    
}
