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
    
    // MARK: - Properties
    
    var viewController: UIViewController?
    
    private let localPlayer = GKLocalPlayer.local
    private let leaderboardIdentifier = "ru.1nd3e.Bubbless.Scores"
    
    // MARK: - Methods
    
    // Выполняет аутентификацию пользователя
    func authenticateLocalPlayer() {
        guard localPlayer.isAuthenticated else {
            localPlayer.authenticateHandler = { (vc, error) in
                if let vc = vc {
                    self.viewController?.present(vc, animated: true, completion: nil)
                }
            }

            return
        }
    }
    
    // Открывает экран Leaderboard в Game Center
    func presentLeaderboard() {
        if localPlayer.isAuthenticated {
            let vc = GKGameCenterViewController()
            vc.gameCenterDelegate = self
            
            vc.viewState = .leaderboards
            vc.leaderboardIdentifier = leaderboardIdentifier
            
            viewController?.present(vc, animated: true, completion: nil)
        } else {
            localPlayer.authenticateHandler = { (vc, error) in
                if let vc = vc {
                    self.viewController?.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Отправляет очки в Leaderboard
    func submit(score value: Int) {
        guard localPlayer.isAuthenticated else { return }
        
        let score = GKScore(leaderboardIdentifier: leaderboardIdentifier)
        score.value = Int64(value)
        
        GKScore.report([score], withCompletionHandler: nil)
    }
    
}

// MARK: - GKGameCenterControllerDelegate

extension GameCenter: GKGameCenterControllerDelegate {
    
    // Анимировано закрывает Game Center
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
}
