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
    
    var score = 0
    var lives = 1
    
    private var scoreLabel: ScoreLabel!
    
    private var bubbles = [Bubble]()
    private var selectedBubbles = Set<Bubble>()
    
    private var entities = Set<GKEntity>()
    
    private var isPlaying = true
    
}

// MARK: - Scene Events

extension GameScene {
    
    override func didMove(to view: SKView) {
        // Configure scene.
        addPhysicsEdges()
        
        // Prepare nodes and other gameplay objects.
        loadBubbles()
        prepareAudioPlayer()
        
        // Configure nodes.
        configureScoreLabel()
        
        // Start the game.
        spawnBubbles()
    }
    
}

// MARK: - Scene Configuration

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

// MARK: - UI Entities

extension GameScene {
    
    private func configureScoreLabel() {
        scoreLabel = ScoreLabel()
        
        if let node = scoreLabel.component(ofType: NodeComponent.self)?.node {
            node.zPosition = 0
            
            if let labelNode = scoreLabel.component(ofType: LabelComponent.self)?.node {
                labelNode.text = String(score)
            }
        }
        
        addEntity(scoreLabel)
    }
    
}

// MARK: - Bubble Entities

extension GameScene {
    
    private func loadBubble(with color: SKColor, size: CGSize, at position: CGPoint) -> Bubble {
        let bubble = Bubble(size: size, color: color)
        
        if let node = bubble.component(ofType: NodeComponent.self)?.node {
            node.position = position
            node.zPosition = 1
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
        let randomSource = GKMersenneTwisterRandomSource()
        
        let bubbleNumber = randomSource.nextInt(upperBound: bubbles.count)
        let bubble = bubbles[bubbleNumber].copy() as! Bubble
        
        addEntity(bubble)
    }
    
    private func spawnBubbles() {
        let wait = SKAction.wait(forDuration: 0.5, withRange: 0.5)
        let spawnBubble = SKAction.run { self.spawnBubble() }
        let trackMatch = SKAction.run { self.trackMatch() }
        let sequence = SKAction.sequence([wait, spawnBubble, trackMatch])
        
        self.run(.repeatForever(sequence))
    }
    
    private func selectBubble(_ bubble: Bubble) {
        selectedBubbles.insert(bubble)
        
        if selectedBubbles.count >= 3 {
            var bubbleColors = selectedBubbles.map { $0.color }
            bubbleColors.removeDuplicates()
            
            if bubbleColors.count == 1 {
                for bubble in selectedBubbles {
                    bubble.hide {
                        self.removeEntity(bubble)
                    }
                    
                    score += 1
                    scoreLabel.set(score)
                }
                
                play(soundFileNamed: "success.wav")
            } else {
                for bubble in selectedBubbles {
                    bubble.deselect()
                }
                
                play(soundFileNamed: "fail.wav")
            }
            
            selectedBubbles.removeAll()
        }
    }
    
}

// MARK: - SFX Methods

extension GameScene {
    
    private func play(soundFileNamed soundFile: String) {
        let playSoundFileNamed = SKAction.playSoundFileNamed(soundFile, waitForCompletion: false)
        run(playSoundFileNamed)
    }
    
    private func prepareAudioPlayer() {
        play(soundFileNamed: "silence.wav")
    }
    
}

// MARK: - Match Methods

extension GameScene {
    
    private func trackMatch() {
        let bubbleLimit = 32
        let bubbleEntities = entities.filter { $0 is Bubble }
        
        if bubbleEntities.count >= bubbleLimit {
            isPlaying = false
            
            for bubble in bubbleEntities as! Set<Bubble> {
                bubble.select {
                    bubble.hide {
                        self.removeEntity(bubble)
                    }
                }
            }
            
            matchEnded()
        }
    }
    
    private func matchEnded() {
        if lives > 0 {
            if let scene = GKScene(fileNamed: "ExtraScene") {
                if let sceneNode = scene.rootNode as? ExtraScene {
                    sceneNode.size = self.size
                    
                    sceneNode.score = score
                    sceneNode.lives = lives
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.view?.presentScene(sceneNode)
                    }
                    
                    self.removeAllActions()
                }
                
                play(soundFileNamed: "complete.wav")
            }
        } else {
            if let scene = GKScene(fileNamed: "StartScene") {
                if let sceneNode = scene.rootNode as? StartScene {
                    sceneNode.size = self.size
                    
                    let sceneTransition = SKTransition.fade(with: SKColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00), duration: 0.5)
                    sceneTransition.pausesOutgoingScene = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.view?.presentScene(sceneNode, transition: sceneTransition)
                    }
                    
                    self.removeAllActions()
                }
                
                play(soundFileNamed: "complete.wav")
            }
        }
        
        GameCenter.shared.submit(score: score)
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

// MARK: - Touch Events

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isPlaying else { return }
        
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if let bubble = node.entity as? Bubble {
                bubble.select {
                    self.selectBubble(bubble)
                }
            }
        }
    }
    
}
