//
//  GameCenter.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 04.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import UIKit
import GameKit

class GameCenter: NSObject {
    
    // MARK: - Types
    
    static let shared = GameCenter()
    
    // MARK: - Public Properties
    
    weak var viewController: UIViewController?
    
    // MARK: - Private Properties
    
    private let localPlayer = GKLocalPlayer.local
    private let leaderboardIdentifier = "ru.1nd3e.Bubbless.Scores"
    
    // MARK: - Methods
    
    // Authenticate user.
    func authenticateLocalPlayer() {
        guard localPlayer.isAuthenticated else {
            localPlayer.authenticateHandler = { [weak self] vc, error in
                if let vc = vc {
                    self?.viewController?.present(vc, animated: true, completion: nil)
                } else if let error = error {
                    print("Unable authenticate the player: \(error.localizedDescription).")
                }
            }
            
            return
        }
    }
    
    // Presents a leaderboard screen in Game Center.
    func presentLeaderboard() {
        guard localPlayer.isAuthenticated else { return }
        
        let vc = GKGameCenterViewController()
        vc.gameCenterDelegate = self
        
        vc.viewState = .leaderboards
        vc.leaderboardIdentifier = leaderboardIdentifier
        
        viewController?.present(vc, animated: true, completion: nil)
    }
    
    // Submits some points to leaderboard.
    func submit(score value: Int) {
        guard localPlayer.isAuthenticated else { return }
        
        let score = GKScore(leaderboardIdentifier: leaderboardIdentifier)
        score.value = Int64(value)
        
        GKScore.report([score], withCompletionHandler: nil)
    }
    
}

// MARK: - GKGameCenterControllerDelegate

extension GameCenter: GKGameCenterControllerDelegate {
    
    // Animated closes Game Center.
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
    
}
