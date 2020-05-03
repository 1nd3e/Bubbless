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
    
    func start() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    func loadRewardedAd() {
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        
        rewardedAd?.load(GADRequest()) { error in
            if let error = error {
                print("Unable to load ad: \(error.localizedDescription).")
            }
        }
    }
    
    func showRewardedAd() {
        if rewardedAd?.isReady == true {
            if let viewController = viewController {
                rewardedAd?.present(fromRootViewController: viewController, delegate: self)
            }
        }
    }
    
}

// MARK: - GADRewardedAdDelegate

extension AdMob: GADRewardedAdDelegate {
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        userDidEarnReward = true
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        if userDidEarnReward {
            delegate?.userDidEarnReward()
        }
        
        loadRewardedAd()
    }
    
}
