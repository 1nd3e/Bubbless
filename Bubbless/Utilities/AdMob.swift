//
//  AdMob.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 04.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol AdMobDelegate {
    func userDidEarnReward()
    func rewardedAdDidDismiss()
}

class AdMob: NSObject {
    
    // MARK: - Types
    
    static let shared = AdMob()
    
    // MARK: - Properties
    
    var delegate: AdMobDelegate?
    var viewController: UIViewController?
    
    private var rewardedAd: GADRewardedAd?
    
    private var userDidEarnReward = false
    
    // MARK: - Methods
    
    // Initialize Google Mobile Ads SDK.
    func start() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    // Preloads a rewarded ad video.
    func loadRewardedAd() {
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3918999064618425/2456204690")
        
        rewardedAd?.load(GADRequest()) { error in
            if let error = error {
                print("Unable to load ad: \(error.localizedDescription).")
            }
        }
    }
    
    // Shows a rewarded ad video.
    func showRewardedAd() {
        if rewardedAd?.isReady == true {
            if let viewController = viewController {
                rewardedAd?.present(fromRootViewController: viewController, delegate: self)
            }
            
            AudioPlayer.shared.player?.setVolume(0.0, fadeDuration: 1.0)
        } else {
            delegate?.rewardedAdDidDismiss()
        }
    }
    
}

// MARK: - GADRewardedAdDelegate

extension AdMob: GADRewardedAdDelegate {
    
    // Tells the delegate that user did earn reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        userDidEarnReward = true
    }
    
    // Tells the delegate that user did end viewing rewarded ads.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        if userDidEarnReward {
            delegate?.userDidEarnReward()
        } else {
            delegate?.rewardedAdDidDismiss()
        }
        
        AudioPlayer.shared.player?.setVolume(0.8, fadeDuration: 1.0)
    }
    
}
