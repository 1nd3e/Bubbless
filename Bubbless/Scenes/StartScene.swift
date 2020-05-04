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
    
    private var adsButton: Button?
    private var restoreButton: Button?
    
    private var entities = Set<GKEntity>()
    
}

// MARK: - Scene Events

extension StartScene {
    
    override func sceneDidLoad() {
        IAPService.shared.delegate = self
    }
    
    override func didMove(to view: SKView) {
        // Настраиваем параметры сцены игры
        addPhysicsEdges()
        
        // Размещаем кнопки
        configureRestoreButton(withDelay: 0)
        configureLeaderboardButton(withDelay: 2)
        configurePlayButton(withDelay: 4)
        configureAdsButton(withDelay: 6)
        configureReviewButton(withDelay: 8)
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
        button.name = "Play"
        
        if let node = button.component(ofType: NodeComponent.self)?.node {
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
    
    private func playButtonPressed() {
        if let scene = GKScene(fileNamed: "GameScene") {
            if let sceneNode = scene.rootNode as? GameScene {
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
    
    private func configureLeaderboardButton(withDelay sec: TimeInterval) {
        let size = CGSize(width: frame.width / 2, height: frame.width / 2)
        let color = SKColor(red: 0.32, green: 0.18, blue: 0.66, alpha: 1.00)
        
        let button = Button(size: size, color: color)
        button.name = "Leaderboard"
        
        if let node = button.component(ofType: NodeComponent.self)?.node {
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
    
    private func leaderboardButtonPressed() {
        GameCenter.shared.presentLeaderboard()
    }
    
    private func configureReviewButton(withDelay sec: TimeInterval) {
        let size = CGSize(width: frame.width / 2, height: frame.width / 2)
        let color = SKColor(red: 0.10, green: 0.46, blue: 0.82, alpha: 1.00)
        
        let button = Button(size: size, color: color)
        button.name = "Review"
        
        if let node = button.component(ofType: NodeComponent.self)?.node {
            node.position = CGPoint(x: frame.midX + size.width / 2, y: frame.maxY * 2)
            node.zPosition = 1
            
            if let labelNode = button.component(ofType: LabelComponent.self)?.node {
                labelNode.text = "Rate Us"
                labelNode.preferredMaxLayoutWidth = size.width - 56
                labelNode.lineBreakMode = .byTruncatingTail
                labelNode.numberOfLines = 0
            }
        }
        
        self.run(.wait(forDuration: sec)) {
            self.addEntity(button)
        }
    }
    
    private func reviewButtonPressed() {
        SKReview.shared.requestReviewManually()
    }
    
    private func configureAdsButton(withDelay sec: TimeInterval) {
        guard Defaults.shared.adsDisabled == false else { return }
        
        let size = CGSize(width: frame.width / 2, height: frame.width / 2)
        let color = SKColor(red: 0.96, green: 0.49, blue: 0.00, alpha: 1.00)
        
        adsButton = Button(size: size, color: color)
        
        if let button = adsButton {
            button.name = "Remove Ads"
            
            if let node = button.component(ofType: NodeComponent.self)?.node {
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
    }
    
    private func removeAdsButton() {
        if let button = adsButton {
            button.select {
                button.hide {
                    self.removeEntity(button)
                }
            }
        }
    }
    
    private func adsButtonPressed() {
        IAPService.shared.removeAds()
    }
    
    private func configureRestoreButton(withDelay sec: TimeInterval) {
        guard Defaults.shared.adsDisabled == false else { return }
        
        let size = CGSize(width: frame.width / 2, height: frame.width / 2)
        let color = SKColor(red: 0.96, green: 0.49, blue: 0.00, alpha: 1.00)
        
        restoreButton = Button(size: size, color: color)
        
        if let button = restoreButton {
            button.name = "Restore Purchases"
            
            if let node = button.component(ofType: NodeComponent.self)?.node {
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
    
    private func removeRestoreButton() {
        if let button = restoreButton {
            button.select {
                button.hide {
                    self.removeEntity(button)
                }
            }
        }
    }
    
    private func restoreButtonPressed() {
        IAPService.shared.restorePurchases()
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

// MARK: - Touch Events

extension StartScene {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if let button = node.entity as? Button {
                if button.name == "Play" {
                    playButtonPressed()
                } else if button.name == "Leaderboard" {
                    leaderboardButtonPressed()
                } else if button.name == "Review" {
                    reviewButtonPressed()
                } else if button.name == "Remove Ads" {
                    adsButtonPressed()
                } else if button.name == "Restore Purchases" {
                    restoreButtonPressed()
                }
            }
        }
    }
    
}

// MARK: - IAPServiceDelegate

extension StartScene: IAPServiceDelegate {
    
    func adsDisabled() {
        removeAdsButton()
        removeRestoreButton()
        
        Defaults.shared.adsDisabled = true
    }
    
}
