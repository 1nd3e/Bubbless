//
//  SKReview.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 04.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import StoreKit

class SKReview {
    
    // MARK: - Types
    
    static let shared = SKReview()
    
    // MARK: - Methods
    
    // Открывает в App Store секцию Write Review
    func requestReview() {
        if let url = URL(string: "https://itunes.apple.com/app/id1510547305?action=write-review") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // Запрашивает отзыв
    func requestReviewIfAppropriate() {
        let bundleVersionKey = kCFBundleVersionKey as String
        let bundleVersion = Bundle.main.object(forInfoDictionaryKey: bundleVersionKey) as? String
        
        let applicationLaunches = Defaults.shared.applicationLaunches
        let lastBundleVersion = Defaults.shared.lastBundleVersion
        
        if applicationLaunches >= 3 {
            if lastBundleVersion != bundleVersion {
                Defaults.shared.applicationLaunches = 0
                Defaults.shared.lastBundleVersion = bundleVersion
                
                SKStoreReviewController.requestReview()
            }
        }
    }
    
}
