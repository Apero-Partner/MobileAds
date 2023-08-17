//
//  AdMobFullScreenType.swift
//  MobileAds
//
//  Created by Quang Ly Hoang on 23/02/2022.
//

import Foundation
import UIKit

enum AdMobFullScreenType {
    case interstitial(id: AdUnitID)
    case reward(id: AdUnitID)
    
    func createAd() {
        switch self {
        case .interstitial(let id):
            AdMobManager.shared.createAdInterstitialIfNeed(unitId: id)
        case .reward(let id):
            AdMobManager.shared.createAdRewardedIfNeed(unitId: id)
        }
    }
    
    var isExisted: Bool {
        switch self {
        case .interstitial(let id):
            return AdMobManager.shared.getAdInterstitial(unitId: id) != nil
        case .reward(let id):
            return AdMobManager.shared.getAdRewarded(unitId: id) != nil
        }
    }
    
    func presentAd() {
        UIApplication.shared.isStatusBarHidden = true
        switch self {
        case .interstitial(let id):
            AdMobManager.shared.presentAdInterstitial(unitId: id)
        case .reward(let id):
            AdMobManager.shared.presentAdRewarded(unitId: id)
        }
    }
}
