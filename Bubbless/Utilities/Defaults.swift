//
//  Defaults.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 04.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import Foundation

class Defaults {
    
    // MARK: - Types
    
    static let shared = Defaults()
    
    // MARK: - Constants
    
    private let adsDisabledKey = "adsDisabledKey"
    
    // MARK: - Properties
    
    var adsDisabled: Bool {
        get { return   UserDefaults.standard.bool(forKey: adsDisabledKey) }
        set { UserDefaults.standard.set(newValue, forKey: adsDisabledKey) }
    }
    
}
